package vn.iotstar.dao;

import java.util.List;
import vn.iotstar.entity.Video;

public interface IVideoDao {
    int count();
    int countByUserId(int userId);
    List<Video> findAll();
    List<Video> findAll(int page, int pageSize);
    List<Video> findTop10Latest();
    List<Video> findByUserId(int userId);
    List<Video> findByUserId(int userId, int page, int pageSize);
    Video findById(String videoId);
    void insert(Video video);
    void update(Video video);
    void delete(String videoId);
    List<Video> searchByTitle(String keyword);
}
