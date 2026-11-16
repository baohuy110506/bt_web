package vn.iotstar.dao.impl;

import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import vn.iotstar.config.JpaConfig;
import vn.iotstar.dao.UserDao;
import vn.iotstar.entity.User;

public class UserDaoImpl implements UserDao {

    @Override
    public User findByUsername(String username) {
        EntityManager enma = JpaConfig.getEntityManager();
        String jpql = "SELECT u FROM User u WHERE u.userName = :username";
        try {
            TypedQuery<User> query = enma.createQuery(jpql, User.class);
            query.setParameter("username", username);
            List<User> list = query.getResultList();
            if (list.isEmpty()) {
                return null;
            }
            return list.get(0);
        } finally {
            enma.close();
        }
    }

    @Override
    public User findByEmail(String email) {
        EntityManager enma = JpaConfig.getEntityManager();
        String jpql = "SELECT u FROM User u WHERE u.email = :email";
        try {
            TypedQuery<User> query = enma.createQuery(jpql, User.class);
            query.setParameter("email", email);
            List<User> list = query.getResultList();
            if (list.isEmpty()) {
                return null;
            }
            return list.get(0);
        } finally {
            enma.close();
        }
    }

    @Override
    public User get(String username) {
        return findByUsername(username);
    }

    @Override
    public void insert(User user) {
        EntityManager enma = JpaConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            enma.persist(user);
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
    public void update(User user) {
        EntityManager enma = JpaConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            enma.merge(user);
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
    public boolean checkExistEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        EntityManager enma = JpaConfig.getEntityManager();
        String jpql = "SELECT COUNT(u) FROM User u WHERE u.email = :email";
        try {
            Query query = enma.createQuery(jpql);
            query.setParameter("email", email.trim());
            Long count = (Long) query.getSingleResult();
            return count > 0;
        } finally {
            enma.close();
        }
    }

    @Override
    public boolean checkExistUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        EntityManager enma = JpaConfig.getEntityManager();
        String jpql = "SELECT COUNT(u) FROM User u WHERE u.userName = :username";
        try {
            Query query = enma.createQuery(jpql);
            query.setParameter("username", username.trim());
            Long count = (Long) query.getSingleResult();
            return count > 0;
        } finally {
            enma.close();
        }
    }

    @Override
    public boolean checkExistPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        EntityManager enma = JpaConfig.getEntityManager();
        String jpql = "SELECT COUNT(u) FROM User u WHERE u.phone = :phone";
        try {
            Query query = enma.createQuery(jpql);
            query.setParameter("phone", phone.trim());
            Long count = (Long) query.getSingleResult();
            return count > 0;
        } finally {
            enma.close();
        }
    }
}
