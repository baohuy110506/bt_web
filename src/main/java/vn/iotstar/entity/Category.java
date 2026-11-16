package vn.iotstar.entity;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;

@Entity
@Table(name = "categories")
@NamedQuery(name = "Category.findAll", query = "SELECT c FROM Category c")
public class Category implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "CategoryId")
    private int categoryid;

    @Column(name = "CategoryName", columnDefinition = "nvarchar(50) not null")
    @NotEmpty(message = "Không được phép rỗng")
    private String categoryname;

    @Column(name = "Images", columnDefinition = "nvarchar(500) null")
    private String images;

    @Column(name = "Status")
    private int status;

    // bi-directional many-to-one association to Video
    @OneToMany(mappedBy = "category", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Video> videos = new ArrayList<>();

    public Category() {
    }

    public Category(int categoryid, String categoryname, String images, int status, List<Video> videos) {
        this.categoryid = categoryid;
        this.categoryname = categoryname;
        this.images = images;
        this.status = status;
        this.videos = videos != null ? videos : new ArrayList<>();
    }

    public Category(String categoryname, String images, int status) {
        this.categoryname = categoryname;
        this.images = images;
        this.status = status;
    }

    public int getCategoryid() {
        return this.categoryid;
    }

    public void setCategoryid(int categoryid) {
        this.categoryid = categoryid;
    }

    // Compatibility getters & setters
    public int getCategoryId() {
        return this.categoryid;
    }

    public void setCategoryId(int categoryId) {
        this.categoryid = categoryId;
    }

    public int getId() {
        return this.categoryid;
    }

    public void setId(int id) {
        this.categoryid = id;
    }

    public String getCategoryname() {
        return this.categoryname;
    }

    public void setCategoryname(String categoryname) {
        this.categoryname = categoryname;
    }

    public String getName() {
        return this.categoryname;
    }

    public void setName(String name) {
        this.categoryname = name;
    }

    public String getCateName() {
        return this.categoryname;
    }

    public void setCateName(String cateName) {
        this.categoryname = cateName;
    }

    public String getImages() {
        if (images == null || images.trim().isEmpty()) {
            return "avatar.png";
        }
        return this.images;
    }

    public void setImages(String images) {
        this.images = images;
    }

    public String getIcon() {
        return getImages();
    }

    public void setIcon(String icon) {
        setImages(icon);
    }

    public String getIcons() {
        return getImages();
    }

    public void setIcons(String icons) {
        setImages(icons);
    }

    public int getStatus() {
        return this.status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public List<Video> getVideos() {
        if (this.videos == null) {
            this.videos = new ArrayList<>();
        }
        return this.videos;
    }

    public void setVideos(List<Video> videos) {
        this.videos = videos;
    }

    public Video addVideo(Video video) {
        getVideos().add(video);
        video.setCategory(this);
        return video;
    }

    public Video removeVideo(Video video) {
        getVideos().remove(video);
        video.setCategory(null);
        return video;
    }
}
