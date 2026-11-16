package vn.iotstar.entity;

import java.io.Serializable;

import jakarta.persistence.*;

@Entity
@Table(name = "Videos")
@NamedQuery(name = "Video.findAll", query = "SELECT v FROM Video v")
public class Video implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "VideoId")
    private String videoId;

    @Column(name = "Active")
    private int active = 1;

    @Column(name = "Description", columnDefinition = "nvarchar(500) null")
    private String description;

    @Column(name = "Poster", columnDefinition = "nvarchar(500) null")
    private String poster;

    @Column(name = "Title", columnDefinition = "nvarchar(500) null")
    private String title;

    @Column(name = "Views")
    private int views = 0;

    // bi-directional many-to-one association to Category
    @ManyToOne
    @JoinColumn(name = "CategoryId")
    private Category category;

    // Mối quan hệ nhiều-1 với User (1 User có nhiều Videos)
    @ManyToOne
    @JoinColumn(name = "UserId")
    private User user;

    public Video() {
    }

    public Video(String videoId, int active, String description, String poster, String title, int views, Category category) {
        this.videoId = videoId;
        this.active = active;
        this.description = description;
        this.poster = poster;
        this.title = title;
        this.views = views;
        this.category = category;
    }

    public Video(String videoId, int active, String description, String poster, String title, int views, Category category, User user) {
        this.videoId = videoId;
        this.active = active;
        this.description = description;
        this.poster = poster;
        this.title = title;
        this.views = views;
        this.category = category;
        this.user = user;
    }

    public String getVideoId() {
        return this.videoId;
    }

    public void setVideoId(String videoId) {
        this.videoId = videoId;
    }

    public int getActive() {
        return this.active;
    }

    public void setActive(int active) {
        this.active = active;
    }

    public boolean getActiveStatus() {
        return this.active == 1;
    }

    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPoster() {
        return this.poster;
    }

    public void setPoster(String poster) {
        this.poster = poster;
    }

    public String getTitle() {
        return this.title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getViews() {
        return this.views;
    }

    public void setViews(int views) {
        this.views = views;
    }

    public Category getCategory() {
        return this.category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public Category getCategories() {
        return this.category;
    }

    public void setCategories(Category category) {
        this.category = category;
    }

    public User getUser() {
        return this.user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
