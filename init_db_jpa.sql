-- ========================================================
-- SCRIPT KHỞI TẠO CƠ SỞ DỮ LIỆU JPA - BÀI TẬP 3
-- Database: webst2
-- Hệ quản trị: Microsoft SQL Server
-- ========================================================

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'webst2')
BEGIN
    CREATE DATABASE webst2 COLLATE Vietnamese_CI_AS;
END
GO

USE webst2;
GO

-- 1. Bảng categories (Danh mục)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'categories')
BEGIN
    CREATE TABLE categories (
        CategoryId INT IDENTITY(1,1) PRIMARY KEY,
        CategoryName NVARCHAR(50) NOT NULL,
        Images NVARCHAR(500) NULL,
        Status INT DEFAULT 1
    );

    INSERT INTO categories (CategoryName, Images, Status)
    VALUES 
    (N'Điện thoại & Tablet', N'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=300', 1),
    (N'Laptop & Máy tính', N'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=300', 1),
    (N'Phụ kiện công nghệ', N'avatar.png', 1),
    (N'Thời trang & Quần áo', N'avatar.png', 1);
END
GO

-- 2. Bảng Users (Hỗ trợ đăng nhập & phân quyền hệ thống & OTP kích hoạt / quên mật khẩu)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Users')
BEGIN
    CREATE TABLE Users (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Email NVARCHAR(100) NULL,
        UserName NVARCHAR(50) NOT NULL UNIQUE,
        FullName NVARCHAR(100) NULL,
        PassWord NVARCHAR(255) NOT NULL,
        Avatar NVARCHAR(200) NULL,
        RoleId INT DEFAULT 3,
        Phone NVARCHAR(20) NULL,
        CreatedDate DATE NULL,
        Status INT DEFAULT 1,       -- 1: Đã kích hoạt, 0: Chưa kích hoạt (chờ OTP)
        Code NVARCHAR(20) NULL      -- Mã OTP kích hoạt hoặc xác nhận quên mật khẩu
    );

    INSERT INTO Users (Email, UserName, FullName, PassWord, Avatar, RoleId, Phone, CreatedDate, Status, Code)
    VALUES 
    (N'admin@iotstar.vn', N'admin', N'Nguyễn Hữu Trung', N'123456', N'avatar1.png', 1, N'0908617108', GETDATE(), 1, NULL),
    (N'manager@iotstar.vn', N'manager', N'Trần Văn Quản Lý', N'123456', N'avatar2.png', 2, N'0901234567', GETDATE(), 1, NULL),
    (N'user@iotstar.vn', N'user', N'Nguyễn Văn A', N'123456', N'avatar3.png', 3, N'0987654321', GETDATE(), 1, NULL);
END
ELSE
BEGIN
    -- Thêm các cột nếu bảng Users đã tồn tại từ bài trước
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Users') AND name = 'Status')
    BEGIN
        ALTER TABLE Users ADD Status INT DEFAULT 1;
    END
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Users') AND name = 'Code')
    BEGIN
        ALTER TABLE Users ADD Code NVARCHAR(20) NULL;
    END
    ALTER TABLE Users ALTER COLUMN PassWord NVARCHAR(255) NOT NULL;
END
GO

-- 3. Bảng Videos (Mối quan hệ 1-N với Users và nhiều-1 với Category)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Videos')
BEGIN
    CREATE TABLE Videos (
        VideoId NVARCHAR(50) PRIMARY KEY,
        Active INT DEFAULT 1,
        Description NVARCHAR(500) NULL,
        Poster NVARCHAR(500) NULL,
        Title NVARCHAR(500) NULL,
        Views INT DEFAULT 0,
        CategoryId INT NULL,
        UserId INT NULL,
        CONSTRAINT FK_Videos_categories FOREIGN KEY (CategoryId) REFERENCES categories(CategoryId) ON DELETE SET NULL,
        CONSTRAINT FK_Videos_users FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE SET NULL
    );
END
ELSE
BEGIN
    -- Nếu bảng Videos đã tồn tại từ trước nhưng chưa có UserId
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Videos') AND name = 'UserId')
    BEGIN
        ALTER TABLE Videos ADD UserId INT NULL;
        ALTER TABLE Videos ADD CONSTRAINT FK_Videos_users FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE SET NULL;
    END
END
GO

-- Thêm dữ liệu mẫu Videos nếu bảng trống hoặc ít dữ liệu
IF (SELECT COUNT(*) FROM Videos) < 10
BEGIN
    DELETE FROM Videos;
    
    INSERT INTO Videos (VideoId, Active, Description, Poster, Title, Views, CategoryId, UserId)
    VALUES 
    (N'v01', 1, N'Video mở hộp iPhone 15 Pro Max chính hãng Titan Tự Nhiên', N'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=600', N'Đập hộp iPhone 15 Pro Max Titan', 1520, 1, 1),
    (N'v02', 1, N'Đánh giá chi tiết MacBook Air M2 sau 1 tháng sử dụng thực tế', N'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600', N'Trải nghiệm MacBook Air M2 thực tế', 2340, 2, 1),
    (N'v03', 1, N'Top 5 tai nghe chống ồn tốt nhất hiện nay cho dân văn phòng', N'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600', N'Top 5 Tai Nghe Chống Ồn Đỉnh Cao', 890, 3, 1),
    (N'v04', 1, N'Hướng dẫn cài đặt môi trường lập trình Java Web Jakarta Servlet', N'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=600', N'Lập trình Web Jakarta Servlet từ A-Z', 4500, 2, 1),
    (N'v05', 1, N'Trải nghiệm bàn phím cơ không dây giá rẻ cho sinh viên', N'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600', N'Đánh giá bàn phím cơ Custom giá rẻ', 1200, 3, 2),
    (N'v06', 1, N'So sánh camera Galaxy S24 Ultra và iPhone 15 Pro Max', N'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=600', N'So sánh Camera Galaxy S24 Ultra vs iPhone 15', 3100, 1, 2),
    (N'v07', 1, N'Setup góc làm việc tối giản phong cách Minimalist 2026', N'https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?w=600', N'Setup Desk Tour Công Nghệ Tối Giản', 5400, 2, 2),
    (N'v08', 1, N'Review iPad Pro M4 màn hình OLED mỏng nhất thế giới', N'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=600', N'Đánh giá iPad Pro M4 Siêu Mỏng', 2800, 1, 3),
    (N'v09', 1, N'Khám phá đồng hồ thông minh Apple Watch Ultra 2 leo núi', N'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=600', N'Trải nghiệm Apple Watch Ultra 2 dã ngoại', 1950, 3, 3),
    (N'v10', 1, N'Hướng dẫn phân trang trong JPA và Hibernate cực đơn giản', N'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=600', N'Thủ thuật JPA Hibernate Pagination', 6200, 2, 3),
    (N'v11', 1, N'Bí quyết chọn chuột công thái học chống mỏi cổ tay', N'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?w=600', N'Top chuột công thái học tốt nhất', 1100, 3, 3),
    (N'v12', 1, N'Cách upload file trong Jakarta EE Servlet với MultipartConfig', N'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=600', N'Multipart File Upload Jakarta Servlet', 3400, 2, 3);
END
GO

SELECT * FROM categories;
SELECT * FROM Users;
SELECT * FROM Videos;
GO
