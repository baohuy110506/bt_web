package vn.iotstar.dao.impl;

import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import vn.iotstar.config.JpaConfig;
import vn.iotstar.dao.VideoDao;
import vn.iotstar.entity.Video;

public class VideoDaoImpl implements VideoDao {

    @Override
    public int count() {
        EntityManager enma = JpaConfig.getEntityManager();
        String jpql = "SELECT COUNT(v) FROM Video v";
        try {
            Query query = enma.createQuery(jpql);
            return ((Long) query.getSingleResult()).intValue();
        } finally {
            enma.close();
        }
    }

    @Override
    public int countByUserId(int userId) {
        EntityManager enma = JpaConfig.getEntityManager();
        String jpql = "SELECT COUNT(v) FROM Video v WHERE v.user.id = :userId";
        try {
            Query query = enma.createQuery(jpql);
            query.setParameter("userId", userId);
            return ((Long) query.getSingleResult()).intValue();
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Video> findAll() {
        EntityManager enma = JpaConfig.getEntityManager();
        String jpql = "SELECT v FROM Video v ORDER BY v.videoId DESC";
        try {
            TypedQuery<Video> query = enma.createQuery(jpql, Video.class);
            return query.getResultList();
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Video> findAll(int page, int pageSize) {
        EntityManager enma = JpaConfig.getEntityManager();
        String jpql = "SELECT v FROM Video v ORDER BY v.videoId DESC";
        try {
            TypedQuery<Video> query = enma.createQuery(jpql, Video.class);
            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Video> findTop10Latest() {
        EntityManager enma = JpaConfig.getEntityManager();
        String jpql = "SELECT v FROM Video v WHERE v.active = 1 ORDER BY v.videoId DESC";
        try {
            TypedQuery<Video> query = enma.createQuery(jpql, Video.class);
            query.setMaxResults(10);
            return query.getResultList();
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Video> findByUserId(int userId) {
        EntityManager enma = JpaConfig.getEntityManager();
        String jpql = "SELECT v FROM Video v WHERE v.user.id = :userId ORDER BY v.videoId DESC";
        try {
            TypedQuery<Video> query = enma.createQuery(jpql, Video.class);
            query.setParameter("userId", userId);
            return query.getResultList();
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Video> findByUserId(int userId, int page, int pageSize) {
        EntityManager enma = JpaConfig.getEntityManager();
        String jpql = "SELECT v FROM Video v WHERE v.user.id = :userId ORDER BY v.videoId DESC";
        try {
            TypedQuery<Video> query = enma.createQuery(jpql, Video.class);
            query.setParameter("userId", userId);
            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } finally {
            enma.close();
        }
    }

    @Override
    public Video findById(String videoId) {
        EntityManager enma = JpaConfig.getEntityManager();
        try {
            return enma.find(Video.class, videoId);
        } finally {
            enma.close();
        }
    }

    @Override
    public void insert(Video video) {
        EntityManager enma = JpaConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            enma.persist(video);
            trans.commit();
        } catch (Exception e) {
            e.printStackTrace();
            if (trans.isActive()) {
                trans.rollback();
            }
            throw e;
        } finally {
            enma.close();
        }
    }

    @Override
    public void update(Video video) {
        EntityManager enma = JpaConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            enma.merge(video);
            trans.commit();
        } catch (Exception e) {
            e.printStackTrace();
            if (trans.isActive()) {
                trans.rollback();
            }
            throw e;
        } finally {
            enma.close();
        }
    }

    @Override
    public void delete(String videoId) {
        EntityManager enma = JpaConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            Video video = enma.find(Video.class, videoId);
            if (video != null) {
                enma.remove(video);
            }
            trans.commit();
        } catch (Exception e) {
            e.printStackTrace();
            if (trans.isActive()) {
                trans.rollback();
            }
            throw e;
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Video> searchByTitle(String keyword) {
        EntityManager enma = JpaConfig.getEntityManager();
        String jpql = "SELECT v FROM Video v WHERE v.title LIKE :keyword ORDER BY v.videoId DESC";
        try {
            TypedQuery<Video> query = enma.createQuery(jpql, Video.class);
            query.setParameter("keyword", "%" + keyword + "%");
            return query.getResultList();
        } finally {
            enma.close();
        }
    }
}
