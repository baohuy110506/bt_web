# BÀI TẬP 4: LẬP TRÌNH WEB - SITEMESH DECORATOR 3, VALIDATION FORM & USER PROFILE VỚI CLOUDINARY MULTIPART

Dự án môn học **Lập Trình Web** (Bài Tập 04) phát triển trên nền tảng **Jakarta EE (Servlet 6.0)**, **Hibernate ORM 6**, **Microsoft SQL Server**, hoàn thành đầy đủ 3 chức năng chính theo đúng yêu cầu đề bài:

1. **Cấu hình SiteMesh Decorator 3 với 01 Template Bootstrap 5**:
   - Quản lý layout giao diện thống nhất cho toàn bộ hệ thống bằng SiteMesh 3.
   - Xây dựng Template Bootstrap 5 responsive, hiện đại (gồm giao diện người dùng và giao diện quản trị Admin).
2. **Thực hiện Validation toàn diện cho tất cả các chức năng có FORM**:
   - Validation 2 lớp (Client-side HTML5 Bootstrap 5 & Server-side trong Servlet Controller).
   - Áp dụng đầy đủ cho các Form: `Login`, `Register`, `Forgot Password`, `Reset Password`, `Category Insert/Edit`, `Video Insert/Edit`.
3. **Xây dựng chức năng Profile User**:
   - Cho phép người dùng xem và cập nhật thông tin cá nhân: `fullname`, `phone`.
   - Cập nhật email mới: Hệ thống tự động gửi **mã OTP 6 số đến email mới** để xác nhận trước khi cập nhật thành công vào CSDL.
   - Upload ảnh đại diện Avatar lên **Cloudinary bằng Multipart** (@MultipartConfig), lưu trữ an toàn trên đám mây.
   - Toàn bộ giao diện trang Profile và trang xác thực OTP email mới được quản lý bởi **SiteMesh Decorator 3**.

---

## 1. Công Nghệ Sử Dụng

- **Ngôn ngữ**: Java 17+ (tương thích JDK 17 đến JDK 26)
- **Nền tảng Web**: Jakarta Servlet 6.0, JSP 3.1, JSTL 3.0
- **SiteMesh Decorator**: SiteMesh 3.2.1 (chuẩn Jakarta EE)
- **Giao diện Front-end**: Bootstrap 5.3.3, Font Awesome 6.5.1, Google Fonts Inter
- **Lưu trữ đám mây**: Cloudinary Java SDK 2.0.0 (upload multipart)
- **Email Service**: Jakarta Mail API & Angus Mail (gửi OTP qua Gmail SMTP)
- **Mã hóa mật khẩu**: BCrypt (`jbcrypt`)
- **ORM / JPA Provider**: Hibernate Core 6.4.4.Final, Jakarta Persistence API 3.1
- **Hệ quản trị CSDL**: Microsoft SQL Server (database: `webst2`)
- **Web Server**: Apache Tomcat 10+ / Tomcat 11

---

## 2. Cấu Trúc Dự Án

```
bt3_web/
├── pom.xml                                       # Quản lý dependencies (Hibernate, Jakarta Servlet, jbcrypt, MSSQL)
├── init_db_jpa.sql                               # Script tạo database webst2 và dữ liệu mẫu
├── README.md                                     # Hướng dẫn chi tiết dự án
├── src/main/resources/
│   └── META-INF/persistence.xml                  # Cấu hình JPA EntityManager
├── src/main/java/vn/iotstar/
│   ├── config/JpaConfig.java                     # Quản lý kết nối JPA EntityManager
│   ├── entity/                                   # Entity JPA: User, Video, Category
│   ├── dao/                                      # DAO thao tác CSDL qua JPQL
│   ├── service/                                  # Tầng xử lý nghiệp vụ
│   ├── controller/                               # Servlet Controllers điều hướng
│   └── util/                                     # Tiện ích băm mật khẩu, gửi OTP, cấu hình
└── src/main/webapp/
    ├── views/
    │   ├── common/topbar.jsp                     # Menu điều hướng
    │   ├── home.jsp                              # Trang chủ (Top 10 video mới nhất & Danh mục)
    │   ├── login.jsp                             # Đăng nhập
    │   ├── register.jsp                          # Đăng ký tài khoản
    │   ├── verify-otp.jsp                        # Xác thực mã OTP kích hoạt
    │   ├── forgot-password.jsp                   # Quên mật khẩu nhận OTP
    │   ├── reset-password.jsp                    # Đặt lại mật khẩu mới
    │   ├── video/
    │   │   ├── video-list.jsp                    # Danh sách video phân trang 6sp/trang
    │   │   └── video-detail.jsp                  # Chi tiết và phát video (Player)
    │   └── admin/                                # Giao diện Quản trị CRUD Video
```

---

## 3. Danh Sách Các Chức Năng Đã Hoàn Thành

### 1. Cấu hình SiteMesh Decorator 3 với Template Bootstrap 5
- Tích hợp thư viện **SiteMesh 3.2.1** tương thích chuẩn **Jakarta EE 10 / Servlet 6.0**.
- Cấu hình qua Filter `SiteMeshFilter.java`, `sitemesh3.xml` và `web.xml`.
- Xây dựng 01 bộ **Template Bootstrap 5** thống nhất:
  - `web.jsp`: Template người dùng có Navbar responsive, Dropdown menu thông tin tài khoản, Container nội dung `<sitemesh:write property="body"/>`, và Footer chuyên nghiệp.
  - `admin.jsp`: Template quản trị Admin dành riêng cho các trang `/admin/*`.

### 2. Validation Toàn Diện Cho Các Chức Năng Có Form
- Xây dựng tiện ích kiểm tra `ValidationUtil.java` (Regex email, số điện thoại VN, username, videoId, định dạng file ảnh).
- **Validation 2 lớp đồng bộ**:
  - **Client-side**: HTML5 và class `needs-validation` của Bootstrap 5, phản hồi thời gian thực khi nhập mật khẩu khớp, định dạng pattern.
  - **Server-side**: Kiểm tra chi tiết trong Servlet Controllers, giữ lại dữ liệu đã nhập trên form khi có lỗi.
  - **Áp dụng cho đầy đủ các Form**:
    - `Login`: Bắt lỗi rỗng, độ dài mật khẩu, kiểm tra tài khoản chưa kích hoạt OTP.
    - `Register`: Kiểm tra tên đăng nhập (3-30 ký tự, không dấu), định dạng email, số điện thoại VN, độ dài mật khẩu $\ge$ 6, kiểm tra mật khẩu xác nhận, kiểm tra trùng username / email trong CSDL.
    - `Forgot Password & Reset Password`: Kiểm tra dữ liệu nhập, mã OTP 6 số, mật khẩu mới.
    - `Category Insert & Edit`: Bắt lỗi tên danh mục (2-100 ký tự), kiểm tra file ảnh tải lên.
    - `Video Insert & Edit`: Kiểm tra mã Video ID (không trùng lặp trong DB), tiêu đề (3-200 ký tự), bắt buộc chọn Category liên kết, kiểm tra poster.

### 3. Chức Năng Profile User & Upload Cloudinary Bằng Multipart
- Truy cập tại URL `/user/profile` hoặc `/profile` (được bảo vệ đăng nhập và quản lý giao diện bởi **SiteMesh 3**).
- **Cập nhật thông tin cá nhân**:
  - Cập nhật `fullname`, `phone`.
  - **Cập nhật Avatar lên Cloudinary bằng Multipart**: Tích hợp Cloudinary Java SDK (`cloudinary-http5`) qua `CloudinaryUtil.java`, đọc credentials từ `.env`, upload trực tiếp qua Jakarta Servlet `@MultipartConfig` và lưu secure URL của Cloudinary. Có cơ chế fallback lưu cục bộ nếu chưa cấu hình API key.
- **Cập nhật Email mới xác thực qua OTP**:
  - Khi người dùng nhập địa chỉ email mới khác với email hiện tại, hệ thống sẽ tự động tạo mã OTP gồm 6 chữ số và gửi đến **chính địa chỉ email mới đó**.
  - Đồng thời in mã OTP ra Console máy chủ để thuận tiện kiểm thử, chấm điểm.
  - Chuyển hướng người dùng sang trang `/user/profile/verify-otp`.
  - Chỉ khi người dùng nhập chính xác mã OTP, hệ thống mới cập nhật email mới vào CSDL.

### 4. Đăng ký & Kích hoạt tài khoản bằng OTP qua Email
- Tại `/register`: Đăng ký tài khoản mới, mật khẩu được mã hóa an toàn bằng **BCrypt**.
- Hệ thống tự động sinh mã OTP 6 số và gửi qua email để kích hoạt. Đồng thời in mã OTP tại Console máy chủ để thuận tiện chấm điểm, kiểm thử.
- Người dùng chuyển sang `/verify-otp` để nhập mã OTP kích hoạt tài khoản.

### 2. Đăng nhập mật khẩu mã hóa BCrypt & Đăng xuất
- Tại `/login`: Hệ thống kiểm tra mật khẩu đã mã hóa bằng `BCrypt.checkpw()`.
- Chặn đăng nhập nếu tài khoản chưa kích hoạt OTP, kèm thông báo và link dẫn tới trang nhập OTP.
- Tại `/logout`: Xóa session và cookie đăng nhập, chuyển hướng về trang login.

### 3. Quên mật khẩu xác nhận OTP qua Email
- Tại `/forgot-password`: Nhập email hoặc username nhận mã OTP.
- Tại `/reset-password`: Nhập mã OTP và mật khẩu mới. Mật khẩu mới được băm bằng BCrypt và lưu vào CSDL.

### 4. Bảng Videos liên kết 1-N với Users & CRUD Videos
- Bảng `Videos` có cột `UserId` liên kết khóa ngoại với `Users(Id)`.
- Giao diện Admin tại `/admin/videos` hỗ trợ đầy đủ **Thêm, Sửa, Xóa, Xem** video.
- Tích hợp upload ảnh Poster video bằng **Multipart**.

### 5. Hiển thị 10 Video mới nhất ở Trang chủ
- Truy cập `/home`: Mục **"10 Video Mới Nhất"** hiển thị danh sách các video mới đăng dạng thẻ card (poster, tiêu đề, uploader, lượt xem).

### 6. Hiển thị Video của User phân trang 6sp/trang
- Truy cập `/video`: Hiển thị tất cả video của người dùng, phân trang đúng **6 video/trang**.
- Có thanh chuyển trang: `« Trước`, `1`, `2`, `Sau »`.

### 7. Xem chi tiết & Phát video khi click vào tiêu đề
- Bấm vào tiêu đề video ở trang `/home` hoặc `/video` chuyển đến `/video/detail?id=...`.
- Tự động cộng lượt xem (`views + 1`).
- Tích hợp trình phát video HTML5 (hỗ trợ MP4, WebM) và YouTube embed, hiển thị thông tin uploader, danh mục, mô tả và video gợi ý.

### 8. Hướng dẫn Upload file bằng Multipart
1. **Annotation Servlet**: Thêm `@MultipartConfig` trên Controller:
   ```java
   @MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 50)
   ```
2. **Form JSP**: Đặt `enctype="multipart/form-data"` và `method="post"`:
   ```jsp
   <form action="..." method="post" enctype="multipart/form-data">
       <input type="file" name="posterFile" />
   </form>
   ```
3. **Xử lý Servlet**:
   ```java
   Part part = request.getPart("posterFile");
   if (part != null && part.getSize() > 0) {
       String fileName = System.currentTimeMillis() + "_" + Paths.get(part.getSubmittedFileName()).getFileName();
       part.write(Constant.DIR + File.separator + fileName);
   }
   ```

---

## 4. Hướng Dẫn Cài Đặt & Chạy

1. **Khởi tạo Database**:
   - Mở SQL Server Management Studio (SSMS).
   - Chạy script `init_db_jpa.sql` để tạo CSDL `webst2` và dữ liệu mẫu.
2. **Deploy lên Tomcat**:
   - Mở dự án trong IntelliJ IDEA / Eclipse.
   - Chạy ứng dụng trên Apache Tomcat.
   - Trang chủ: `http://localhost:8080/bt2/home`
   - Trang video: `http://localhost:8080/bt2/video`
   - Trang đăng nhập: `http://localhost:8080/bt2/login`
   - Quản trị video: `http://localhost:8080/bt2/admin/videos`
