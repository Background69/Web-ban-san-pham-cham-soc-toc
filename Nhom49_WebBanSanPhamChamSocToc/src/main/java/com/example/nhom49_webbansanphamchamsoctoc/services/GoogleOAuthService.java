package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;

import java.io.IOException;
import java.io.InputStream;
import java.security.GeneralSecurityException;
import java.util.Arrays;
import java.util.Collections;
import java.util.Properties;

/**
 * Service xử lý Google OAuth2 authentication
 */
public class GoogleOAuthService {

    private final String clientId;
    private final String clientSecret;
    private final String redirectUri;
    private final String[] scopes;

    private static final GsonFactory JSON_FACTORY = GsonFactory.getDefaultInstance();
    private static final NetHttpTransport HTTP_TRANSPORT = new NetHttpTransport();

    private final GoogleAuthorizationCodeFlow flow;
    private final GoogleIdTokenVerifier verifier;

    /**
     * Constructor - Tải cấu hình từ properties file
     * @throws RuntimeException nếu thiếu cấu hình
     */
    public GoogleOAuthService() {
        Properties props = loadProperties();

        this.clientId = envOrProp(props, "GOOGLE_CLIENT_ID", "google.client.id", null);
        this.clientSecret = envOrProp(props, "GOOGLE_CLIENT_SECRET", "google.client.secret", null);
        this.redirectUri = envOrProp(props, "GOOGLE_REDIRECT_URI", "google.redirect.uri", null);
        String scopesStr = envOrProp(props, "GOOGLE_SCOPES", "google.scopes", "openid,email,profile");
        this.scopes = scopesStr.split(",");

        // Validate cấu hình
        validateConfiguration();

        // Tạo Google Client Secrets
        GoogleClientSecrets.Details web = new GoogleClientSecrets.Details();
        web.setClientId(clientId);
        web.setClientSecret(clientSecret);
        GoogleClientSecrets clientSecrets = new GoogleClientSecrets().setWeb(web);

        // Tạo authorization flow
        this.flow = new GoogleAuthorizationCodeFlow.Builder(
                HTTP_TRANSPORT,
                JSON_FACTORY,
                clientSecrets,
                Arrays.asList(scopes)
        )
                .setAccessType("offline")
                .build();

        // Tạo ID token verifier
        this.verifier = new GoogleIdTokenVerifier.Builder(HTTP_TRANSPORT, JSON_FACTORY)
                .setAudience(Collections.singletonList(clientId))
                .build();
    }

    /**
     * Constructor cho testing
     */
    public GoogleOAuthService(String clientId, String clientSecret, String redirectUri) {
        this.clientId = clientId;
        this.clientSecret = clientSecret;
        this.redirectUri = redirectUri;
        this.scopes = new String[]{"openid", "email", "profile"};

        validateConfiguration();

        GoogleClientSecrets.Details web = new GoogleClientSecrets.Details();
        web.setClientId(clientId);
        web.setClientSecret(clientSecret);
        GoogleClientSecrets clientSecrets = new GoogleClientSecrets().setWeb(web);

        this.flow = new GoogleAuthorizationCodeFlow.Builder(
                HTTP_TRANSPORT,
                JSON_FACTORY,
                clientSecrets,
                Arrays.asList(scopes)
        )
                .setAccessType("offline")
                .build();

        this.verifier = new GoogleIdTokenVerifier.Builder(HTTP_TRANSPORT, JSON_FACTORY)
                .setAudience(Collections.singletonList(clientId))
                .build();
    }

    /**
     * Tải properties từ file
     */
    private Properties loadProperties() {
        Properties props = new Properties();
        try (InputStream input = getClass().getClassLoader()
                .getResourceAsStream("google-oauth.properties")) {
            if (input == null) {
                throw new RuntimeException("Không tìm thấy file google-oauth.properties");
            }
            props.load(input);
        } catch (IOException e) {
            throw new RuntimeException("Không thể đọc file google-oauth.properties", e);
        }
        return props;
    }

    private String envOrProp(Properties props, String envKey, String propKey, String defaultValue) {
        String envVal = System.getenv(envKey);
        if (envVal != null && !envVal.isBlank()) {
            return envVal;
        }
        return props.getProperty(propKey, defaultValue);
    }

    /**
     * Validate cấu hình bắt buộc
     */
    private void validateConfiguration() {
        if (clientId == null || clientId.isEmpty() || clientId.equals("YOUR_GOOGLE_CLIENT_ID")) {
            throw new RuntimeException("Google Client ID chưa được cấu hình");
        }
        if (clientSecret == null || clientSecret.isEmpty() || clientSecret.equals("YOUR_GOOGLE_CLIENT_SECRET")) {
            throw new RuntimeException("Google Client Secret chưa được cấu hình");
        }
        if (redirectUri == null || redirectUri.isEmpty()) {
            throw new RuntimeException("Google Redirect URI chưa được cấu hình");
        }
    }

    /**
     * Tạo URL để redirect user đến Google OAuth
     * @param state Tham số state để chống CSRF
     * @return URL xác thực Google
     */
    public String getAuthorizationUrl(String state) {
        return flow.newAuthorizationUrl()
                .setRedirectUri(redirectUri)
                .setState(state)
                .build();
    }

    /**
     * Xử lý authorization code từ Google callback
     * @param authorizationCode Mã xác thực từ Google
     * @return Thông tin người dùng Google
     */
    public GoogleUserInfo handleCallback(String authorizationCode)
            throws IOException, GeneralSecurityException {

        // Exchange authorization code for tokens
        GoogleTokenResponse tokenResponse = flow.newTokenRequest(authorizationCode)
                .setRedirectUri(redirectUri)
                .execute();

        // Lấy ID token
        String idTokenString = tokenResponse.getIdToken();
        if (idTokenString != null) {
            GoogleIdToken idToken = verifier.verify(idTokenString);
            if (idToken != null) {
                GoogleIdToken.Payload payload = idToken.getPayload();
                return new GoogleUserInfo(
                        payload.getSubject(),
                        payload.getEmail(),
                        (String) payload.get("name"),
                        (String) payload.get("picture")
                );
            }
        }

        throw new RuntimeException("Không thể xác thực ID token từ Google");
    }

    // Getters cho testing
    public String getClientId() {
        return clientId;
    }

    public String getRedirectUri() {
        return redirectUri;
    }

    /**
     * Class chứa thông tin user từ Google
     */
    public static class GoogleUserInfo {
        private final String googleId;
        private final String email;
        private final String name;
        private final String picture;

        public GoogleUserInfo(String googleId, String email, String name, String picture) {
            this.googleId = googleId;
            this.email = email;
            this.name = name;
            this.picture = picture;
        }

        public String getGoogleId() {
            return googleId;
        }

        public String getEmail() {
            return email;
        }

        public String getName() {
            return name;
        }

        public String getPicture() {
            return picture;
        }

        @Override
        public String toString() {
            return "GoogleUserInfo{" +
                    "googleId='" + googleId + '\'' +
                    ", email='" + email + '\'' +
                    ", name='" + name + '\'' +
                    ", picture='" + picture + '\'' +
                    '}';
        }
    }
}
