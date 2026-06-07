# Project Overview
- Hệ thống là website bán sản phẩm chăm sóc tóc theo mô hình `Guest`/`Customer`/`Admin`, kiến trúc Jakarta EE Servlet/JSP + JDBI + MySQL.
- Mục tiêu chính: hiển thị catalog sản phẩm, đặt hàng online, theo dõi đơn, đánh giá sản phẩm, và quản trị dữ liệu bán hàng ở phía admin.
- Actor chính: Guest, Customer/User, Admin.

# Actors
- Guest
- Customer/User (đăng nhập local hoặc Google OAuth)
- Admin
- External Systems:
  - Gmail SMTP (gửi OTP)
  - Google OAuth2
  - VietQR API (QR chuyển khoản)
  - MySQL DB

# Functional Modules
- Authentication:
  - Đăng ký + OTP verify
  - Đăng nhập local
  - Đăng nhập Google OAuth
  - Quên mật khẩu + OTP + reset
  - Đăng xuất
- Catalog:
  - Trang chủ
  - Danh sách sản phẩm (`/products`, `/store`, `/search`)
  - Lọc/sort/pagination
  - Chi tiết sản phẩm + biến thể
  - Flash sale
  - Thương hiệu
- Cart & Checkout:
  - Thêm giỏ, cập nhật số lượng, xóa item, xóa giỏ
  - Checkout (địa chỉ, shipping, payment)
  - Tạo đơn hàng
  - Thanh toán chuyển khoản (VietQR)
- Order & Review:
  - Lịch sử đơn hàng
  - Chi tiết đơn
  - Hủy đơn pending
  - Đánh giá sản phẩm (verified purchase)
- Profile:
  - Tổng quan tài khoản
  - Chỉnh sửa thông tin
  - Đổi mật khẩu
  - Quản lý địa chỉ
- Admin:
  - Dashboard
  - Quản lý user
  - Quản lý sản phẩm
  - Quản lý danh mục
  - Quản lý thương hiệu
  - Quản lý đơn hàng
  - Quản lý flash sale

# Use Cases
## UC-AUTH-01
- Use Case ID: UC-AUTH-01
- Tên use case: Đăng ký tài khoản
- Actor: Guest
- Mục tiêu: Tạo phiên đăng ký chờ xác minh OTP
- Preconditions: Guest chưa đăng nhập
- Trigger: Submit form tại `/authentication/register.jsp`
- Main Flow:
  1. Guest nhập email/fullname/username/phone/password.
  2. `RegisterController#doPost` validate input qua `AuthenticationService.validateUserInput(...)`.
  3. Hash password (`PasswordUtil.hashPassword`).
  4. Sinh OTP, lưu vào `pending_registration` qua `PendingRegistrationDAO.upsertPending(...)`.
  5. Gửi OTP email (`EmailService.sendRegisterOtpEmail`).
  6. Set session OTP context và redirect `/auth/verify-otp`.
- Alternative Flows:
  - Email gửi fail: vẫn vào OTP page nhưng có lỗi hiển thị.
- Exception Flows:
  - Validate fail hoặc upsert fail: forward lại register với lỗi.
- Postconditions:
  - Có record pending registration, chờ verify OTP.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/authentication/RegisterController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/AuthenticationService.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/dao/PendingRegistrationDAO.java`
  - `src/main/webapp/authentication/register.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Hoàn thiện ở mức chạy được.

## UC-AUTH-02
- Use Case ID: UC-AUTH-02
- Tên use case: Xác minh OTP đăng ký
- Actor: Guest
- Mục tiêu: Kích hoạt tài khoản từ pending registration
- Preconditions: Có session `otpPurpose=REGISTER`, có pendingId
- Trigger: Submit OTP tại `/auth/verify-otp`
- Main Flow:
  1. `OtpController#doPost` parse mục đích OTP từ session.
  2. Với purpose REGISTER, đọc pending registration.
  3. Check expiry/attempts/code.
  4. Gọi `PendingRegistrationDAO.createUserAndConsumePending(...)`.
  5. Xóa session OTP context, redirect `/auth/login` với thông báo success.
- Alternative Flows:
  - OTP sai: tăng attempts, forward lỗi.
- Exception Flows:
  - Session thiếu context: redirect `/auth/register` hoặc `/auth/login`.
- Postconditions:
  - User mới được insert vào `users`, pending được consume.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/authentication/OtpController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/dao/PendingRegistrationDAO.java`
  - `src/main/webapp/authentication/otp-verification.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Hoàn thiện tốt.

## UC-AUTH-03
- Use Case ID: UC-AUTH-03
- Tên use case: Gửi lại OTP
- Actor: Guest
- Mục tiêu: Resend OTP với cooldown
- Preconditions: Session có `otpPendingEmail` + `otpPurpose`
- Trigger: Submit form resend OTP tại OTP page
- Main Flow:
  1. `ResendOtpController#doPost` check cooldown 45s.
  2. Sinh OTP mới và cập nhật DB (`pending_registration` hoặc `otp_verification`).
  3. Gửi email OTP mới.
  4. Cập nhật `otpLastSentAt`, `otpExpiryAt`, forward lại OTP page.
- Alternative Flows:
  - Chưa hết cooldown: báo số giây còn lại.
- Exception Flows:
  - Session context thiếu: redirect login/flow tương ứng.
- Postconditions:
  - OTP mới được tạo, OTP cũ không còn hiệu lực theo luồng.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/authentication/ResendOtpController.java`
  - `src/main/webapp/authentication/otp-verification.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Hoàn thiện.

## UC-AUTH-04
- Use Case ID: UC-AUTH-04
- Tên use case: Đăng nhập local
- Actor: Guest
- Mục tiêu: Tạo session người dùng đã xác thực
- Preconditions: Tài khoản đã tồn tại và active
- Trigger: Submit form `/auth/login`
- Main Flow:
  1. `LoginController#doPost` nhận email/username + password.
  2. `AuthenticationService.login(...)` kiểm tra user và BCrypt password.
  3. `SessionUtil.setCurrentUser(...)` set cả key `user` và `currentUser`.
  4. Redirect về URL hợp lệ hoặc home.
- Alternative Flows:
  - Đăng nhập với username thay cho email.
- Exception Flows:
  - Sai thông tin/khóa account: forward lại login với lỗi.
- Postconditions:
  - Session user hợp lệ được tạo, có role.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/authentication/LoginController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/AuthenticationService.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/util/SessionUtil.java`
  - `src/main/webapp/authentication/login.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Hoàn thiện.

## UC-AUTH-05
- Use Case ID: UC-AUTH-05
- Tên use case: Đăng nhập Google OAuth
- Actor: Guest
- Mục tiêu: Đăng nhập/tạo account qua Google
- Preconditions: Cấu hình OAuth hợp lệ
- Trigger: Click nút Google tại login/register
- Main Flow:
  1. `GoogleOAuthController` tạo `state` và redirect Google auth URL.
  2. Callback nhận `code`, verify token qua `GoogleOAuthService`.
  3. `UserService.findOrCreateGoogleUser(...)` tạo hoặc map user hiện có.
  4. Set session user và redirect sau login.
- Alternative Flows:
  - Nếu OAuth config không hợp lệ: redirect login với `oauth_not_configured`.
- Exception Flows:
  - State mismatch/token lỗi: redirect login với mã lỗi tương ứng.
- Postconditions:
  - User đăng nhập bằng provider GOOGLE.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/authentication/GoogleOAuthController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/GoogleOAuthService.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/UserService.java`
  - `src/main/resources/google-oauth.properties`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Có đầy đủ luồng, nhưng có rủi ro cấu hình deploy (chi tiết trong issue file).

## UC-AUTH-06
- Use Case ID: UC-AUTH-06
- Tên use case: Quên mật khẩu + OTP + đặt lại mật khẩu
- Actor: Guest
- Mục tiêu: Reset mật khẩu tài khoản local
- Preconditions: Email tồn tại, OTP hợp lệ
- Trigger: `/auth/forgot-password` -> `/auth/verify-otp` -> `/reset-password`
- Main Flow:
  1. `ForgotPasswordController` nhận email, tạo OTP purpose FORGOT_PASSWORD.
  2. Gửi OTP qua mail.
  3. `OtpController` verify OTP purpose FORGOT_PASSWORD.
  4. Set session `otpVerifiedUserId`.
  5. `ResetPasswordController` validate mật khẩu mới, hash và update DB.
- Alternative Flows:
  - Email không tồn tại: trả thông báo chung, không lộ tồn tại account.
- Exception Flows:
  - OTP sai/hết hạn/quá số lần thử: báo lỗi.
- Postconditions:
  - Password mới được lưu bằng BCrypt.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/authentication/ForgotPasswordController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/authentication/OtpController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/authentication/ResetPasswordController.java`
  - `src/main/webapp/authentication/forgot-password.jsp`
  - `src/main/webapp/authentication/forgot-password-reset.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Hoàn thiện.

## UC-AUTH-07
- Use Case ID: UC-AUTH-07
- Tên use case: Đăng xuất
- Actor: Customer/Admin
- Mục tiêu: Hủy session đăng nhập
- Preconditions: Đang đăng nhập
- Trigger: gọi `/auth/logout`
- Main Flow:
  1. `LogoutController` gọi `AuthenticationService.logout(session)`.
  2. Xóa key user/cart và invalidate session.
  3. Redirect về trang chủ.
- Alternative Flows: Không.
- Exception Flows: Không đáng kể.
- Postconditions: Session cũ không còn hiệu lực.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/authentication/LogoutController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/AuthenticationService.java`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Hoàn thiện.

## UC-PROD-01
- Use Case ID: UC-PROD-01
- Tên use case: Xem danh sách sản phẩm và lọc
- Actor: Guest/Customer
- Mục tiêu: Tìm sản phẩm phù hợp
- Preconditions: Không bắt buộc đăng nhập
- Trigger: truy cập `/products`, `/store`, `/search`
- Main Flow:
  1. `ProductListController#doGet` đọc params category/brand/hairCondition/search/price/sort/page.
  2. `ProductService` trả danh sách product không on-sale (`getAllProductsExcludingOnSale`).
  3. Controller lọc/sort/paginate ở tầng Java.
  4. Forward `/user/product/product-list.jsp`.
- Alternative Flows:
  - Search qua nhiều key (`search`, `q`, `keyword`).
- Exception Flows:
  - Param không hợp lệ: fallback giá trị mặc định.
- Postconditions:
  - UI hiển thị danh sách theo filter/sort.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/user/ProductListController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/ProductService.java`
  - `src/main/webapp/user/product/product-list.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Hoàn thiện; có một số link category tĩnh không đồng bộ slug (xem issue).

## UC-PROD-02
- Use Case ID: UC-PROD-02
- Tên use case: Xem chi tiết sản phẩm và chọn variant
- Actor: Guest/Customer
- Mục tiêu: Xem thông tin đầy đủ và chuẩn bị mua
- Preconditions: Product slug hợp lệ
- Trigger: truy cập `/product/{slug}`
- Main Flow:
  1. `ProductDetailController#doGet` parse slug, tìm product.
  2. Nạp related products, reviews, rating stats.
  3. Nếu có session user thì check khả năng review (`canUserReviewProduct`).
  4. Forward `/user/product/product-detail.jsp`.
- Alternative Flows:
  - Product không tồn tại: trả 404.
- Exception Flows: Không đáng kể.
- Postconditions: Có dữ liệu product, variants, reviews trên view.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/user/ProductDetailController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/ReviewService.java`
  - `src/main/webapp/user/product/product-detail.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Hoàn thiện.

## UC-CART-01
- Use Case ID: UC-CART-01
- Tên use case: Thêm vào giỏ hàng / Mua ngay
- Actor: Customer
- Mục tiêu: Đưa variant vào cart
- Preconditions: Đăng nhập, variant hợp lệ
- Trigger: Submit form `/cart/add` tại product detail/list
- Main Flow:
  1. `AddCartController#doPost` kiểm tra đăng nhập.
  2. Parse variantId/quantity, fallback default variant theo productId.
  3. `CartService.addToCart(...)` cập nhật cart trong session.
  4. Nếu action `buy_now` thì redirect `/checkout`, ngược lại `/cart`.
- Alternative Flows:
  - AJAX request trả JSON kết quả.
- Exception Flows:
  - Chưa đăng nhập: redirect login có kèm redirect path.
- Postconditions: Cart session được cập nhật.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/cart/AddCartController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/CartService.java`
  - `src/main/webapp/user/product/product-detail.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Hoàn thiện.

## UC-CART-02
- Use Case ID: UC-CART-02
- Tên use case: Cập nhật giỏ hàng / xóa item / xóa toàn bộ
- Actor: Customer
- Mục tiêu: Điều chỉnh cart trước checkout
- Preconditions: Cart tồn tại trong session
- Trigger: Các form `/cart/update`, `/cart/remove`, `/cart/clear`
- Main Flow:
  1. `SetQuantityCartController` cập nhật quantity hoặc remove nếu quantity=0.
  2. `RemoveCartController` xóa item cụ thể.
  3. `ClearCartController` xóa toàn bộ cart.
  4. Redirect `/cart` và hiển thị thông báo.
- Alternative Flows: Không.
- Exception Flows:
  - Variant/quantity không hợp lệ: set error trong session.
- Postconditions: Cart phản ánh thao tác mới nhất.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/cart/SetQuantityCartController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/cart/RemoveCartController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/cart/ClearCartController.java`
  - `src/main/webapp/user/cart/cart.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Hoàn thiện.

## UC-ORDER-01
- Use Case ID: UC-ORDER-01
- Tên use case: Checkout và tạo đơn COD
- Actor: Customer
- Mục tiêu: Tạo đơn hàng từ cart
- Preconditions: Đăng nhập, cart không rỗng, stock hợp lệ
- Trigger: Submit `/checkout` với payment `cod`
- Main Flow:
  1. `CheckoutController#doPost` validate login/cart/stock.
  2. Lấy địa chỉ giao hàng (addressId hoặc form địa chỉ mới).
  3. `OrderService.createOrder(...)` insert `orders`, `order_items`, `order_status_history`, trừ tồn kho.
  4. Xóa cart session và redirect order detail.
- Alternative Flows:
  - Nếu không có addressId, tạo địa chỉ mới qua `ShippingService.createAddress`.
- Exception Flows:
  - Stock fail / address fail / create order fail: quay lại checkout với lỗi.
- Postconditions:
  - Tạo order status `pending`, cart được clear ở session.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/user/CheckoutController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/OrderService.java`
  - `src/main/webapp/user/cart/checkout.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Có vận hành, nhưng có vấn đề ownership address và clearCartInDatabase (xem issue).

## UC-ORDER-02
- Use Case ID: UC-ORDER-02
- Tên use case: Checkout và thanh toán chuyển khoản/VietQR
- Actor: Customer
- Mục tiêu: Tạo giao dịch bank transfer và hiển thị QR
- Preconditions: Order payment_method = `bank_transfer`
- Trigger: Chọn phương thức `bank_transfer` ở checkout
- Main Flow:
  1. Sau create order, `CheckoutController` gọi `BankTransferService.createTransactionForOrder(...)`.
  2. `BankTransferService` tạo `payment_transactions` status `PENDING`.
  3. `VietQRService.generateQr(...)` tạo QR data.
  4. Redirect `/payment/bank-transfer?transactionId=...`.
  5. User/admin có thể confirm giao dịch demo/real theo flow controller.
- Alternative Flows:
  - Nếu tạo transaction fail: redirect order detail kèm error.
- Exception Flows:
  - Thiếu cấu hình VietQR -> không tạo QR được.
- Postconditions:
  - Có transaction chờ xác nhận, order chờ xử lý.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/user/CheckoutController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/user/BankTransferPaymentController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/BankTransferService.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/VietQRService.java`
  - `src/main/webapp/user/payment/bank-transfer.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Luồng bank transfer có triển khai; luồng momo chưa hoàn thiện.

## UC-ORDER-03
- Use Case ID: UC-ORDER-03
- Tên use case: Theo dõi đơn hàng
- Actor: Customer
- Mục tiêu: Xem lịch sử và chi tiết đơn
- Preconditions: Đăng nhập
- Trigger: Truy cập `/profile/orders` hoặc `/orders/{id}`
- Main Flow:
  1. `UserProfileController` tải orders theo status filter.
  2. `OrderDetailController` tải order theo id và check ownership user.
  3. Với bank transfer, nạp transaction mới nhất.
  4. Forward các JSP profile-orders / order-detail.
- Alternative Flows:
  - `/orders` redirect sang `/profile/orders` để tương thích link cũ.
- Exception Flows:
  - Order không thuộc user: trả 404.
- Postconditions: User theo dõi được trạng thái đơn.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/user/UserProfileController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/user/OrderHistoryController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/user/OrderDetailController.java`
  - `src/main/webapp/user/profile-orders.jsp`
  - `src/main/webapp/user/order/order-detail.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Hoàn thiện.

## UC-ORDER-04
- Use Case ID: UC-ORDER-04
- Tên use case: Hủy đơn hàng
- Actor: Customer
- Mục tiêu: Hủy đơn pending chưa thanh toán thành công
- Preconditions: Đơn thuộc user và thỏa điều kiện hủy
- Trigger: Submit form `/orders/{id}/cancel`
- Main Flow:
  1. `OrderDetailController#doPost` route `/cancel`.
  2. Check ownership + điều kiện hủy (`canCancelOrder`).
  3. `OrderService.cancelOrder(...)` update status + hoàn kho.
  4. Với bank transfer, expire pending transaction.
- Alternative Flows:
  - Nếu transaction bank transfer đã SUCCESS: không cho hủy.
- Exception Flows:
  - Không đủ điều kiện hủy: set error và redirect detail.
- Postconditions: Đơn đổi trạng thái `cancelled` nếu thành công.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/user/OrderDetailController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/OrderService.java`
  - `src/main/webapp/user/order/order-detail.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Hoàn thiện.

## UC-REV-01
- Use Case ID: UC-REV-01
- Tên use case: Viết review sản phẩm
- Actor: Customer
- Mục tiêu: Đánh giá sản phẩm đã mua
- Preconditions: Đăng nhập và đã mua hàng (completed)
- Trigger: Submit form review tại product detail
- Main Flow:
  1. `ReviewController#doPost` parse productId/rating/content.
  2. `ReviewService.canUserReviewProduct(...)` check `ALREADY_REVIEWED`, `ORDER_NOT_COMPLETED`, `NOT_PURCHASED`.
  3. Nếu hợp lệ, insert review.
  4. Cập nhật average_rating/review_count product.
  5. Redirect lại product detail anchor `#reviews`.
- Alternative Flows: Không.
- Exception Flows:
  - Chưa login: redirect login kèm redirect path về sản phẩm.
- Postconditions:
  - Review mới được lưu, rating tổng hợp được cập nhật.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/user/ReviewController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/ReviewService.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/dao/ReviewDAO.java`
  - `src/main/webapp/user/product/product-detail.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Luồng chính đầy đủ, nhưng render content hiện có rủi ro XSS (xem issue).

## UC-PROFILE-01
- Use Case ID: UC-PROFILE-01
- Tên use case: Cập nhật thông tin cá nhân và đổi mật khẩu
- Actor: Customer
- Mục tiêu: Quản lý thông tin tài khoản
- Preconditions: Đăng nhập
- Trigger: Submit `/profile/edit` hoặc `/profile/change-password`
- Main Flow:
  1. `UserProfileController` route theo `pathInfo`.
  2. `ProfileService.updateProfile(...)` hoặc `changePassword(...)`.
  3. Thành công thì cập nhật session user và render lại view.
- Alternative Flows: Không.
- Exception Flows:
  - Validate fail: forward lại view với lỗi.
- Postconditions: Thông tin cá nhân/mật khẩu được cập nhật.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/user/UserProfileController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/ProfileService.java`
  - `src/main/webapp/user/profile-edit.jsp`
  - `src/main/webapp/user/change-password.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Có lỗ hổng route avatar và bug không lưu full name.

## UC-PROFILE-02
- Use Case ID: UC-PROFILE-02
- Tên use case: Quản lý địa chỉ giao hàng
- Actor: Customer
- Mục tiêu: Lưu/chọn/xóa địa chỉ
- Preconditions: Đăng nhập
- Trigger: Truy cập `/profile/addresses` và submit các form add/set-default/delete
- Main Flow:
  1. `AddressController#doGet` load list địa chỉ theo user.
  2. `doPost` xử lý `/add`, `/set-default`, `/delete`.
  3. Gọi `ShippingService` để insert/update/delete/set default.
  4. Redirect lại trang địa chỉ với message.
- Alternative Flows: Không.
- Exception Flows:
  - Không đăng nhập: redirect login.
- Postconditions: Dữ liệu địa chỉ thay đổi theo thao tác.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/user/AddressController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/ShippingService.java`
  - `src/main/webapp/user/address.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Logic hiện thiên về single-address, chưa thực sự multi-address.

## UC-ADMIN-01
- Use Case ID: UC-ADMIN-01
- Tên use case: Xem dashboard admin
- Actor: Admin
- Mục tiêu: Theo dõi KPI doanh thu/đơn hàng/sản phẩm/user
- Preconditions: Đăng nhập admin (qua `AdminFilter`)
- Trigger: GET `/admin/dashboard` hoặc `/admin/dashboard-data`
- Main Flow:
  1. `AdminDashBoardController#doGet` load tổng số và recent orders.
  2. Endpoint AJAX `/admin/dashboard-data` trả JSON chart doanh thu + trạng thái.
  3. JSP render chart/stat cards.
- Alternative Flows: Không.
- Exception Flows:
  - Exception DB: hiện chỉ set attribute lỗi, chưa xử lý response hoàn chỉnh.
- Postconditions: Admin nhìn thấy dữ liệu tổng quan.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/admin/AdminDashBoardController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/dao/OrderDAO.java`
  - `src/main/webapp/admin/dashboard.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Hoạt động cơ bản, nhưng còn vấn đề data/chart handling.

## UC-ADMIN-02
- Use Case ID: UC-ADMIN-02
- Tên use case: Quản lý user
- Actor: Admin
- Mục tiêu: Xem danh sách, xem chi tiết, cập nhật profile/role, khóa-mở khóa
- Preconditions: Admin đăng nhập
- Trigger: `/admin/users`, `/admin/users?action=detail&id=...`, POST update/delete
- Main Flow:
  1. `UserManagementController#doGet` list hoặc detail.
  2. `doPost` action `update-profile` cập nhật thông tin.
  3. `doPost` action `delete` thực chất toggle active.
- Alternative Flows: Không.
- Exception Flows:
  - ID không hợp lệ -> 400.
- Postconditions: User data hoặc trạng thái active được cập nhật.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/admin/UserManagementController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/UserService.java`
  - `src/main/webapp/admin/user/list.jsp`
  - `src/main/webapp/admin/user/detail.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Hoàn thiện mức cơ bản.

## UC-ADMIN-03
- Use Case ID: UC-ADMIN-03
- Tên use case: Quản lý sản phẩm
- Actor: Admin
- Mục tiêu: Tạo/sửa/xóa mềm sản phẩm, quản lý variant và ảnh
- Preconditions: Admin đăng nhập
- Trigger: `/admin/products` với action create/edit/delete
- Main Flow:
  1. `ProductManagementController#doGet` list hoặc edit form.
  2. `doPost create/edit` map request thành `Product` + variants.
  3. Upload ảnh qua `Part` và ghi vào `static/images/products/...`.
  4. Redirect list.
- Alternative Flows: Không.
- Exception Flows:
  - DB/parse lỗi: redirect `?err=1`.
- Postconditions: Product và variants được cập nhật.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/admin/ProductManagementController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/dao/ProductDAO.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/dao/ProductVariantDAO.java`
  - `src/main/webapp/admin/product/list.jsp`
  - `src/main/webapp/admin/product/form.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Chạy được; phần lưu ảnh chưa tối ưu cho deploy container.

## UC-ADMIN-04
- Use Case ID: UC-ADMIN-04
- Tên use case: Quản lý danh mục
- Actor: Admin
- Mục tiêu: Tạo/sửa/xóa category
- Preconditions: Admin đăng nhập
- Trigger: `/admin/categories`, `/admin/category/*`
- Main Flow:
  1. `CategoryManagementController` phân nhánh theo servletPath.
  2. List/add/edit/save/delete category.
  3. Redirect list.
- Alternative Flows: Không.
- Exception Flows:
  - validate fail -> redirect add với error.
- Postconditions: Category được cập nhật trong DB.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/admin/CategoryManagementController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/CategoryService.java`
  - `src/main/webapp/admin/category/list.jsp`
  - `src/main/webapp/admin/category/form.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Hoàn thiện mức cơ bản.

## UC-ADMIN-05
- Use Case ID: UC-ADMIN-05
- Tên use case: Quản lý thương hiệu
- Actor: Admin
- Mục tiêu: Tạo/sửa/xóa brand
- Preconditions: Admin đăng nhập
- Trigger: `/admin/brands`, `/admin/brands/*`
- Main Flow:
  1. `BrandManagementController` list/form/edit/save/delete.
  2. Validate cơ bản brandName.
  3. Redirect list.
- Alternative Flows: Không.
- Exception Flows:
  - Validation/DAO exception -> forward lại form.
- Postconditions: Brand data được cập nhật.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/admin/BrandManagementController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/dao/BrandDAO.java`
  - `src/main/webapp/admin/brand/list.jsp`
  - `src/main/webapp/admin/brand/form.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Hoàn thiện mức cơ bản.

## UC-ADMIN-06
- Use Case ID: UC-ADMIN-06
- Tên use case: Quản lý đơn hàng + xác nhận bank transfer
- Actor: Admin
- Mục tiêu: Theo dõi chi tiết order, đổi trạng thái, xác nhận thanh toán chuyển khoản
- Preconditions: Admin đăng nhập
- Trigger: `/admin/orders` (action detail/updateStatus/confirmPayment/delete)
- Main Flow:
  1. `OrderManagementController#doGet` xử lý action query param.
  2. detail: load order + order items + paymentTransaction.
  3. updateStatus: cập nhật status (có check bank transfer success khi status=confirmed).
  4. confirmPayment: gọi `BankTransferService.confirmByAdmin`.
- Alternative Flows: Không.
- Exception Flows:
  - order/transaction id invalid -> 400/404.
- Postconditions: Trạng thái order hoặc transaction thay đổi.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/admin/OrderManagementController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/services/BankTransferService.java`
  - `src/main/webapp/admin/order/list.jsp`
  - `src/main/webapp/admin/order/detail.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Có đầy đủ flow chính; còn vấn đề HTTP method/CSRF/history consistency.

## UC-ADMIN-07
- Use Case ID: UC-ADMIN-07
- Tên use case: Quản lý flash sale
- Actor: Admin
- Mục tiêu: Bật/tắt `isOnSale` cho sản phẩm
- Preconditions: Admin đăng nhập
- Trigger: `/admin/flash-sale`
- Main Flow:
  1. `FlashSaleManagementController#doGet` load saleProducts + nonSaleProducts.
  2. `doPost` action `addToSale` hoặc `removeFromSale`.
  3. Cập nhật `is_on_sale` và redirect.
- Alternative Flows: Không.
- Exception Flows: parse id fail bỏ qua silently.
- Postconditions: Danh sách flash sale thay đổi.
- Files liên quan:
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/controller/admin/FlashSaleManagementController.java`
  - `src/main/java/com/example/nhom49_webbansanphamchamsoctoc/dao/ProductDAO.java`
  - `src/main/webapp/admin/promotion/flash-sale.jsp`
- Ghi chú / mức độ hoàn thiện suy ra từ source code: Hoàn thiện ở mức toggle cờ sale.

# User Flows
## Guest flow
1. Guest vào `/home` hoặc `/store`.
2. Header/footer từ layout JSP render danh mục, brand, link auth.
3. Guest xem list sản phẩm:
   - UI gửi query params filter/sort.
   - `ProductListController` xử lý và forward `product-list.jsp`.
4. Guest xem chi tiết sản phẩm:
   - `/product/{slug}` -> `ProductDetailController`.
   - Nạp product + reviews + related products.
5. Nếu Guest add cart/review:
   - `/cart/add` hoặc `/review` yêu cầu login.
   - Controller redirect `/auth/login?redirect=...`.
6. Guest có thể đăng ký:
   - Submit register -> pending_registration + OTP email.
   - Verify OTP -> tạo user -> login.
7. Guest quên mật khẩu:
   - `/auth/forgot-password` -> gửi OTP -> `/auth/verify-otp` -> `/reset-password`.

## Customer flow
1. Customer đăng nhập local hoặc Google OAuth.
2. Customer duyệt sản phẩm và chọn variant tại product detail.
3. Add to cart:
   - `/cart/add` -> `CartService` cập nhật cart session.
4. Vào `/cart`:
   - `CartController` nạp items/subtotal/cartCount.
   - Customer cập nhật/xóa item (`/cart/update`, `/cart/remove`, `/cart/clear`).
5. Checkout `/checkout`:
   - `CheckoutController#doGet` kiểm tra login, cart, stock.
   - Nạp địa chỉ + subtotal.
6. Submit checkout:
   - Đọc addressId hoặc tạo địa chỉ mới.
   - `OrderService.createOrder` insert order + items + history + trừ stock.
7. Nếu payment `bank_transfer`:
   - Tạo payment transaction + generate VietQR.
   - Redirect `/payment/bank-transfer?transactionId=...`.
8. Nếu payment `cod`:
   - Redirect `/orders/{id}`.
9. Customer theo dõi đơn:
   - `/profile/orders` hoặc `/orders/{id}`.
   - Có thể hủy nếu pending và chưa thanh toán thành công (bank transfer).
10. Customer review sản phẩm:
   - Tại product detail tab review.
   - `ReviewController` check verified purchase -> insert review.
11. Customer quản lý profile:
   - `/profile/overview`, `/profile/edit`, `/profile/change-password`, `/profile/addresses`.

## Admin flow
1. Admin đăng nhập qua `/auth/login`.
2. `AdminFilter` cho phép truy cập `/admin/*` khi role Admin.
3. Dashboard:
   - `/admin/dashboard` load KPI.
   - `/admin/dashboard-data` trả JSON chart.
4. Quản lý user:
   - `/admin/users` list.
   - `/admin/users?action=detail&id=...` xem/sửa profile/role, khóa-mở khóa.
5. Quản lý sản phẩm:
   - `/admin/products` list.
   - action create/edit/delete (soft delete).
   - upload image vào static path.
6. Quản lý category/brand:
   - CRUD qua các route `/admin/category*` `/admin/brand*`.
7. Quản lý order:
   - `/admin/orders` list/detail.
   - cập nhật trạng thái.
   - xác nhận bank transfer.
8. Quản lý flash sale:
   - `/admin/flash-sale` bật/tắt `is_on_sale`.

# Missing or Unclear Flows
- Luồng upload avatar chưa hoàn thiện:
  - JSP submit `/profile/avatar`, nhưng `UserProfileController#doPost` chưa xử lý route này.
- Luồng thanh toán `momo` chưa hoàn thiện:
  - UI checkout có option `momo`, nhưng backend không có service/controller transaction tương ứng.
- Luồng quản lý khuyến mãi đầy đủ (promotion rules) chưa rõ:
  - Có `promotions`, `product_promotions`, `PromotionDAO` nhưng không thấy controller/service vận hành đầy đủ module này.
- Luồng wishlist chưa có backend:
  - Có schema bảng `wishlist` nhưng không có controller/service/DAO usage tương ứng.

# Assumptions
- Assumption chắc chắn (từ source code):
  - Schema chính đang dùng là `test/schema_hairglow_database.sql` (v4, 2026-03-20), seed chính là `test/hairglow_seed.sql` và `test/hairglow_seed_bcrypt_password.sql`.
  - Luồng auth/cart/order/review/admin core đều có servlet + service + DAO tương ứng.
- Assumption chưa chắc chắn (cần runtime verify):
  - Một số vấn đề encoding tiếng Việt hiển thị sai trong môi trường đọc hiện tại có thể do encoding/tooling, không hoàn toàn kết luận là lỗi source.
  - Không xác nhận được toàn bộ static assets do hạn chế đọc thư mục `src/main/webapp/static/images/products` và `src/main/webapp/static/images/brands` trong môi trường audit.
  - Chưa xác nhận behavior runtime trên Tomcat 10.1 thật vì build CLI đang bị block bởi quyền truy cập JDK trong máy local audit.
