package vn.iotstar.service.impl;

import java.util.List;
import vn.iotstar.dao.VideoDao;
import vn.iotstar.dao.impl.VideoDaoImpl;
import vn.iotstar.entity.Video;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.VideoService;

public class VideoServiceImpl implements IVideoService, VideoService {

    private VideoDao videoDao = new VideoDaoImpl();

    @Override
    public int count() {
        return videoDao.count();
    }

    @Override
    public int countByUserId(int userId) {
        return videoDao.countByUserId(userId);
    }

    @Override
    public List<Video> findAll() {
        return videoDao.findAll();
    }

    @Override
    public List<Video> findAll(int page, int pageSize) {
        return videoDao.findAll(page, pageSize);
    }

    @Override
    public List<Video> findTop10Latest() {
        return videoDao.findTop10Latest();
    }

    @Override
    public List<Video> findByUserId(int userId) {
        return videoDao.findByUserId(userId);
    }

    @Override
    public List<Video> findByUserId(int userId, int page, int pageSize) {
        return videoDao.findByUserId(userId, page, pageSize);
    }

    @Override
    public Video findById(String videoId) {
        return videoDao.findById(videoId);
    }

    @Override
    public void insert(Video video) {
        videoDao.insert(video);
    }

    @Override
    public void update(Video video) {
        videoDao.update(video);
    }

    @Override
    public void delete(String videoId) {
        videoDao.delete(videoId);
    }

    @Override
    public List<Video> searchByTitle(String keyword) {
        return videoDao.searchByTitle(keyword);
    }

    @Override
    public void incrementViews(String videoId) {
        Video video = videoDao.findById(videoId);
        if (video != null) {
            video.setViews(video.getViews() + 1);
            videoDao.update(video);
        }
    }
}
