-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Máy chủ: mysql:3306
-- Thời gian đã tạo: Th10 11, 2026 lúc 09:49 AM
-- Phiên bản máy phục vụ: 8.0.46
-- Phiên bản PHP: 8.3.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `mental_health_db`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `action_logs`
--

CREATE TABLE `action_logs` (
  `id` bigint NOT NULL,
  `action_id` bigint NOT NULL,
  `patient_id` bigint NOT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `status` enum('PENDING','COMPLETED','MISSED','DECLINED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `note` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` bigint NOT NULL,
  `actor_id` bigint NOT NULL COMMENT 'Người thực hiện hành động',
  `action` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'CREATE, UPDATE, DELETE, LOGIN, etc.',
  `entity_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Bảng nào bị ảnh hưởng',
  `entity_id` bigint NOT NULL COMMENT 'ID của record bị tác động',
  `old_value` json DEFAULT NULL COMMENT 'Giá trị cũ trước khi thay đổi',
  `new_value` json DEFAULT NULL COMMENT 'Giá trị mới sau khi thay đổi',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chat_messages`
--

CREATE TABLE `chat_messages` (
  `id` bigint NOT NULL,
  `session_id` bigint NOT NULL,
  `sender_role` enum('PATIENT','DOCTOR','SYSTEM') COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chat_sessions`
--

CREATE TABLE `chat_sessions` (
  `id` bigint NOT NULL,
  `patient_id` bigint NOT NULL,
  `doctor_id` bigint NOT NULL,
  `mode` enum('NORMAL') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NORMAL',
  `started_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ended_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `check_ins`
--

CREATE TABLE `check_ins` (
  `id` bigint NOT NULL,
  `patient_id` bigint NOT NULL,
  `mood` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stress_level` enum('VERY_LOW','LOW','MODERATE','HIGH','VERY_HIGH') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `doctor_assignments`
--

CREATE TABLE `doctor_assignments` (
  `id` bigint NOT NULL,
  `doctor_id` bigint NOT NULL,
  `patient_id` bigint NOT NULL,
  `previous_assignment_id` bigint DEFAULT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời điểm bắt đầu phụ trách',
  `ended_at` timestamp NULL DEFAULT NULL COMMENT 'Bắt buộc khi status là TRANSFERRED hoặc ENDED',
  `status` enum('ACTIVE','TRANSFERRED','ENDED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `doctor_notes`
--

CREATE TABLE `doctor_notes` (
  `id` bigint NOT NULL,
  `doctor_id` bigint NOT NULL,
  `patient_id` bigint NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `doctor_notifications`
--

CREATE TABLE `doctor_notifications` (
  `id` bigint NOT NULL,
  `doctor_id` bigint NOT NULL,
  `patient_id` bigint NOT NULL,
  `type` enum('RISK_ALERT','ADHERENCE_ALERT','MOOD_ALERT','SCREENING_RESULT','PLAN_REMINDER') COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nội dung chi tiết của notification',
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `doctor_profiles`
--

CREATE TABLE `doctor_profiles` (
  `id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `license_number` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `approval_status` enum('PENDING','APPROVED','REJECTED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `approved_by` bigint DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `phone` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bio` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `emergency_actions`
--

CREATE TABLE `emergency_actions` (
  `id` bigint NOT NULL,
  `emergency_event_id` bigint NOT NULL,
  `action_type` enum('CALL_115','SEND_SMS_TO_CONTACT','DISPATCH_AMBULANCE','CUSTOM') COLLATE utf8mb4_unicode_ci NOT NULL,
  `started_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` timestamp NULL DEFAULT NULL,
  `result` enum('PENDING','IN_PROGRESS','COMPLETED','FAILED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `note` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `emergency_contacts`
--

CREATE TABLE `emergency_contacts` (
  `id` bigint NOT NULL,
  `patient_id` bigint NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `relationship` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` int NOT NULL DEFAULT '1' COMMENT '1 = highest priority, 2+ = lower priority',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `emergency_events`
--

CREATE TABLE `emergency_events` (
  `id` bigint NOT NULL,
  `patient_id` bigint NOT NULL,
  `risk_detection_id` bigint NOT NULL,
  `status` enum('TRIGGERED','HELP_ON_WAY','IN_PROGRESS','RESOLVED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'TRIGGERED',
  `triggered_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời điểm sự kiện được kích hoạt',
  `resolved_at` timestamp NULL DEFAULT NULL COMMENT 'Thời điểm sự kiện được giải quyết',
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `medications`
--

CREATE TABLE `medications` (
  `id` bigint NOT NULL,
  `patient_id` bigint NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dosage` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `frequency` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `patient_achievements`
--

CREATE TABLE `patient_achievements` (
  `id` bigint NOT NULL,
  `patient_id` bigint NOT NULL,
  `milestone_id` bigint NOT NULL,
  `achieved_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `patient_profiles`
--

CREATE TABLE `patient_profiles` (
  `id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `diagnosis_history` text COLLATE utf8mb4_unicode_ci COMMENT 'Các chẩn đoán tâm lý/tâm thần đã từng được ghi nhận',
  `treatment_history` text COLLATE utf8mb4_unicode_ci COMMENT 'Lịch sử điều trị, tư vấn hoặc trị liệu',
  `mental_health_notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Thông tin sức khỏe tâm lý quan trọng khác bác sĩ cần biết',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `patient_streaks`
--

CREATE TABLE `patient_streaks` (
  `id` bigint NOT NULL,
  `patient_id` bigint NOT NULL,
  `current_streak` int NOT NULL DEFAULT '0' COMMENT 'Chuỗi hiện tại (số ngày liên tiếp)',
  `longest_streak` int NOT NULL DEFAULT '0' COMMENT 'Chuỗi dài nhất từng đạt được',
  `last_completed_date` date DEFAULT NULL COMMENT 'Ngày cuối cùng hoàn thành action (để check liên tiếp)',
  `total_completed_days` int NOT NULL DEFAULT '0' COMMENT 'Tổng số ngày đã hoàn thành (lifetime)',
  `total_points` int NOT NULL DEFAULT '0' COMMENT 'Tổng điểm tích lũy',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `plans`
--

CREATE TABLE `plans` (
  `id` bigint NOT NULL,
  `patient_id` bigint NOT NULL,
  `doctor_id` bigint NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `status` enum('ACTIVE','COMPLETED','CANCELLED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE',
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `plan_actions`
--

CREATE TABLE `plan_actions` (
  `id` bigint NOT NULL,
  `plan_id` bigint NOT NULL,
  `action_type` enum('MEDICATION','EXERCISE','SLEEP','JOURNAL','APPOINTMENT','CUSTOM') COLLATE utf8mb4_unicode_ci NOT NULL,
  `detail` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `scheduled_time` time DEFAULT NULL COMMENT 'Thời điểm cụ thể trong ngày (kiểu time) mà hành động được lên lịch thực hiện',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `reminder_logs`
--

CREATE TABLE `reminder_logs` (
  `id` bigint NOT NULL,
  `action_log_id` bigint NOT NULL,
  `patient_id` bigint NOT NULL,
  `reminder_type` enum('ZALO','EMAIL','TELEGRAM','WEB') COLLATE utf8mb4_unicode_ci NOT NULL,
  `scheduled_at` timestamp NOT NULL,
  `sent_at` timestamp NULL DEFAULT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('PENDING','SENT','FAILED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `risk_detections`
--

CREATE TABLE `risk_detections` (
  `id` bigint NOT NULL,
  `patient_id` bigint NOT NULL,
  `source_type` enum('CHAT','CHECK_IN','SCREENING') COLLATE utf8mb4_unicode_ci NOT NULL,
  `detection_layer` enum('REGEX','PHOBERT') COLLATE utf8mb4_unicode_ci NOT NULL,
  `signal` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `risk_level` enum('LOW','MODERATE','HIGH','CRITICAL') COLLATE utf8mb4_unicode_ci NOT NULL,
  `confidence` double NOT NULL,
  `detected_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `screening_attempts`
--

CREATE TABLE `screening_attempts` (
  `id` bigint NOT NULL,
  `patient_id` bigint NOT NULL,
  `status` enum('IN_PROGRESS','COMPLETED','ABANDONED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'IN_PROGRESS',
  `started_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `screening_questions`
--

CREATE TABLE `screening_questions` (
  `id` bigint NOT NULL,
  `screening_type_id` bigint NOT NULL,
  `question_number` int NOT NULL,
  `question_text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_type` enum('SCALE','YES_NO','TEXT') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `screening_results`
--

CREATE TABLE `screening_results` (
  `id` bigint NOT NULL,
  `patient_id` bigint NOT NULL,
  `attempt_id` bigint NOT NULL,
  `screening_type_id` bigint NOT NULL,
  `answers` json NOT NULL,
  `total_score` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `screening_types`
--

CREATE TABLE `screening_types` (
  `id` bigint NOT NULL,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `total_questions` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `streak_logs`
--

CREATE TABLE `streak_logs` (
  `id` bigint NOT NULL,
  `patient_id` bigint NOT NULL,
  `log_date` date NOT NULL COMMENT 'Ngày được tính streak',
  `actions_required` int NOT NULL COMMENT 'Số actions cần hoàn thành trong ngày',
  `actions_completed` int NOT NULL COMMENT 'Số actions đã hoàn thành',
  `is_streak_day` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'TRUE nếu đạt đủ điều kiện streak (vd: >= 80%)',
  `streak_count` int NOT NULL COMMENT 'Số ngày streak tại thời điểm này',
  `points_earned` int NOT NULL DEFAULT '0' COMMENT 'Điểm kiếm được trong ngày',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `streak_milestones`
--

CREATE TABLE `streak_milestones` (
  `id` bigint NOT NULL,
  `streak_days` int NOT NULL COMMENT 'Mốc streak: 3, 7, 14, 30, 60, 90, 180, 365',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Kiên trì 7 ngày, Kiên trì 1 tháng',
  `description` text COLLATE utf8mb4_unicode_ci,
  `badge_icon` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL hoặc code của icon/badge',
  `points` int NOT NULL DEFAULT '0' COMMENT 'Điểm thưởng khi đạt mốc',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` bigint NOT NULL,
  `role` enum('PATIENT','DOCTOR','ADMIN') COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('MALE','FEMALE','OTHER') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `action_logs`
--
ALTER TABLE `action_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_action_logs_patient` (`patient_id`),
  ADD KEY `idx_action_logs_action` (`action_id`),
  ADD KEY `idx_action_logs_status` (`status`),
  ADD KEY `idx_action_logs_patient_status` (`patient_id`,`status`),
  ADD KEY `idx_action_logs_action_created` (`action_id`,`created_at`);

--
-- Chỉ mục cho bảng `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_audit_logs_actor` (`actor_id`),
  ADD KEY `idx_audit_logs_created` (`created_at`),
  ADD KEY `idx_audit_logs_entity_type` (`entity_type`),
  ADD KEY `idx_audit_logs_entity` (`entity_type`,`entity_id`),
  ADD KEY `idx_audit_logs_actor_created` (`actor_id`,`created_at`);

--
-- Chỉ mục cho bảng `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_chat_messages_session` (`session_id`),
  ADD KEY `idx_chat_messages_session_created` (`session_id`,`created_at`),
  ADD KEY `idx_chat_messages_created` (`created_at`);

--
-- Chỉ mục cho bảng `chat_sessions`
--
ALTER TABLE `chat_sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_chat_sessions_patient` (`patient_id`),
  ADD KEY `idx_chat_sessions_doctor` (`doctor_id`),
  ADD KEY `idx_chat_sessions_patient_started` (`patient_id`,`started_at`);

--
-- Chỉ mục cho bảng `check_ins`
--
ALTER TABLE `check_ins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_check_ins_patient` (`patient_id`),
  ADD KEY `idx_check_ins_created` (`created_at`),
  ADD KEY `idx_check_ins_patient_created` (`patient_id`,`created_at`);

--
-- Chỉ mục cho bảng `doctor_assignments`
--
ALTER TABLE `doctor_assignments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_previous_assignment` (`previous_assignment_id`),
  ADD KEY `idx_doc_assign_doctor` (`doctor_id`),
  ADD KEY `idx_doc_assign_patient` (`patient_id`),
  ADD KEY `idx_doc_assign_status` (`status`),
  ADD KEY `idx_doc_assign_composite` (`doctor_id`,`patient_id`,`status`);

--
-- Chỉ mục cho bảng `doctor_notes`
--
ALTER TABLE `doctor_notes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_doctor_notes_doctor` (`doctor_id`),
  ADD KEY `idx_doctor_notes_patient` (`patient_id`),
  ADD KEY `idx_doctor_notes_patient_created` (`patient_id`,`created_at`);

--
-- Chỉ mục cho bảng `doctor_notifications`
--
ALTER TABLE `doctor_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_doctor_notifications_doctor` (`doctor_id`),
  ADD KEY `idx_doctor_notifications_patient` (`patient_id`),
  ADD KEY `idx_doctor_notifications_is_read` (`is_read`),
  ADD KEY `idx_doctor_notifications_composite` (`doctor_id`,`is_read`,`created_at`);

--
-- Chỉ mục cho bảng `doctor_profiles`
--
ALTER TABLE `doctor_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_doctor_profiles_user_id` (`user_id`),
  ADD UNIQUE KEY `uq_doctor_profiles_license` (`license_number`),
  ADD KEY `idx_doctor_profiles_approval_status` (`approval_status`),
  ADD KEY `idx_doctor_profiles_approved_by` (`approved_by`);

--
-- Chỉ mục cho bảng `emergency_actions`
--
ALTER TABLE `emergency_actions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_emergency_actions_event` (`emergency_event_id`),
  ADD KEY `idx_emergency_actions_result` (`result`);

--
-- Chỉ mục cho bảng `emergency_contacts`
--
ALTER TABLE `emergency_contacts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_emergency_contacts_patient_id` (`patient_id`),
  ADD KEY `idx_emergency_contacts_priority` (`patient_id`,`priority`);

--
-- Chỉ mục cho bảng `emergency_events`
--
ALTER TABLE `emergency_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_emergency_events_patient` (`patient_id`),
  ADD KEY `idx_emergency_events_status` (`status`),
  ADD KEY `idx_emergency_events_triggered` (`triggered_at`),
  ADD KEY `idx_emergency_events_patient_status` (`patient_id`,`status`),
  ADD KEY `fk_emergency_events_risk` (`risk_detection_id`);

--
-- Chỉ mục cho bảng `medications`
--
ALTER TABLE `medications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_medications_patient_id` (`patient_id`),
  ADD KEY `idx_medications_dates` (`start_date`,`end_date`),
  ADD KEY `idx_medications_patient_start` (`patient_id`,`start_date`);

--
-- Chỉ mục cho bảng `patient_achievements`
--
ALTER TABLE `patient_achievements`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_patient_milestone` (`patient_id`,`milestone_id`),
  ADD KEY `idx_patient_achievements_patient` (`patient_id`),
  ADD KEY `idx_patient_achievements_milestone` (`milestone_id`);

--
-- Chỉ mục cho bảng `patient_profiles`
--
ALTER TABLE `patient_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_patient_profiles_user_id` (`user_id`);

--
-- Chỉ mục cho bảng `patient_streaks`
--
ALTER TABLE `patient_streaks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_patient_streaks_patient` (`patient_id`),
  ADD KEY `idx_patient_streaks_current` (`current_streak`),
  ADD KEY `idx_patient_streaks_longest` (`longest_streak`),
  ADD KEY `idx_patient_streaks_points` (`total_points`);

--
-- Chỉ mục cho bảng `plans`
--
ALTER TABLE `plans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_plans_patient` (`patient_id`),
  ADD KEY `idx_plans_doctor` (`doctor_id`),
  ADD KEY `idx_plans_status` (`status`),
  ADD KEY `idx_plans_patient_status` (`patient_id`,`status`);

--
-- Chỉ mục cho bảng `plan_actions`
--
ALTER TABLE `plan_actions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_plan_actions_plan` (`plan_id`),
  ADD KEY `idx_plan_actions_type` (`action_type`);

--
-- Chỉ mục cho bảng `reminder_logs`
--
ALTER TABLE `reminder_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_reminder_logs_patient` (`patient_id`),
  ADD KEY `idx_reminder_logs_action_log` (`action_log_id`),
  ADD KEY `idx_reminder_logs_status` (`status`),
  ADD KEY `idx_reminder_logs_scheduled` (`scheduled_at`);

--
-- Chỉ mục cho bảng `risk_detections`
--
ALTER TABLE `risk_detections`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_risk_detections_patient` (`patient_id`),
  ADD KEY `idx_risk_detections_risk_level` (`risk_level`),
  ADD KEY `idx_risk_detections_detected` (`detected_at`),
  ADD KEY `idx_risk_detections_composite` (`patient_id`,`risk_level`,`detected_at`);

--
-- Chỉ mục cho bảng `screening_attempts`
--
ALTER TABLE `screening_attempts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_screening_attempts_patient` (`patient_id`),
  ADD KEY `idx_screening_attempts_status` (`status`),
  ADD KEY `idx_screening_attempts_patient_status` (`patient_id`,`status`);

--
-- Chỉ mục cho bảng `screening_questions`
--
ALTER TABLE `screening_questions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_type_question_number` (`screening_type_id`,`question_number`),
  ADD KEY `idx_screening_questions_type` (`screening_type_id`);

--
-- Chỉ mục cho bảng `screening_results`
--
ALTER TABLE `screening_results`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_screening_results_patient` (`patient_id`),
  ADD KEY `idx_screening_results_attempt` (`attempt_id`),
  ADD KEY `idx_screening_results_type` (`screening_type_id`),
  ADD KEY `idx_screening_results_created` (`created_at`),
  ADD KEY `idx_screening_results_composite` (`patient_id`,`screening_type_id`,`created_at`);

--
-- Chỉ mục cho bảng `screening_types`
--
ALTER TABLE `screening_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_screening_types_code` (`code`);

--
-- Chỉ mục cho bảng `streak_logs`
--
ALTER TABLE `streak_logs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_streak_logs_patient_date` (`patient_id`,`log_date`),
  ADD KEY `idx_streak_logs_patient` (`patient_id`),
  ADD KEY `idx_streak_logs_date` (`log_date`);

--
-- Chỉ mục cho bảng `streak_milestones`
--
ALTER TABLE `streak_milestones`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_streak_milestones_days` (`streak_days`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_users_phone` (`phone`),
  ADD KEY `idx_users_role` (`role`),
  ADD KEY `idx_users_status` (`status`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `action_logs`
--
ALTER TABLE `action_logs`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `chat_messages`
--
ALTER TABLE `chat_messages`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `chat_sessions`
--
ALTER TABLE `chat_sessions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `check_ins`
--
ALTER TABLE `check_ins`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `doctor_assignments`
--
ALTER TABLE `doctor_assignments`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `doctor_notes`
--
ALTER TABLE `doctor_notes`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `doctor_notifications`
--
ALTER TABLE `doctor_notifications`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `doctor_profiles`
--
ALTER TABLE `doctor_profiles`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `emergency_actions`
--
ALTER TABLE `emergency_actions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `emergency_contacts`
--
ALTER TABLE `emergency_contacts`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `emergency_events`
--
ALTER TABLE `emergency_events`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `medications`
--
ALTER TABLE `medications`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `patient_achievements`
--
ALTER TABLE `patient_achievements`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `patient_profiles`
--
ALTER TABLE `patient_profiles`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `patient_streaks`
--
ALTER TABLE `patient_streaks`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `plans`
--
ALTER TABLE `plans`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `plan_actions`
--
ALTER TABLE `plan_actions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `reminder_logs`
--
ALTER TABLE `reminder_logs`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `risk_detections`
--
ALTER TABLE `risk_detections`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `screening_attempts`
--
ALTER TABLE `screening_attempts`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `screening_questions`
--
ALTER TABLE `screening_questions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `screening_results`
--
ALTER TABLE `screening_results`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `screening_types`
--
ALTER TABLE `screening_types`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `streak_logs`
--
ALTER TABLE `streak_logs`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `streak_milestones`
--
ALTER TABLE `streak_milestones`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- Ràng buộc đối với các bảng kết xuất
--

--
-- Ràng buộc cho bảng `action_logs`
--
ALTER TABLE `action_logs`
  ADD CONSTRAINT `fk_action_logs_action` FOREIGN KEY (`action_id`) REFERENCES `plan_actions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_action_logs_patient` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `fk_audit_logs_actor` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD CONSTRAINT `fk_chat_messages_session` FOREIGN KEY (`session_id`) REFERENCES `chat_sessions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `chat_sessions`
--
ALTER TABLE `chat_sessions`
  ADD CONSTRAINT `fk_chat_sessions_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_chat_sessions_patient` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `check_ins`
--
ALTER TABLE `check_ins`
  ADD CONSTRAINT `fk_check_ins_patient` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `doctor_assignments`
--
ALTER TABLE `doctor_assignments`
  ADD CONSTRAINT `fk_doc_assign_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_doc_assign_patient` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_doc_assign_prev` FOREIGN KEY (`previous_assignment_id`) REFERENCES `doctor_assignments` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `doctor_notes`
--
ALTER TABLE `doctor_notes`
  ADD CONSTRAINT `fk_doctor_notes_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_doctor_notes_patient` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `doctor_notifications`
--
ALTER TABLE `doctor_notifications`
  ADD CONSTRAINT `fk_doctor_notifications_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_doctor_notifications_patient` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `doctor_profiles`
--
ALTER TABLE `doctor_profiles`
  ADD CONSTRAINT `fk_doctor_profiles_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_doctor_profiles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `emergency_actions`
--
ALTER TABLE `emergency_actions`
  ADD CONSTRAINT `fk_emergency_actions_event` FOREIGN KEY (`emergency_event_id`) REFERENCES `emergency_events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `emergency_contacts`
--
ALTER TABLE `emergency_contacts`
  ADD CONSTRAINT `fk_emergency_contacts_patient` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `emergency_events`
--
ALTER TABLE `emergency_events`
  ADD CONSTRAINT `fk_emergency_events_patient` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_emergency_events_risk` FOREIGN KEY (`risk_detection_id`) REFERENCES `risk_detections` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `medications`
--
ALTER TABLE `medications`
  ADD CONSTRAINT `fk_medications_patient` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `patient_achievements`
--
ALTER TABLE `patient_achievements`
  ADD CONSTRAINT `fk_patient_achievements_milestone` FOREIGN KEY (`milestone_id`) REFERENCES `streak_milestones` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_patient_achievements_patient` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `patient_profiles`
--
ALTER TABLE `patient_profiles`
  ADD CONSTRAINT `fk_patient_profiles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `patient_streaks`
--
ALTER TABLE `patient_streaks`
  ADD CONSTRAINT `fk_patient_streaks_patient` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `plans`
--
ALTER TABLE `plans`
  ADD CONSTRAINT `fk_plans_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_plans_patient` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `plan_actions`
--
ALTER TABLE `plan_actions`
  ADD CONSTRAINT `fk_plan_actions_plan` FOREIGN KEY (`plan_id`) REFERENCES `plans` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `reminder_logs`
--
ALTER TABLE `reminder_logs`
  ADD CONSTRAINT `fk_reminder_logs_action_log` FOREIGN KEY (`action_log_id`) REFERENCES `action_logs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_reminder_logs_patient` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `risk_detections`
--
ALTER TABLE `risk_detections`
  ADD CONSTRAINT `fk_risk_detections_patient` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `screening_attempts`
--
ALTER TABLE `screening_attempts`
  ADD CONSTRAINT `fk_screening_attempts_patient` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `screening_questions`
--
ALTER TABLE `screening_questions`
  ADD CONSTRAINT `fk_screening_questions_type` FOREIGN KEY (`screening_type_id`) REFERENCES `screening_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `screening_results`
--
ALTER TABLE `screening_results`
  ADD CONSTRAINT `fk_screening_results_attempt` FOREIGN KEY (`attempt_id`) REFERENCES `screening_attempts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_screening_results_patient` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_screening_results_type` FOREIGN KEY (`screening_type_id`) REFERENCES `screening_types` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `streak_logs`
--
ALTER TABLE `streak_logs`
  ADD CONSTRAINT `fk_streak_logs_patient` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
