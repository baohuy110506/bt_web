package vn.iotstar.entity;

import java.io.Serializable;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.*;

@Entity
@Table(name = "Users")
@NamedQuery(name = "User.findAll", query = "SELECT u FROM User u")
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private int id;

    @Column(name = "Email", columnDefinition = "nvarchar(100) null")
    private String email;

    @Column(name = "UserName", columnDefinition = "nvarchar(50) null")
    private String userName;

    @Column(name = "FullName", columnDefinition = "nvarchar(100) null")
    private String fullName;

    @Column(name = "PassWord", columnDefinition = "nvarchar(255) null")
    private String passWord;

    @Column(name = "Avatar", columnDefinition = "nvarchar(200) null")
    private String avatar;

    @Column(name = "RoleId")
    private int roleid;

    @Column(name = "Phone", columnDefinition = "nvarchar(20) null")
    private String phone;

    @Column(name = "CreatedDate")
    private Date createdDate;

    @Column(name = "Status")
    private int status = 1; // 1: Kích hoạt, 0: Chưa kích hoạt

    @Column(name = "Code", columnDefinition = "nvarchar(20) null")
    private String code; // Mã OTP xác thực kích hoạt hoặc đổi mật khẩu

    // Mối quan hệ 1-N với Video (1 User sở hữu nhiều Video)
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Video> videos = new ArrayList<>();

    public User() {
    }

    public User(String email, String userName, String fullName, String passWord, String avatar, int roleid, String phone, Date createdDate) {
        this.email = email;
        this.userName = userName;
        this.fullName = fullName;
        this.passWord = passWord;
        this.avatar = avatar;
        this.roleid = roleid;
        this.phone = phone;
        this.createdDate = createdDate;
        this.status = 1;
    }

    public User(int id, String email, String userName, String fullName, String passWord, String avatar, int roleid, String phone, Date createdDate) {
        this.id = id;
        this.email = email;
        this.userName = userName;
        this.fullName = fullName;
        this.passWord = passWord;
        this.avatar = avatar;
        this.roleid = roleid;
        this.phone = phone;
        this.createdDate = createdDate;
        this.status = 1;
    }

    public int getId() {
        return this.id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmail() {
        return this.email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUserName() {
        return this.userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUsername() {
        return this.userName;
    }

    public void setUsername(String username) {
        this.userName = username;
    }

    public String getFullName() {
        return this.fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPassWord() {
        return this.passWord;
    }

    public void setPassWord(String passWord) {
        this.passWord = passWord;
    }

    public String getPassword() {
        return this.passWord;
    }

    public void setPassword(String password) {
        this.passWord = password;
    }

    public String getAvatar() {
        return this.avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public int getRoleid() {
        return this.roleid;
    }

    public void setRoleid(int roleid) {
        this.roleid = roleid;
    }

    public String getPhone() {
        return this.phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Date getCreatedDate() {
        return this.createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public int getStatus() {
        return this.status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public boolean isActive() {
        return this.status == 1;
    }

    public String getCode() {
        return this.code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public List<Video> getVideos() {
        return this.videos;
    }

    public void setVideos(List<Video> videos) {
        this.videos = videos;
    }

    public Video addVideo(Video video) {
        getVideos().add(video);
        video.setUser(this);
        return video;
    }

    public Video removeVideo(Video video) {
        getVideos().remove(video);
        video.setUser(null);
        return video;
    }
}
