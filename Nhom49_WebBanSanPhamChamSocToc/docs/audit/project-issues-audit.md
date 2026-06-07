# Executive Summary
- Tổng số issues phát hiện được: **26**
- Số issues theo mức độ:
  - Critical: **4**
  - High: **8**
  - Medium: **11**
  - Low: **3**
- Số issues theo nhóm:
  - Build/Dependency: **2**
  - Code Structure: **1**
  - Database/Schema: **3**
  - Backend Logic: **6**
  - Frontend/JSP Integration: **3**
  - Security/Auth: **7**
  - Deploy/Environment: **3**
  - Documentation/Maintainability: **1**

# Audit Scope
- Đã đọc và đối chiếu:
  - Build/Gradle: `build.gradle`, `settings.gradle`, `gradle.properties`, `gradle/wrapper/gradle-wrapper.properties`, `gradlew`, `gradlew.bat`
  - Web config/resources: `src/main/webapp/WEB-INF/web.xml`, `src/main/resources/db.properties`, `src/main/resources/google-oauth.properties`
  - Source code Java: controllers, services, DAOs, models, filters, utils
  - JSP/CSS/JS trọng yếu cho auth, cart, checkout, order, profile, admin
  - SQL: `test/schema_hairglow_database.sql`, `test/hairglow_seed.sql`, `test/hairglow_seed_bcrypt_password.sql`
  - Test code: `src/test/java/.../DatabaseConnectionTest.java`
- Những gì chưa thể xác nhận chắc chắn:
  - Runtime behavior thực tế trên Tomcat 10.1 do build CLI bị chặn bởi quyền truy cập JDK local.
  - Toàn bộ static assets trong `src/main/webapp/static/images/products` và `src/main/webapp/static/images/brands` do hạn chế quyền đọc trong môi trường audit.
- Những gì chỉ suy luận từ source code:
  - Một số luồng deploy (Docker production-ready) và một phần encoding hiển thị tiếng Việt.
  - Mức độ ảnh hưởng thực tế của các lỗi chart/dashboard đến số liệu business tùy data thật.

# Issues List
## ISSUE-001: Lộ Gmail App Password Trong Source
- Severity: Critical
- Category: Security/Auth
- Status: Open
- Confidence: High
- Summary: Repo chứa trực tiếp thông tin `mail.username` và `mail.app_password`.
- Detailed Description:
  - Cấu hình mail nhạy cảm đang được commit trong `db.properties`.
  - Đây là secret có thể bị lạm dụng để gửi mail trái phép hoặc takeover luồng OTP.
- Evidence:
  - File path: `src/main/resources/db.properties`
  - Snippet: `mail.username=...` (line 10), `mail.app_password=...` (line 11)
- Why it is a problem:
  - Vi phạm nguyên tắc secret management, tăng rủi ro security và compliance.
- Impact:
  - Rủi ro lộ thông tin xác thực SMTP, spam/phishing, OTP abuse.
- How to reproduce or verify:
  1. Mở file `src/main/resources/db.properties`.
  2. Kiểm tra các key mail đang có giá trị thật.
- Suggested Fix Direction:
  - Chuyển toàn bộ secret sang environment/secret manager; rotate credential ngay.
- Related Files:
  - `src/main/resources/db.properties`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/EmailService.java`

## ISSUE-002: Lộ Google OAuth Client Secret Trong Source
- Severity: Critical
- Category: Security/Auth
- Status: Open
- Confidence: High
- Summary: File cấu hình chứa trực tiếp `google.client.secret`.
- Detailed Description:
  - `google-oauth.properties` chứa credentials OAuth thật.
  - Nếu repo bị lộ/public, attacker có thể lợi dụng credential để giả mạo OAuth client.
- Evidence:
  - File path: `src/main/resources/google-oauth.properties`
  - Snippet: `google.client.secret=...` (line 7)
- Why it is a problem:
  - OAuth client secret phải được bảo vệ như password.
- Impact:
  - Rủi ro compromise luồng đăng nhập Google.
- How to reproduce or verify:
  1. Mở file `src/main/resources/google-oauth.properties`.
  2. Kiểm tra key `google.client.secret`.
- Suggested Fix Direction:
  - Bỏ secret khỏi repo, đọc từ env (`GOOGLE_CLIENT_SECRET`), rotate secret trên Google Cloud.
- Related Files:
  - `src/main/resources/google-oauth.properties`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/GoogleOAuthService.java`

## ISSUE-003: Google Redirect URI Cố Định Localhost, Dễ Fail Khi Deploy
- Severity: High
- Category: Deploy/Environment
- Status: Open
- Confidence: High
- Summary: Redirect URI mặc định là localhost và không phản ánh context path deploy thật.
- Detailed Description:
  - Cấu hình OAuth callback hiện là `http://localhost:8080/auth/google/callback`.
  - Khi deploy WAR dưới context path (ví dụ `/Nhom49_WebBanSanPhamChamSocToc`), callback thường không khớp.
- Evidence:
  - `src/main/resources/google-oauth.properties`: `google.redirect.uri=http://localhost:8080/auth/google/callback` (line 10)
  - `GoogleOAuthService` load `redirectUri` từ properties/env (line 40)
- Why it is a problem:
  - OAuth yêu cầu callback URL khớp tuyệt đối, sai sẽ bị từ chối.
- Impact:
  - Google login fail trên môi trường staging/prod.
- How to reproduce or verify:
  1. Deploy WAR không phải ROOT.
  2. Thực hiện login Google.
  3. Quan sát lỗi callback mismatch từ Google OAuth.
- Suggested Fix Direction:
  - Tách config theo môi trường; bắt buộc set `GOOGLE_REDIRECT_URI` chuẩn theo domain/context.
- Related Files:
  - `src/main/resources/google-oauth.properties`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/GoogleOAuthService.java`
  - `HUONG_DAN_CHAY_VMWARE_UBUNTU_DOCKER_DOMAIN.md`

## ISSUE-004: Checkout Không Kiểm Tra Ownership Của `addressId` (IDOR)
- Severity: Critical
- Category: Security/Auth
- Status: Open
- Confidence: High
- Summary: `CheckoutController` lấy địa chỉ theo `addressId` nhưng không ràng buộc user hiện tại.
- Detailed Description:
  - Request gửi `addressId` bất kỳ sẽ được `shippingService.getAddressById(addressId)` lấy ra trực tiếp.
  - Không có điều kiện `address.userId == currentUser.userId` trước khi tạo order.
- Evidence:
  - `CheckoutController`: parse `addressId` -> `shippingService.getAddressById(addressId)` (lines 109-112)
  - `ShippingService.getAddressById(...)` gọi `addressDAO.findById(addressId)` (lines 39-40)
- Why it is a problem:
  - Tạo lỗ hổng Insecure Direct Object Reference.
- Impact:
  - Có thể đặt hàng bằng địa chỉ của user khác (rò rỉ dữ liệu/đơn sai người nhận).
- How to reproduce or verify:
  1. Đăng nhập user A.
  2. Submit POST `/checkout` với `addressId` thuộc user B.
  3. Kiểm tra order tạo ra với địa chỉ không thuộc A.
- Suggested Fix Direction:
  - Đổi truy vấn lấy địa chỉ theo cặp `(addressId, userId)` hoặc kiểm tra ownership trước create order.
- Related Files:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/user/CheckoutController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/ShippingService.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/dao/ShippingAddressDAO.java`

## ISSUE-005: Stored XSS Tại Nội Dung Review
- Severity: Critical
- Category: Security/Auth
- Status: Open
- Confidence: High
- Summary: Nội dung review được lưu và render trực tiếp không escape HTML.
- Detailed Description:
  - Service lưu `content.trim()` nguyên bản vào DB.
  - JSP hiển thị `${review.content}` thay vì `c:out`, có thể thực thi script nếu payload độc hại.
- Evidence:
  - `ReviewService`: `review.setContent(content.trim())` (line 48)
  - `product-detail.jsp`: `<p>${review.content}</p>` (line 688)
- Why it is a problem:
  - Stored XSS ảnh hưởng mọi người dùng truy cập trang sản phẩm.
- Impact:
  - Chiếm session, redirect phishing, deface giao diện.
- How to reproduce or verify:
  1. Submit review với payload HTML/JS.
  2. Mở lại trang product detail.
  3. Quan sát script render/execution.
- Suggested Fix Direction:
  - Escape output (`<c:out>`) và/hoặc sanitize input bằng allowlist.
- Related Files:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/ReviewService.java`
  - `src/main/webapp/user/product/product-detail.jsp`

## ISSUE-006: Admin Order Actions Dùng GET Cho Thao Tác Thay Đổi Trạng Thái
- Severity: High
- Category: Security/Auth
- Status: Open
- Confidence: High
- Summary: `updateStatus`, `confirmPayment`, `delete` đơn hàng chạy qua query GET.
- Detailed Description:
  - `OrderManagementController#doGet` xử lý action thay đổi dữ liệu.
  - JSP tạo link/form GET cho các thao tác nhạy cảm.
- Evidence:
  - Controller: `doGet` xử lý `updateStatus`, `confirmPayment`, `delete` (lines 38-58, 112)
  - `admin/order/list.jsp`: form `method=\"get\"` update status (line 71), link delete (line 105)
  - `admin/order/detail.jsp`: links update/confirm payment (lines 529, 643, 652, 658, 664)
- Why it is a problem:
  - Dễ bị CSRF/clickjacking/crawler-trigger cho hành vi phá hoại.
- Impact:
  - Sai trạng thái đơn, xóa đơn, xác nhận thanh toán ngoài ý muốn.
- How to reproduce or verify:
  1. Mở URL GET trực tiếp với action.
  2. Quan sát DB/order status thay đổi dù không có CSRF token.
- Suggested Fix Direction:
  - Chuyển sang POST/PUT cho mutation; bắt buộc CSRF token và xác thực bổ sung.
- Related Files:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/admin/OrderManagementController.java`
  - `src/main/webapp/admin/order/list.jsp`
  - `src/main/webapp/admin/order/detail.jsp`

## ISSUE-007: Xóa Product/Category/Brand Bằng GET
- Severity: High
- Category: Security/Auth
- Status: Open
- Confidence: High
- Summary: Nhiều module admin dùng GET link để delete.
- Detailed Description:
  - Product, category, brand delete đều map qua GET.
  - Không có CSRF token xác minh chủ đích hành động.
- Evidence:
  - Product link delete: `admin/product/list.jsp` line 324; controller `ProductManagementController#doGet` xử lý `action=delete` (line 54)
  - Category link delete: `admin/category/list.jsp` line 144; controller `CategoryManagementController#doGet` route `/admin/category/delete`
  - Brand link delete: `admin/brand/list.jsp` line 104; controller `BrandManagementController#doGet` route `/admin/brands/delete`
- Why it is a problem:
  - GET phải là idempotent/read-only; dùng GET delete là anti-pattern bảo mật.
- Impact:
  - Dễ trigger xóa dữ liệu ngoài ý muốn.
- How to reproduce or verify:
  1. Mở trực tiếp URL delete bằng browser.
  2. Kiểm tra dữ liệu đã bị xóa/ẩn.
- Suggested Fix Direction:
  - Chuyển sang POST/DELETE + CSRF token + confirm dialog phía server.
- Related Files:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/admin/ProductManagementController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/admin/CategoryManagementController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/admin/BrandManagementController.java`
  - `src/main/webapp/admin/product/list.jsp`
  - `src/main/webapp/admin/category/list.jsp`
  - `src/main/webapp/admin/brand/list.jsp`

## ISSUE-008: Thiếu Cơ Chế CSRF Protection Toàn Cục
- Severity: High
- Category: Security/Auth
- Status: Open
- Confidence: Medium
- Summary: Không thấy CSRF token/filter cho các request thay đổi trạng thái.
- Detailed Description:
  - Source không có lớp filter/token validator CSRF.
  - Nhiều form mutation (`checkout`, `profile/edit`, `admin/save`, `orders/cancel`, ...) submit trực tiếp.
- Evidence:
  - Tìm kiếm trong code không có triển khai `_csrf` hoặc CSRF filter.
  - Ví dụ form mutation:
    - `checkout.jsp` form POST `/checkout` (line 46)
    - `profile-edit.jsp` form `/profile/edit` (line 106)
    - `admin/user/detail.jsp` form update/delete (lines 100, 137)
- Why it is a problem:
  - Browser tự gửi cookie session, request giả mạo từ site khác có thể thành công.
- Impact:
  - Chỉnh sửa thông tin, đặt hàng, thay đổi trạng thái admin trái phép.
- How to reproduce or verify:
  1. Tạo HTML external form POST vào endpoint nội bộ.
  2. Khi admin/user đang đăng nhập, submit form từ external origin.
  3. Quan sát hành vi vẫn được xử lý.
- Suggested Fix Direction:
  - Áp dụng CSRF token per session/request cho toàn bộ mutation endpoint.
- Related Files:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller`
  - `src/main/webapp/user`
  - `src/main/webapp/admin`

## ISSUE-009: Route Upload Avatar Bị Mismatch Giữa JSP Và Controller
- Severity: High
- Category: Frontend/JSP Integration
- Status: Open
- Confidence: High
- Summary: Form avatar submit `/profile/avatar` nhưng controller không có nhánh xử lý.
- Detailed Description:
  - UI hiển thị đầy đủ phần upload avatar.
  - `UserProfileController#doPost` chỉ xử lý `/edit` và `/change-password`.
- Evidence:
  - `profile-edit.jsp`: form action `/profile/avatar` + multipart (lines 85-86)
  - `UserProfileController#doPost`: chỉ branch `/edit` và `/change-password` (lines 166-173)
- Why it is a problem:
  - Luồng người dùng bị gãy (404 hoặc not found) cho chức năng upload avatar.
- Impact:
  - Tính năng profile không hoàn chỉnh; trải nghiệm người dùng kém.
- How to reproduce or verify:
  1. Đăng nhập user.
  2. Vào `/profile/edit`, upload avatar.
  3. Submit và quan sát response 404/SC_NOT_FOUND.
- Suggested Fix Direction:
  - Thêm handler `/avatar` trong controller hoặc chỉnh action JSP về route đã có.
- Related Files:
  - `src/main/webapp/user/profile-edit.jsp`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/user/UserProfileController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/ProfileService.java`

## ISSUE-010: Update Profile Không Lưu `full_name`
- Severity: Medium
- Category: Backend Logic
- Status: Open
- Confidence: High
- Summary: `ProfileService.updateProfile(...)` validate fullname nhưng không set vào entity trước khi update.
- Detailed Description:
  - Service chỉ set username/phone.
  - DAO update câu SQL vẫn bind `full_name` từ object hiện tại -> fullname mới bị bỏ qua.
- Evidence:
  - `ProfileService`: set username/phone (lines 62-63), không có `setFullName(...)`
  - `UserDAO.update`: update `full_name = :fullName` (line 62 + bind line 66)
- Why it is a problem:
  - Người dùng không thể cập nhật họ tên dù form có field fullname.
- Impact:
  - Sai dữ liệu hồ sơ, ảnh hưởng checkout/shipping info hiển thị.
- How to reproduce or verify:
  1. Sửa fullname ở `/profile/edit`.
  2. Lưu thành công.
  3. Refresh profile, fullname không đổi.
- Suggested Fix Direction:
  - Set `user.setFullName(...)` sau sanitize/validate trước khi gọi `userDAO.update`.
- Related Files:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/ProfileService.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/dao/UserDAO.java`

## ISSUE-011: Module Địa Chỉ Đang Cư Xử Theo Single-Address Dù Schema/UI Multi-Address
- Severity: Medium
- Category: Backend Logic
- Status: Open
- Confidence: High
- Summary: `AddressController` dùng `getSingleAddress(...)` cho save/set-default/delete, mâu thuẫn với UI list và schema nhiều địa chỉ.
- Detailed Description:
  - Save sẽ update địa chỉ mặc định đầu tiên thay vì tạo mới bình thường.
  - Set-default/delete cũng phụ thuộc `getSingleAddress` thay vì xử lý theo `addressId` chuẩn multi-address.
- Evidence:
  - `AddressController`: `getSingleAddress` được gọi trong save/set-default/delete (lines 116, 139, 159)
  - `address.jsp`: render danh sách nhiều address card và action theo từng `addressId` (lines 82-119)
  - Schema `shipping_addresses` cho phép nhiều bản ghi/user (lines 229-248)
- Why it is a problem:
  - Logic nghiệp vụ không nhất quán, dễ ghi đè dữ liệu ngoài mong muốn.
- Impact:
  - Người dùng khó quản lý nhiều địa chỉ thực tế.
- How to reproduce or verify:
  1. Tạo nhiều địa chỉ cho một user.
  2. Thực hiện save địa chỉ mới.
  3. Quan sát bản ghi cũ bị update/logic default bất thường.
- Suggested Fix Direction:
  - Chuyển controller sang multi-address chuẩn: create/update/delete theo `addressId` ownership.
- Related Files:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/user/AddressController.java`
  - `src/main/webapp/user/address.jsp`
  - `test/schema_hairglow_database.sql`

## ISSUE-012: `clearCartInDatabase` Rỗng Nhưng Vẫn Được Gọi
- Severity: Medium
- Category: Backend Logic
- Status: Open
- Confidence: High
- Summary: Method cleanup DB cart chưa implement nhưng được gọi sau checkout thành công.
- Detailed Description:
  - `CheckoutController` luôn gọi `cartService.clearCartInDatabase(userId)` sau create order.
  - Method trong `CartService` đang rỗng.
- Evidence:
  - `CheckoutController`: call `clearCartInDatabase` (line 135)
  - `CartService`: method body rỗng (lines 219-220)
- Why it is a problem:
  - Tạo hiểu nhầm đã clear persistent cart dù thực tế không làm gì.
- Impact:
  - Rủi ro inconsistency nếu sau này có DB cart hoặc sync session-db.
- How to reproduce or verify:
  1. Theo dõi call stack checkout.
  2. Xác nhận method không thao tác dữ liệu.
- Suggested Fix Direction:
  - Hoặc implement clear DB cart thật, hoặc bỏ call/method để tránh dead path.
- Related Files:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/user/CheckoutController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/CartService.java`

## ISSUE-013: `privacy.jsp` Include Sai Đường Dẫn Layout
- Severity: Medium
- Category: Frontend/JSP Integration
- Status: Open
- Confidence: High
- Summary: Privacy page include header/footer từ path khác chuẩn project.
- Detailed Description:
  - File privacy dùng `/WEB-INF/views/layout/...` trong khi project dùng `/layout/...`.
  - Các static page khác (`about.jsp`) dùng path đúng.
- Evidence:
  - `privacy.jsp`: include `/WEB-INF/views/layout/header.jsp` (line 197), footer tương tự (line 341)
  - `about.jsp`: include `/layout/header.jsp` (line 250), `/layout/footer.jsp` (line 365)
- Why it is a problem:
  - Có thể gây include fail ở runtime.
- Impact:
  - Trang privacy lỗi layout hoặc throw exception.
- How to reproduce or verify:
  1. Truy cập `/privacy`.
  2. Kiểm tra server log và render page.
- Suggested Fix Direction:
  - Đồng nhất include path theo chuẩn `/layout/header.jsp` và `/layout/footer.jsp`.
- Related Files:
  - `src/main/webapp/user/static-page/privacy.jsp`
  - `src/main/webapp/user/static-page/about.jsp`

## ISSUE-014: Slug Category Ở Footer Không Đồng Bộ Với Slug Trong DB
- Severity: Medium
- Category: Frontend/JSP Integration
- Status: Open
- Confidence: Medium
- Summary: Footer hardcode slug kiểu `dau-goi`, `dau-xa` nhưng seed/schema dùng `shampoo`, `conditioner`, ...
- Detailed Description:
  - Các link filter category từ footer có khả năng không khớp dữ liệu thật.
- Evidence:
  - `layout/footer.jsp`: `category=dau-goi`, `dau-xa`, `kem-u`, `tao-kieu` (lines 41-49)
  - `hairglow_seed.sql`: category slug `shampoo`, `conditioner`, `mask-hair`, `hair-styling-products` (lines 61-69)
- Why it is a problem:
  - Link filter sai -> trả kết quả rỗng/sai danh mục.
- Impact:
  - Broken navigation và giảm chuyển đổi mua hàng.
- How to reproduce or verify:
  1. Click link category ở footer.
  2. So sánh kết quả lọc với dữ liệu categories trong DB.
- Suggested Fix Direction:
  - Đồng bộ slug với dữ liệu DB hoặc map slug alias ở backend.
- Related Files:
  - `src/main/webapp/layout/footer.jsp`
  - `test/hairglow_seed.sql`

## ISSUE-015: Dashboard Bắt Exception Nhưng Không Trả Về View/Response Hợp Lệ
- Severity: Medium
- Category: Backend Logic
- Status: Open
- Confidence: High
- Summary: Catch block chỉ set attribute `dashboardError` rồi kết thúc method.
- Detailed Description:
  - Nếu lỗi xảy ra trước `forward`, request có thể kết thúc không rõ ràng.
  - `dashboard.jsp` cũng không thấy render `dashboardError`.
- Evidence:
  - `AdminDashBoardController`: catch block lines 54-57 không forward/redirect.
  - `dashboard.jsp`: không có binding `dashboardError`.
- Why it is a problem:
  - Error handling không hoàn chỉnh, khó debug và UX xấu.
- Impact:
  - Trang dashboard có thể trắng/lỗi khó hiểu.
- How to reproduce or verify:
  1. Gây lỗi DB ở dashboard query.
  2. Truy cập `/admin/dashboard`.
  3. Quan sát response và log.
- Suggested Fix Direction:
  - Trong catch phải `forward` về trang lỗi hoặc dashboard với thông báo rõ ràng.
- Related Files:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/admin/AdminDashBoardController.java`
  - `src/main/webapp/admin/dashboard.jsp`

## ISSUE-016: Dashboard Năm Bị Hardcode, Dữ Liệu Chart Dễ Lệch Nhãn
- Severity: Medium
- Category: Backend Logic
- Status: Open
- Confidence: High
- Summary: Label year fix cứng `2022..2026`, trong khi query trả list động theo dữ liệu hiện có.
- Detailed Description:
  - Nếu DB có năm khác hoặc ít hơn, `labels` và `values` không còn đồng bộ.
- Evidence:
  - `AdminDashBoardController`: `revenueLabels = [\"2022\",\"2023\",\"2024\",\"2025\",\"2026\"]` (line 73)
  - `OrderDAO.getRevenueByYear()` trả list dynamic (lines 313-318)
- Why it is a problem:
  - Dashboard biểu diễn sai dữ liệu.
- Impact:
  - Báo cáo quản trị sai lệch.
- How to reproduce or verify:
  1. Seed DB chỉ có một vài năm.
  2. Gọi `/admin/dashboard-data?type=year`.
  3. So sánh số nhãn và số value.
- Suggested Fix Direction:
  - Generate labels từ kết quả truy vấn; zero-fill có kiểm soát nếu cần.
- Related Files:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/admin/AdminDashBoardController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/dao/OrderDAO.java`

## ISSUE-017: Query Revenue Dashboard Chưa Chuẩn Business (Status/Sort/Type)
- Severity: Medium
- Category: Database/Schema
- Status: Open
- Confidence: High
- Summary: Revenue by week/month/year đang `SUM(total_amount)` trên mọi order status, không sort rõ ràng, map về `int`.
- Detailed Description:
  - Query không loại trừ đơn cancelled/pending.
  - Group kết quả không có `ORDER BY`.
  - Số tiền map bằng `rs.getInt(\"total\")` mất phần thập phân và có nguy cơ overflow.
- Evidence:
  - `OrderDAO.getRevenueByWeek/Month/Year` (lines 297-318)
  - `map((rs, ctx) -> rs.getInt(\"total\"))` (lines 301, 309, 317)
- Why it is a problem:
  - KPI tài chính có thể sai đáng kể.
- Impact:
  - Quyết định vận hành dựa trên số liệu sai.
- How to reproduce or verify:
  1. Tạo order status hỗn hợp + amount lớn.
  2. So sánh query hiện tại với query chỉ completed.
- Suggested Fix Direction:
  - Chốt business rule status được tính doanh thu; dùng `BigDecimal/Long`; thêm `ORDER BY`.
- Related Files:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/dao/OrderDAO.java`

## ISSUE-018: `getOrderStatusStats` Dùng Trạng Thái Legacy Không Có Trong Schema
- Severity: Low
- Category: Database/Schema
- Status: Open
- Confidence: High
- Summary: Query cộng thêm `done`/`canceled` dù enum schema chuẩn là `completed`/`cancelled`.
- Detailed Description:
  - Đây là dấu hiệu leftover từ schema cũ.
  - Dù không phá runtime ngay, tạo nhiễu logic thống kê.
- Evidence:
  - `OrderDAO.getOrderStatusStats()` SQL chứa `('completed','done')`, `('cancelled','canceled')` (line 331)
  - Schema `orders.order_status` và `order_status_history.status` chỉ có `pending|confirmed|shipping|completed|cancelled` (lines 266, 367)
- Why it is a problem:
  - Dễ gây nhầm lẫn khi maintain và chuẩn hóa dữ liệu.
- Impact:
  - Thống kê khó audit, tiêu chuẩn trạng thái không nhất quán.
- How to reproduce or verify:
  1. Đối chiếu enum trong schema với query thống kê.
- Suggested Fix Direction:
  - Xóa alias legacy khỏi query, thống nhất enum duy nhất.
- Related Files:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/dao/OrderDAO.java`
  - `test/schema_hairglow_database.sql`

## ISSUE-019: Admin Update Status Bỏ Qua Cơ Chế Ghi `order_status_history`
- Severity: High
- Category: Database/Schema
- Status: Open
- Confidence: High
- Summary: Admin controller update trạng thái trực tiếp qua DAO, không đi qua service có append history.
- Detailed Description:
  - Luồng chuẩn trong `OrderService.updateOrderStatus(...)` có insert `order_status_history`.
  - `OrderManagementController` gọi trực tiếp `orderDAO.updateStatus(...)`.
- Evidence:
  - `OrderManagementController`: `orderDAO.updateStatus(orderId, status);` (line 112)
  - `OrderService`: insert history SQL (line 136), `updateOrderStatus(...)` (lines 272-289)
- Why it is a problem:
  - Mất audit trail thay đổi trạng thái từ admin.
- Impact:
  - Không truy vết đầy đủ lifecycle order.
- How to reproduce or verify:
  1. Đổi trạng thái order từ trang admin.
  2. Kiểm tra bảng `order_status_history` thiếu bản ghi tương ứng.
- Suggested Fix Direction:
  - Bắt buộc controller gọi `OrderService.updateOrderStatus(...)` thay vì DAO trực tiếp.
- Related Files:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/admin/OrderManagementController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/OrderService.java`
  - `test/schema_hairglow_database.sql`

## ISSUE-020: Checkout Hiển Thị `momo` Nhưng Không Có Backend Payment Flow
- Severity: High
- Category: Backend Logic
- Status: Open
- Confidence: High
- Summary: UI cho phép chọn `momo`, nhưng backend không có xử lý transaction/verify tương ứng.
- Detailed Description:
  - Checkout set `paymentMethod='momo'` và vẫn tạo order bình thường.
  - Không có controller/service nào triển khai MoMo callback/confirm/transaction.
- Evidence:
  - `checkout.jsp`: option `selectPayment(..., 'momo')` (line 196)
  - Search backend Java: `momo` chỉ xuất hiện trong `Order` model (line 22, 217), không có payment controller/service riêng.
- Why it is a problem:
  - Nghiệp vụ thanh toán không nhất quán: order có thể đi tiếp mà chưa có xác nhận thanh toán thực.
- Impact:
  - Rủi ro thất thoát doanh thu, sai trạng thái thanh toán.
- How to reproduce or verify:
  1. Chọn momo ở checkout.
  2. Hoàn tất đặt hàng.
  3. Kiểm tra không có transaction flow tương ứng.
- Suggested Fix Direction:
  - Tạm ẩn option momo hoặc hoàn thiện full flow (create transaction, callback verify, trạng thái).
- Related Files:
  - `src/main/webapp/user/cart/checkout.jsp`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/user/CheckoutController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/model/Order.java`

## ISSUE-021: Upload Ảnh Product Ghi Vào `getRealPath` Trong Webapp (Không Bền Vững Khi Deploy)
- Severity: High
- Category: Deploy/Environment
- Status: Open
- Confidence: High
- Summary: Ảnh upload được ghi trực tiếp vào thư mục deploy của Tomcat.
- Detailed Description:
  - Dùng `getServletContext().getRealPath(...)` để lấy path runtime và `Part.write(...)` vào đó.
  - Cách này không bền trong container immutable/scale-out/redeploy.
- Evidence:
  - `ProductManagementController`: `getRealPath(relativeDir)` (line 156), `imagePart.write(...)` (line 168)
- Why it is a problem:
  - Dữ liệu media dễ mất sau redeploy hoặc khi chạy nhiều instance.
- Impact:
  - Mất ảnh sản phẩm, lỗi hiển thị production.
- How to reproduce or verify:
  1. Upload ảnh mới ở admin.
  2. Redeploy container/WAR.
  3. Kiểm tra ảnh có còn tồn tại không.
- Suggested Fix Direction:
  - Lưu media ra volume persistent hoặc object storage; DB chỉ giữ URL.
- Related Files:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/admin/ProductManagementController.java`

## ISSUE-022: Chưa Có Dockerfile/Compose Chuẩn Trong Repo
- Severity: Medium
- Category: Deploy/Environment
- Status: Open
- Confidence: High
- Summary: Repo hiện không có manifest Docker chuẩn để dựng app + DB reproducible.
- Detailed Description:
  - Tài liệu deploy xác nhận phải chạy thủ công bằng image official, chưa có Dockerfile/compose tích hợp.
- Evidence:
  - Root repo không có file `Dockerfile`/`docker-compose.yml`
  - `HUONG_DAN_CHAY_VMWARE_UBUNTU_DOCKER_DOMAIN.md`: line 145 nêu rõ chưa có Dockerfile/compose chuẩn
- Why it is a problem:
  - Khó tái lập môi trường, onboarding tốn công, dễ sai cấu hình.
- Impact:
  - Rủi ro fail deploy local VM/VPS.
- How to reproduce or verify:
  1. Kiểm tra root repo không có Docker manifest.
  2. Đọc tài liệu hướng dẫn deploy hiện tại.
- Suggested Fix Direction:
  - Bổ sung `Dockerfile` + `docker-compose.yml` + `.env.example` và healthcheck.
- Related Files:
  - `HUONG_DAN_CHAY_VMWARE_UBUNTU_DOCKER_DOMAIN.md`

## ISSUE-023: Build CLI Bị Chặn Bởi Quyền Truy Cập JDK (Không Kết Luận Là Lỗi Code)
- Severity: Low
- Category: Build/Dependency
- Status: Open
- Confidence: High
- Summary: `gradlew clean assemble` fail do `AccessDeniedException` vào file `java.security`.
- Detailed Description:
  - Build fail trước cả bước compile source.
  - Đây là vấn đề environment/JDK ACL, không đủ bằng chứng để kết luận compile code fail.
- Evidence:
  - Command: `.\gradlew.bat --no-daemon clean assemble`
  - Error: `java.lang.InternalError: Error loading java.security file`
  - Cause: `AccessDeniedException: C:\\Users\\Admin\\.jdks\\corretto-24.0.2\\conf\\security\\java.security`
- Why it is a problem:
  - Chặn verification pipeline từ CLI.
- Impact:
  - Không thể phân biệt ngay lỗi code thật với lỗi môi trường.
- How to reproduce or verify:
  1. Chạy lại lệnh Gradle wrapper trong máy hiện tại.
  2. Quan sát stacktrace quyền truy cập JDK.
- Suggested Fix Direction:
  - Sửa quyền đọc JDK/JAVA_HOME hoặc chọn JDK khác; sau đó rerun build để kết luận code-level.
- Related Files:
  - `gradlew.bat`
  - `build.gradle`

## ISSUE-024: Mismatch Rủi Ro Giữa Servlet API Compile (6.1.0) Và Runtime Tomcat 10.1 (Servlet 6.0)
- Severity: Medium
- Category: Build/Dependency
- Status: Open
- Confidence: Medium
- Summary: Build đang `compileOnly jakarta.servlet-api:6.1.0` trong khi web.xml là 6.0 và target runtime là Tomcat 10.1.
- Detailed Description:
  - Nếu code dùng API mới của 6.1, runtime 6.0 có thể thiếu method/class.
- Evidence:
  - `build.gradle`: `compileOnly 'jakarta.servlet:jakarta.servlet-api:6.1.0'` (line 21)
  - `web.xml`: `version=\"6.0\"`
  - Bối cảnh project: target Tomcat 10.1 (Servlet 6.0)
- Why it is a problem:
  - Tạo rủi ro tương thích runtime khó phát hiện sớm.
- Impact:
  - Có thể phát sinh lỗi runtime sau deploy.
- How to reproduce or verify:
  1. Chạy app trên Tomcat 10.1 với code dùng API mới.
  2. Theo dõi lỗi `NoSuchMethodError`/`ClassNotFoundException` nếu có.
- Suggested Fix Direction:
  - Căn version compile API đúng runtime (6.0) hoặc nâng runtime tương ứng.
- Related Files:
  - `build.gradle`
  - `src/main/webapp/WEB-INF/web.xml`

## ISSUE-025: Code/Dependency Thừa Và Dead Path
- Severity: Low
- Category: Code Structure
- Status: Open
- Confidence: Medium
- Summary: Có class rỗng và dependency chưa dùng, làm tăng nhiễu maintain.
- Detailed Description:
  - `OtpService` hiện là class rỗng.
  - Một số dependency trong Gradle không thấy usage trực tiếp (dotenv, slf4j, jdbi-sqlobject).
  - `PromotionDAO` tồn tại nhưng không thấy được gọi từ service/controller.
- Evidence:
  - `OtpService.java`: chỉ có `public class OtpService {}` (lines 3-4)
  - `build.gradle`: có `dotenv-java`, `slf4j-*`, `jdbi3-sqlobject`
  - Search usage `PromotionDAO` chỉ ra class declaration
- Why it is a problem:
  - Tăng độ phức tạp codebase, khó audit dependency, khó maintain.
- Impact:
  - Build nặng hơn, khó đọc kiến trúc thật, tăng tech debt.
- How to reproduce or verify:
  1. Mở class/dependency nêu trên.
  2. Tìm kiếm usage trong toàn bộ source.
- Suggested Fix Direction:
  - Xóa dependency/class không dùng hoặc hoàn thiện flow dùng thực tế.
- Related Files:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/OtpService.java`
  - `build.gradle`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/dao/PromotionDAO.java`

## ISSUE-026: Test Coverage Quá Ít, Chủ Yếu Kiểm Tra Kết Nối DB Thật
- Severity: Medium
- Category: Documentation/Maintainability
- Status: Open
- Confidence: High
- Summary: Chỉ có 1 test class chính, phụ thuộc DB thật, thiếu unit/integration test cho business flow.
- Detailed Description:
  - `DatabaseConnectionTest` kiểm tra connect/query cơ bản và tồn tại table.
  - Không thấy test cho auth/cart/checkout/order/review/admin controller/service.
- Evidence:
  - Chỉ có file test Java: `src/test/java/.../DatabaseConnectionTest.java`
  - Các test SQL là data scripts, không phải test behavior.
- Why it is a problem:
  - Khó phát hiện regression khi sửa code.
- Impact:
  - Dễ phát sinh lỗi runtime nghiệp vụ sau thay đổi.
- How to reproduce or verify:
  1. Liệt kê toàn bộ thư mục test.
  2. Kiểm tra số lượng và loại test hiện có.
- Suggested Fix Direction:
  - Bổ sung unit test service layer + integration test controller (mock/testcontainers).
- Related Files:
  - `src/test/java/com/example/nhom49_webbansanphamchamsoctoc/database/DatabaseConnectionTest.java`
  - `test/schema_hairglow_database.sql`
  - `test/hairglow_seed.sql`

# Issue Tables For Export
| ID | Title | Severity | Category | Confidence | Impact | Main File | Suggested Fix Direction | Notes |
|---|---|---|---|---|---|---|---|---|
| ISSUE-001 | Lộ Gmail App Password Trong Source | Critical | Security/Auth | High | Secret leak, OTP abuse | `src/main/resources/db.properties` | Chuyển secret sang env, rotate ngay | Không commit credential thật |
| ISSUE-002 | Lộ Google OAuth Client Secret Trong Source | Critical | Security/Auth | High | OAuth credential compromise | `src/main/resources/google-oauth.properties` | Dùng env + rotate secret | Ảnh hưởng login Google |
| ISSUE-003 | Redirect URI OAuth Cố Định Localhost | High | Deploy/Environment | High | OAuth fail khi deploy | `src/main/resources/google-oauth.properties` | Config theo môi trường | Cần URL callback khớp tuyệt đối |
| ISSUE-004 | Checkout Address IDOR | Critical | Security/Auth | High | Tạo đơn bằng địa chỉ user khác | `controller/user/CheckoutController.java` | Verify address ownership | Lỗi nghiệp vụ + bảo mật |
| ISSUE-005 | Stored XSS Review Content | Critical | Security/Auth | High | Script injection cho người xem | `user/product/product-detail.jsp` | Escape output + sanitize input | Dữ liệu user-generated |
| ISSUE-006 | Admin Order Mutation Qua GET | High | Security/Auth | High | CSRF, accidental mutation | `controller/admin/OrderManagementController.java` | Chuyển sang POST + CSRF | update/confirm/delete |
| ISSUE-007 | Delete Product/Category/Brand Qua GET | High | Security/Auth | High | CSRF, data loss | `admin/*/list.jsp` + controllers | Dùng POST/DELETE + CSRF | Không nên mutate bằng GET |
| ISSUE-008 | Thiếu CSRF Protection Toàn Cục | High | Security/Auth | Medium | Cross-site forged actions | `src/main/java/controller` | Thêm CSRF token/filter | Áp dụng toàn bộ mutation endpoint |
| ISSUE-009 | Avatar Upload Route Mismatch | High | Frontend/JSP Integration | High | Tính năng upload avatar hỏng | `user/profile-edit.jsp` | Thêm handler `/profile/avatar` | Hiện đang 404/not found |
| ISSUE-010 | Update Profile Không Lưu Fullname | Medium | Backend Logic | High | Dữ liệu profile sai | `services/ProfileService.java` | Set `fullName` trước update | Validate có nhưng không persist |
| ISSUE-011 | Logic Address Không Nhất Quán Multi-Address | Medium | Backend Logic | High | Ghi đè/sai địa chỉ | `controller/user/AddressController.java` | Refactor theo `addressId` | UI + schema hỗ trợ nhiều địa chỉ |
| ISSUE-012 | `clearCartInDatabase` Chưa Implement | Medium | Backend Logic | High | Dead path/inconsistency | `services/CartService.java` | Implement hoặc remove call | Đang được gọi sau checkout |
| ISSUE-013 | Privacy JSP Include Sai Path | Medium | Frontend/JSP Integration | High | Trang privacy lỗi layout/include | `user/static-page/privacy.jsp` | Đồng bộ include path layout | Khác chuẩn các page còn lại |
| ISSUE-014 | Footer Category Slug Mismatch | Medium | Frontend/JSP Integration | Medium | Link lọc category sai/rỗng | `layout/footer.jsp` | Đồng bộ slug với DB | `dau-goi` vs `shampoo` |
| ISSUE-015 | Dashboard Catch Không Forward | Medium | Backend Logic | High | Response lỗi khó hiểu | `controller/admin/AdminDashBoardController.java` | Forward/render lỗi chuẩn | `dashboardError` không được hiển thị |
| ISSUE-016 | Dashboard Year Labels Hardcode | Medium | Backend Logic | High | Chart lệch labels/values | `controller/admin/AdminDashBoardController.java` | Generate labels động | Fix cứng 2022..2026 |
| ISSUE-017 | Revenue Query Chưa Chuẩn Status/Type/Sort | Medium | Database/Schema | High | KPI tài chính sai | `dao/OrderDAO.java` | Filter status + BigDecimal + ORDER BY | Hiện map `int` |
| ISSUE-018 | Status Stats Dùng Legacy Enum | Low | Database/Schema | High | Nhiễu thống kê | `dao/OrderDAO.java` | Chuẩn hóa enum theo schema | `done/canceled` legacy |
| ISSUE-019 | Admin Status Update Bypass History | High | Database/Schema | High | Mất audit trail | `controller/admin/OrderManagementController.java` | Dùng `OrderService.updateOrderStatus` | Không insert `order_status_history` |
| ISSUE-020 | Option `momo` Chưa Có Backend Flow | High | Backend Logic | High | Thanh toán không được xác minh | `user/cart/checkout.jsp` | Ẩn option hoặc implement full flow | Chỉ thấy ở UI/model |
| ISSUE-021 | Upload Ảnh Bằng `getRealPath` | High | Deploy/Environment | High | Mất media sau redeploy | `controller/admin/ProductManagementController.java` | Dùng storage bền vững | Không phù hợp container |
| ISSUE-022 | Chưa Có Dockerfile/Compose Chuẩn | Medium | Deploy/Environment | High | Deploy khó tái lập | `HUONG_DAN_CHAY_VMWARE_UBUNTU_DOCKER_DOMAIN.md` | Bổ sung Docker manifests | Hiện hướng dẫn chạy thủ công |
| ISSUE-023 | Build CLI Fail Do JDK ACL (Env) | Low | Build/Dependency | High | Chặn verify compile | `gradlew.bat` run output | Sửa quyền JDK/JAVA_HOME | Không kết luận lỗi code |
| ISSUE-024 | Servlet API Compile 6.1 vs Runtime 6.0 Risk | Medium | Build/Dependency | Medium | Rủi ro runtime incompatibility | `build.gradle` | Align API version với runtime | Tomcat 10.1 target |
| ISSUE-025 | Dead/Unused Code & Dependencies | Low | Code Structure | Medium | Tăng tech debt | `services/OtpService.java` | Xóa hoặc hoàn thiện phần dư | Bao gồm dep unused |
| ISSUE-026 | Test Coverage Ít Và Cột Chặt Vào DB Thật | Medium | Documentation/Maintainability | High | Regression khó phát hiện | `src/test/java/.../DatabaseConnectionTest.java` | Thêm unit/integration tests | Thiếu test nghiệp vụ chính |

# Priority Recommendations
Top 10 issue nên xử lý trước (ưu tiên theo tác động build/runtime/nghiệp vụ/bảo mật/deploy):
1. ISSUE-001: Lộ Gmail App Password Trong Source
2. ISSUE-002: Lộ Google OAuth Client Secret Trong Source
3. ISSUE-004: Checkout Address IDOR
4. ISSUE-005: Stored XSS Review Content
5. ISSUE-006: Admin Order Mutation Qua GET
6. ISSUE-008: Thiếu CSRF Protection Toàn Cục
7. ISSUE-007: Delete Product/Category/Brand Qua GET
8. ISSUE-020: Option `momo` Chưa Có Backend Flow
9. ISSUE-021: Upload Ảnh Bằng `getRealPath`
10. ISSUE-019: Admin Status Update Bypass History
