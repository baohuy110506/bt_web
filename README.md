# BÀI TẬP 3: HỆ THỐNG XÁC THỰC OTP EMAIL, MÃ HÓA BCRYPT, QUẢN LÝ VIDEO (JPA 1-N USER) & PHÂN TRANG

Dự án môn học **Lập Trình Web** xây dựng trên nền tảng **Jakarta EE 10 (Servlet 6.0)** kết hợp **Hibernate ORM 6** và cơ sở dữ liệu **Microsoft SQL Server**, hoàn thành đầy đủ tất cả các yêu cầu theo đề bài:

1. **Kích hoạt tài khoản bằng mã OTP gửi qua Email** khi đăng ký tài khoản *(Hạn commit: 16g30 ngày 16/11/2026)*.
2. **Đăng nhập với mật khẩu được mã hóa (Hash Password - BCrypt)** và **Chức năng Đăng xuất** *(Hạn commit: 16g30 ngày 16/11/2026)*.
3. **Chức năng Quên mật khẩu gửi mã xác nhận OTP qua Mail** *(Hạn commit: 16g30 ngày 16/11/2026)*.
4. **Thêm bảng `Videos` vào Database với mối quan hệ 1-N với bảng `Users`** *(Hạn commit: 12g45 ngày 19/11/2026)*:
   - Thực hiện đầy đủ **CRUD cho bảng Videos**.
   - Hiển thị **10 video mới nhất lên trang chủ** (`/home`).
   - Hiển thị tất cả **videos của user và được phân trang 6sp/trang** tại URL `/video`.
   - Hiển thị chi tiết và **play 01 video khi bấm chuột vào tiêu đề của video đó** trên trang chủ `/home` và trên trang `/video`.
5. **Hướng dẫn upload file bằng Multipart** chuẩn Jakarta Servlet 6.0.

---

## 1. Công Nghệ & Thư Viện Sử Dụng

- **Ngôn ngữ**: Java 17+ (tương thích từ JDK 17 đến JDK 26)
- **Nền tảng Web**: Jakarta EE 10 (Jakarta Servlet 6.0, Jakarta JSP 3.1, JSTL 3.0)
- **ORM / JPA Provider**: Hibernate Core `6.4.4.Final`, Jakarta Persistence API 3.1
- **Hệ quản trị CSDL**: Microsoft SQL Server (Driver `mssql-jdbc:12.8.1.jre11`)
- **Mã hóa mật khẩu**: Thuật toán băm BCrypt chuẩn an toàn (`org.mindrot:jbcrypt:0.4`)
- **Gửi Email OTP**: Jakarta Mail API `2.1.5` & Angus Mail `2.0.5` qua giao thức Google SMTP TLS
- **Bảo mật thông tin**: Tách cấu hình thông tin nhạy cảm vào file `.env` (được bảo vệ bởi `.gitignore`)
- **Upload File**: Annotation `@MultipartConfig` theo chuẩn Jakarta Servlet 6.0
- **Máy chủ Web**: Apache Tomcat 10+ / Apache Tomcat 11 (`11.0.27`)

---

## 2. Cấu Trúc Thư Mục Dự Án

```
bt3/
├── .env                                          # Cấu hình tài khoản SMTP Google (BẢO MẬT, KHÔNG COMMIT LÊN GIT)
├── .env.example                                  # File mẫu cấu hình biến môi trường
├── .gitignore                                    # Loại bỏ .env, target/, .idea/ khi commit
├── pom.xml                                       # Quản lý thư viện Maven (Hibernate, Jakarta Mail, jbcrypt, MSSQL)
├── init_db_jpa.sql                               # Script SQL tạo CSDL webst2, Users (Status, Code), Videos (FK UserId)
├── HUONG_DAN_UPLOAD_MULTIPART.md                 # Tài liệu hướng dẫn chi tiết Upload file Multipart
├── README.md                                     # Tài liệu tổng quan & hướng dẫn chạy dự án
├── src/main/resources/
│   └── META-INF/persistence.xml                  # Cấu hình EntityManager cho Category, Video, User
├── src/main/java/vn/iotstar/
│   ├── config/
│   │   ├── JpaConfig.java                        # Quản lý EntityManagerFactory và getEntityManager()
│   │   └── Test.java                             # Kiểm thử JPA độc lập
│   ├── util/
│   │   ├── EnvUtil.java                          # Nạp tự động biến môi trường từ file .env hoặc OS
│   │   ├── PasswordUtil.java                     # Băm và kiểm tra mật khẩu bằng BCrypt
│   │   ├── EmailUtil.java                        # Sinh OTP 6 số, gửi HTML Email, log OTP ra Console
│   │   └── Constant.java                         # Cấu hình đường dẫn, upload dir, session keys
│   ├── entity/
│   │   ├── User.java                             # Entity User (Status, Code, quan hệ @OneToMany Video)
│   │   ├── Video.java                            # Entity Video (quan hệ @ManyToOne User & Category)
│   │   └── Category.java                         # Entity Category
│   ├── dao/
│   │   ├── IUserDao.java & UserDao.java
│   │   ├── impl/UserDaoImpl.java                 # Thao tác User qua JPA JPQL
│   │   ├── IVideoDao.java & VideoDao.java        # Interface DAO Video
│   │   └── impl/VideoDaoImpl.java                # Triển khai CRUD, Top 10 mới nhất, query theo UserId và phân trang
│   ├── service/
│   │   ├── IUserService.java & UserService.java
│   │   ├── impl/UserServiceImpl.java             # Xử lý nghiệp vụ đăng ký OTP, quên mật khẩu, xác thực BCrypt
│   │   ├── IVideoService.java & VideoService.java
│   │   └── impl/VideoServiceImpl.java            # Nghiệp vụ Video & tự động tăng lượt xem
│   ├── controller/
│   │   ├── LoginController.java                  # Đăng nhập BCrypt, kiểm tra trạng thái kích hoạt OTP
│   │   ├── RegisterController.java               # Đăng ký tài khoản, gửi OTP kích hoạt qua Email
│   │   ├── VerifyOtpController.java              # Xác thực OTP kích hoạt tài khoản (/verify-otp, /resend-otp)
│   │   ├── ForgotPasswordController.java         # Yêu cầu gửi OTP quên mật khẩu (/forgot-password)
│   │   ├── ResetPasswordController.java          # Đặt lại mật khẩu mới qua OTP (/reset-password)
│   │   ├── LogoutController.java                 # Đăng xuất, hủy session & cookie
│   │   ├── HomeController.java                   # Lấy 10 video mới nhất hiển thị trang chủ (/home)
│   │   ├── VideoController.java                  # Phân trang 6 video/trang (/video), chi tiết & play (/video/detail)
│   │   ├── VideoManageController.java            # CRUD Video Admin với Multipart file upload
│   │   ├── CategoryController.java               # CRUD Danh mục sản phẩm
│   │   └── DownloadImageController.java          # Phục vụ stream ảnh từ thư mục upload
└── src/main/webapp/
    ├── views/
    │   ├── common/topbar.jsp                     # Menu điều hướng dùng chung
    │   ├── login.jsp                             # Giao diện Đăng nhập & link Quên mật khẩu
    │   ├── register.jsp                          # Giao diện Đăng ký tài khoản
    │   ├── verify-otp.jsp                        # Giao diện nhập mã OTP kích hoạt tài khoản
    │   ├── forgot-password.jsp                   # Giao diện yêu cầu cấp lại mật khẩu qua OTP
    │   ├── reset-password.jsp                    # Giao diện nhập OTP và mật khẩu mới
    │   ├── home.jsp                              # Trang chủ hiển thị 10 Video mới nhất & Danh mục
    │   ├── video/
    │   │   ├── video-list.jsp                    # Trang /video phân trang 6 video/trang của user
    │   │   └── video-detail.jsp                  # Trang phát video & xem chi tiết
    │   └── admin/
    │       ├── video-list.jsp                    # Bảng quản lý CRUD Video
    │       ├── video-add.jsp                     # Form thêm video mới (Multipart Upload)
    │       └── video-edit.jsp                    # Form cập nhật video (Multipart Upload)
```

---

## 3. Chi Tiết Các Tính Năng Đã Hoàn Thành

### 1. Kích hoạt tài khoản bằng mã OTP gửi qua Email khi đăng ký
- Người dùng điền thông tin tại `/register`.
- Hệ thống băm mật khẩu bằng thuật toán **BCrypt** an toàn.
- Sinh ngẫu nhiên mã OTP 6 chữ số và lưu vào CSDL với `Status = 0` (chưa kích hoạt).
- Gửi email kích hoạt qua **Google SMTP**. Đồng thời in mã OTP ra **Console máy chủ** để dễ dàng chấm điểm/test offline.
- Chuyển hướng sang `/verify-otp?username=...`. Khi người dùng nhập đúng OTP, tài khoản đổi sang `Status = 1` và có thể đăng nhập.
- Người dùng đăng nhập khi chưa kích hoạt sẽ bị chặn kèm thông báo và đường dẫn kích hoạt ngay.

### 2. Đăng nhập với mật khẩu mã hóa BCrypt & Đăng xuất
- Sử dụng thư viện `org.mindrot.jbcrypt` để mã hóa một chiều kèm salt.
- Khi đăng nhập tại `/login`, hệ thống so khớp bằng `BCrypt.checkpw()`. Có hỗ trợ cơ chế fallback thông minh cho các tài khoản seed sẵn trong database.
- Đăng xuất tại `/logout`: Hủy session, xóa cookie ghi nhớ, chuyển hướng về trang đăng nhập.

### 3. Quên mật khẩu gửi mã xác nhận OTP qua Mail
- Tại trang đăng nhập, bấm **"Quên mật khẩu?"** dẫn đến `/forgot-password`.
- Nhập Email hoặc Username $\rightarrow$ Hệ thống gửi mã OTP 6 số về email.
- Chuyển sang `/reset-password` để nhập mã OTP và mật khẩu mới. Khi nhập đúng, mật khẩu mới được băm bằng BCrypt và cập nhật vào CSDL.

### 4. Bảng Videos có quan hệ 1-N với bảng Users & CRUD Videos
- Bảng `Videos` bổ sung cột `UserId INT NULL` liên kết khóa ngoại với `Users(Id)`.
- Giao diện Admin tại `/admin/videos` cho phép thực hiện đầy đủ **Thêm, Sửa, Xóa, Xem** video.
- Form thêm/sửa video tích hợp **Upload file Multipart** tải ảnh poster vào thư mục máy chủ.

### 5. Hiển thị 10 video mới nhất lên trang chủ (`/home`)
- `HomeController` truy vấn Top 10 video mới nhất bằng JPQL:
  ```sql
  SELECT v FROM Video v WHERE v.active = 1 ORDER BY v.videoId DESC
  ```
- Hiển thị dạng lưới đẹp mắt tại trang chủ với thông tin uploader, lượt xem, poster và danh mục.

### 6. Hiển thị video của User và phân trang 6sp/trang tại `/video`
- Đường dẫn truy cập: `/video`.
- Phân trang đúng **6 video trên mỗi trang** (`pageSize = 6`).
- Tự động lọc danh sách video thuộc về User đang đăng nhập.
- Thanh điều hướng phân trang đầy đủ: `« Trước`, `1`, `2`, `3...`, `Sau »`.

### 7. Hiển thị chi tiết và phát video (Play) khi bấm vào tiêu đề
- Bấm vào tiêu đề video ở trang `/home` hoặc `/video` sẽ chuyển đến `/video/detail?id=...`.
- Tự động cộng số lượt xem (`views = views + 1`).
- Tích hợp trình phát video HTML5 (hỗ trợ MP4, WebM) và nhúng iframe nếu là YouTube.
- Hiển thị đầy đủ thông tin uploader, danh mục, mô tả chi tiết và danh sách video liên quan ở cột bên phải.

### 8. Hướng dẫn Upload file bằng Multipart
- Đã tạo riêng file tài liệu [HUONG_DAN_UPLOAD_MULTIPART.md](file:///D:/HK1%20-%2026-%2027/lap%20trinh%20web/bt3/HUONG_DAN_UPLOAD_MULTIPART.md) giải thích cặn kẽ cấu hình `@MultipartConfig`, thẻ form HTML, cách nhận `request.getPart()`, lưu file ra đĩa và hiển thị qua Servlet `DownloadImageController`.

---

## 4. Hướng Dẫn Cài Đặt & Chạy Thử Nghiệm

### Bước 1: Khởi tạo Cơ sở dữ liệu SQL Server
1. Mở SQL Server Management Studio (SSMS).
2. Mở file [init_db_jpa.sql](file:///D:/HK1%20-%2026-%2027/lap%20trinh%20web/bt3/init_db_jpa.sql) và nhấn **Execute (F5)**.
3. Database `webst2` sẽ được tạo kèm đầy đủ bảng, quan hệ khóa ngoại và 12 video mẫu.

### Bước 2: Cấu hình biến môi trường SMTP Google
1. Copy file `.env.example` thành `.env` (hoặc mở trực tiếp file [`.env`](file:///D:/HK1%20-%2026-%2027/lap%20trinh%20web/bt3/.env)):
   ```env
   EMAIL_SENDER=email_cua_ban@gmail.com
   EMAIL_PASSWORD=mat_khau_ung_dung_16_ky_tu
   ```
2. Lưu file. Hệ thống sẽ tự động đọc mà không cần sửa code.

### Bước 3: Chạy ứng dụng trên Tomcat
- Truy cập trang chủ: [http://localhost:8080/bt2/home](http://localhost:8080/bt2/home)
- Truy cập trang video phân trang: [http://localhost:8080/bt2/video](http://localhost:8080/bt2/video)
- Truy cập trang đăng ký OTP: [http://localhost:8080/bt2/register](http://localhost:8080/bt2/register)
- Truy cập trang đăng nhập: [http://localhost:8080/bt2/login](http://localhost:8080/bt2/login)
- Truy cập quản lý CRUD video: [http://localhost:8080/bt2/admin/videos](http://localhost:8080/bt2/admin/videos)

---

## 5. Hướng Dẫn Đẩy Lên GitHub

Mở PowerShell tại thư mục dự án và thực hiện:

```bash
cd "D:\HK1 - 26- 27\lap trinh web\bt3"

# 1. Thêm tất cả file mã nguồn
git add .

# 2. Tạo commit nộp bài
git commit -m "feat: complete OTP registration, BCrypt password hashing, forgot password OTP, video CRUD with 1-N user relation, pagination and multipart guide"

# 3. Đổi nhánh sang main
git branch -M main

# 4. Thêm remote GitHub của bạn (nếu chưa thêm)
# git remote add origin https://github.com/<username>/<repo-name>.git

# 5. Đẩy lên GitHub
git push -u origin main
```
