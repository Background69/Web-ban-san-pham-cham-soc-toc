package com.example.nhom49_webbansanphamchamsoctoc.services;
import com.example.nhom49_webbansanphamchamsoctoc.dao.UserStatusHistoryDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.UserStatusHistory;
import java.util.List;

public class UserStatusHistoryService {
    private final UserStatusHistoryDAO userStatusHistoryDAO;

    public UserStatusHistoryService() {
        this.userStatusHistoryDAO = new UserStatusHistoryDAO();
    }

    public long insertHistory(UserStatusHistory history) {
        return userStatusHistoryDAO.insertHistory(history);
    }

    public List<UserStatusHistory> findByUserId(int userId) {
        return userStatusHistoryDAO.findByUserId(userId);
    }
}