# ************************************************************
# Sequel Pro SQL dump
# Version 5040
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.23-log)
# Database: notebowl_development
# Generation Time: 2018-08-28 00:46:08 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
SET NAMES utf8mb4;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table abuses
# ------------------------------------------------------------

DROP TABLE IF EXISTS `abuses`;

CREATE TABLE `abuses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `reason` enum('inappropriate','spam') NOT NULL DEFAULT 'inappropriate',
  `parent_id` int(10) unsigned NOT NULL,
  `parent_type` varchar(190) NOT NULL,
  `reporter_id` int(11) NOT NULL,
  `defendant_id` int(11) NOT NULL,
  `university_id` int(11) NOT NULL,
  `anonymous` tinyint(1) NOT NULL DEFAULT '0',
  `resource_key` varchar(32) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `status` enum('pending','dismissed','verified') NOT NULL DEFAULT 'pending',
  PRIMARY KEY (`id`),
  UNIQUE KEY `abuses_resource_key_unique` (`resource_key`),
  KEY `abuses_parent_id_parent_type_index` (`parent_id`,`parent_type`),
  KEY `abuses_reporter_id_index` (`reporter_id`),
  KEY `abuses_defendant_id_index` (`defendant_id`),
  KEY `abuses_university_id_index` (`university_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table activity_logs
# ------------------------------------------------------------

DROP TABLE IF EXISTS `activity_logs`;

CREATE TABLE `activity_logs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  `action` varchar(190) NOT NULL,
  `user_session_id` int(10) unsigned DEFAULT NULL,
  `target_id` int(10) unsigned NOT NULL,
  `target_type` varchar(190) NOT NULL,
  `resource_key` varchar(32) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `before` longtext,
  `after` longtext,
  `delta` longtext,
  `url` text,
  `method` varchar(255) DEFAULT NULL,
  `params` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `activity_logs_resource_key_unique` (`resource_key`),
  KEY `activity_logs_target_id_target_type_index` (`target_id`,`target_type`),
  KEY `activity_logs_user_id_index` (`user_id`),
  KEY `activity_logs_user_session_id_index` (`user_session_id`),
  KEY `activity_logs_action_index` (`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `activity_logs` WRITE;
/*!40000 ALTER TABLE `activity_logs` DISABLE KEYS */;

INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `user_session_id`, `target_id`, `target_type`, `resource_key`, `created_at`, `updated_at`, `deleted_at`, `before`, `after`, `delta`, `url`, `method`, `params`)
VALUES
	(1,1,'created',1,3,'App\\Models\\Course','g839dfb3a46f6414390d880311dc369b','2018-08-28 00:04:20.443900','2018-08-28 00:04:20.443900',NULL,'a:0:{}','a:69:{s:5:\"units\";d:0;s:12:\"resource_key\";s:32:\"lc70cff6d40844d52b9927fa9a406a13\";s:7:\"term_id\";i:1;s:13:\"university_id\";i:1;s:14:\"available_date\";s:26:\"2014-01-01 00:00:00.000000\";s:24:\"course_tab_enabled_about\";b:1;s:32:\"course_tab_enabled_about_student\";b:1;s:28:\"course_tab_enabled_about_t_a\";b:1;s:30:\"course_tab_enabled_assignments\";b:1;s:38:\"course_tab_enabled_assignments_student\";b:1;s:34:\"course_tab_enabled_assignments_t_a\";b:1;s:28:\"course_tab_enabled_documents\";b:1;s:36:\"course_tab_enabled_documents_student\";b:1;s:32:\"course_tab_enabled_documents_t_a\";b:1;s:25:\"course_tab_enabled_grades\";b:1;s:33:\"course_tab_enabled_grades_student\";b:1;s:29:\"course_tab_enabled_grades_t_a\";b:0;s:25:\"course_tab_enabled_roster\";b:1;s:33:\"course_tab_enabled_roster_student\";b:1;s:29:\"course_tab_enabled_roster_t_a\";b:1;s:21:\"course_tab_name_about\";s:5:\"About\";s:27:\"course_tab_name_assignments\";s:11:\"Assignments\";s:24:\"course_tab_name_bulletin\";s:8:\"Bulletin\";s:25:\"course_tab_name_documents\";s:9:\"Documents\";s:22:\"course_tab_name_grades\";s:6:\"Grades\";s:22:\"course_tab_name_roster\";s:6:\"Roster\";s:11:\"description\";N;s:29:\"download_restrict_assessments\";N;s:29:\"download_restrict_assignments\";N;s:26:\"download_restrict_bulletin\";N;s:27:\"download_restrict_documents\";N;s:28:\"download_restrict_extensions\";N;s:29:\"download_restrict_submissions\";N;s:28:\"enable_letter_grade_override\";b:0;s:35:\"enable_student_average_grade_letter\";b:1;s:43:\"enable_student_average_grade_letter_student\";b:1;s:39:\"enable_student_average_grade_letter_t_a\";b:1;s:39:\"enable_student_average_grade_percentage\";b:1;s:47:\"enable_student_average_grade_percentage_student\";b:1;s:43:\"enable_student_average_grade_percentage_t_a\";b:1;s:35:\"enable_student_average_grade_points\";b:0;s:43:\"enable_student_average_grade_points_student\";b:0;s:39:\"enable_student_average_grade_points_t_a\";b:0;s:8:\"end_date\";s:26:\"2050-01-01 00:00:00.000000\";s:21:\"enrollment_close_date\";N;s:10:\"grade_base\";s:7:\"percent\";s:18:\"grade_curve_amount\";d:0;s:15:\"grade_precision\";i:1;s:18:\"grade_scale_custom\";b:0;s:19:\"grade_scale_medians\";s:14:\"30;65;75;85;95\";s:18:\"grade_scale_titles\";s:9:\"F;D;C;B;A\";s:18:\"grade_scale_values\";s:13:\"0;60;70;80;90\";s:12:\"grade_scheme\";s:5:\"round\";s:8:\"location\";N;s:4:\"name\";s:35:\"Astronomy: Exploring Time and Space\";s:6:\"number\";s:3:\"108\";s:14:\"points_enabled\";b:1;s:5:\"price\";d:0;s:15:\"profile_picture\";N;s:9:\"published\";b:0;s:7:\"subject\";s:4:\"ASTR\";s:4:\"type\";N;s:15:\"use_drop_lowest\";b:0;s:19:\"use_weighted_grades\";b:0;s:7:\"paywall\";b:0;s:9:\"permalink\";s:25:\"astronomy--exploring-time\";s:10:\"updated_at\";s:26:\"2018-08-28 00:04:20.354200\";s:10:\"created_at\";s:26:\"2018-08-28 00:04:20.354200\";s:2:\"id\";i:3;}',NULL,'https://demo.notebowl.xyz/gateway/services/dashboard/newCourse','POST','a:5:{s:4:\"name\";s:35:\"Astronomy: Exploring Time and Space\";s:7:\"subject\";s:4:\"ASTR\";s:6:\"number\";s:3:\"108\";s:5:\"_term\";s:73:\"https://demo.notebowl.xyz/api/v1.0/terms/JwQlgcfCVRWjDkPiwonbMgGPIaF5WJ1S\";s:6:\"method\";s:5:\"reset\";}'),
	(2,1,'updated',1,3,'App\\Models\\Course','yb85e7ef954fc4e27bbff4813f89d99f','2018-08-28 00:04:39.025500','2018-08-28 00:04:39.025500',NULL,'a:72:{s:2:\"id\";i:3;s:13:\"university_id\";i:1;s:7:\"term_id\";i:1;s:4:\"name\";s:35:\"Astronomy: Exploring Time and Space\";s:7:\"subject\";s:4:\"ASTR\";s:6:\"number\";s:3:\"108\";s:9:\"permalink\";s:25:\"astronomy--exploring-time\";s:14:\"available_date\";s:26:\"2014-01-01 00:00:00.000000\";s:8:\"end_date\";s:26:\"2050-01-01 00:00:00.000000\";s:21:\"enrollment_close_date\";N;s:12:\"archive_date\";N;s:5:\"units\";d:0;s:19:\"use_weighted_grades\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:04:20.354200\";s:10:\"updated_at\";s:26:\"2018-08-28 00:04:20.354200\";s:12:\"resource_key\";s:32:\"lc70cff6d40844d52b9927fa9a406a13\";s:10:\"deleted_at\";N;s:15:\"use_drop_lowest\";b:0;s:4:\"type\";N;s:8:\"location\";N;s:11:\"description\";N;s:15:\"invite_group_id\";N;s:5:\"price\";d:0;s:29:\"download_restrict_assessments\";N;s:29:\"download_restrict_assignments\";N;s:26:\"download_restrict_bulletin\";N;s:27:\"download_restrict_documents\";N;s:29:\"download_restrict_submissions\";N;s:28:\"download_restrict_extensions\";N;s:24:\"course_tab_enabled_about\";b:1;s:28:\"course_tab_enabled_about_t_a\";b:1;s:32:\"course_tab_enabled_about_student\";b:1;s:30:\"course_tab_enabled_assignments\";b:1;s:34:\"course_tab_enabled_assignments_t_a\";b:1;s:38:\"course_tab_enabled_assignments_student\";b:1;s:28:\"course_tab_enabled_documents\";b:1;s:32:\"course_tab_enabled_documents_t_a\";b:1;s:36:\"course_tab_enabled_documents_student\";b:1;s:25:\"course_tab_enabled_grades\";b:1;s:29:\"course_tab_enabled_grades_t_a\";b:0;s:33:\"course_tab_enabled_grades_student\";b:1;s:25:\"course_tab_enabled_roster\";b:1;s:29:\"course_tab_enabled_roster_t_a\";b:1;s:33:\"course_tab_enabled_roster_student\";b:1;s:21:\"course_tab_name_about\";s:5:\"About\";s:27:\"course_tab_name_assignments\";s:11:\"Assignments\";s:25:\"course_tab_name_documents\";s:9:\"Documents\";s:22:\"course_tab_name_grades\";s:6:\"Grades\";s:22:\"course_tab_name_roster\";s:6:\"Roster\";s:24:\"course_tab_name_bulletin\";s:8:\"Bulletin\";s:14:\"points_enabled\";b:1;s:35:\"enable_student_average_grade_letter\";b:1;s:39:\"enable_student_average_grade_letter_t_a\";b:1;s:43:\"enable_student_average_grade_letter_student\";b:1;s:39:\"enable_student_average_grade_percentage\";b:1;s:43:\"enable_student_average_grade_percentage_t_a\";b:1;s:47:\"enable_student_average_grade_percentage_student\";b:1;s:35:\"enable_student_average_grade_points\";b:0;s:39:\"enable_student_average_grade_points_t_a\";b:0;s:43:\"enable_student_average_grade_points_student\";b:0;s:28:\"enable_letter_grade_override\";b:0;s:18:\"grade_scale_custom\";b:0;s:12:\"grade_scheme\";s:5:\"round\";s:10:\"grade_base\";s:7:\"percent\";s:15:\"grade_precision\";i:1;s:18:\"grade_curve_amount\";d:0;s:19:\"grade_scale_medians\";s:14:\"30;65;75;85;95\";s:18:\"grade_scale_titles\";s:9:\"F;D;C;B;A\";s:18:\"grade_scale_values\";s:13:\"0;60;70;80;90\";s:7:\"paywall\";b:0;s:9:\"published\";b:0;s:15:\"profile_picture\";N;}','a:72:{s:2:\"id\";i:3;s:13:\"university_id\";i:1;s:7:\"term_id\";i:1;s:4:\"name\";s:35:\"Astronomy: Exploring Time and Space\";s:7:\"subject\";s:4:\"ASTR\";s:6:\"number\";s:3:\"108\";s:9:\"permalink\";s:25:\"astronomy--exploring-time\";s:14:\"available_date\";s:26:\"2014-01-01 00:00:00.000000\";s:8:\"end_date\";s:26:\"2050-01-01 00:00:00.000000\";s:21:\"enrollment_close_date\";N;s:12:\"archive_date\";N;s:5:\"units\";d:3;s:19:\"use_weighted_grades\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:04:20.354200\";s:10:\"updated_at\";s:26:\"2018-08-28 00:04:38.996800\";s:12:\"resource_key\";s:32:\"lc70cff6d40844d52b9927fa9a406a13\";s:10:\"deleted_at\";N;s:15:\"use_drop_lowest\";b:0;s:4:\"type\";N;s:8:\"location\";s:9:\"Suite 200\";s:11:\"description\";s:268:\"This course is designed for anyone who is interested in learning more about modern astronomy. We will help you get up to date on the most recent astronomical discoveries while also providing support at an introductory level for those who have no background in science.\";s:15:\"invite_group_id\";N;s:5:\"price\";d:0;s:29:\"download_restrict_assessments\";N;s:29:\"download_restrict_assignments\";N;s:26:\"download_restrict_bulletin\";N;s:27:\"download_restrict_documents\";N;s:29:\"download_restrict_submissions\";N;s:28:\"download_restrict_extensions\";N;s:24:\"course_tab_enabled_about\";b:1;s:28:\"course_tab_enabled_about_t_a\";b:1;s:32:\"course_tab_enabled_about_student\";b:1;s:30:\"course_tab_enabled_assignments\";b:1;s:34:\"course_tab_enabled_assignments_t_a\";b:1;s:38:\"course_tab_enabled_assignments_student\";b:1;s:28:\"course_tab_enabled_documents\";b:1;s:32:\"course_tab_enabled_documents_t_a\";b:1;s:36:\"course_tab_enabled_documents_student\";b:1;s:25:\"course_tab_enabled_grades\";b:1;s:29:\"course_tab_enabled_grades_t_a\";b:0;s:33:\"course_tab_enabled_grades_student\";b:1;s:25:\"course_tab_enabled_roster\";b:1;s:29:\"course_tab_enabled_roster_t_a\";b:1;s:33:\"course_tab_enabled_roster_student\";b:1;s:21:\"course_tab_name_about\";s:5:\"About\";s:27:\"course_tab_name_assignments\";s:11:\"Assignments\";s:25:\"course_tab_name_documents\";s:9:\"Documents\";s:22:\"course_tab_name_grades\";s:6:\"Grades\";s:22:\"course_tab_name_roster\";s:6:\"Roster\";s:24:\"course_tab_name_bulletin\";s:8:\"Bulletin\";s:14:\"points_enabled\";b:1;s:35:\"enable_student_average_grade_letter\";b:1;s:39:\"enable_student_average_grade_letter_t_a\";b:1;s:43:\"enable_student_average_grade_letter_student\";b:1;s:39:\"enable_student_average_grade_percentage\";b:1;s:43:\"enable_student_average_grade_percentage_t_a\";b:1;s:47:\"enable_student_average_grade_percentage_student\";b:1;s:35:\"enable_student_average_grade_points\";b:0;s:39:\"enable_student_average_grade_points_t_a\";b:0;s:43:\"enable_student_average_grade_points_student\";b:0;s:28:\"enable_letter_grade_override\";b:0;s:18:\"grade_scale_custom\";b:0;s:12:\"grade_scheme\";s:5:\"round\";s:10:\"grade_base\";s:7:\"percent\";s:15:\"grade_precision\";i:1;s:18:\"grade_curve_amount\";d:0;s:19:\"grade_scale_medians\";s:14:\"30;65;75;85;95\";s:18:\"grade_scale_titles\";s:9:\"F;D;C;B;A\";s:18:\"grade_scale_values\";s:13:\"0;60;70;80;90\";s:7:\"paywall\";b:0;s:9:\"published\";b:0;s:15:\"profile_picture\";N;}',NULL,'https://demo.notebowl.xyz/gateway/services/dashboard/course/lc70cff6d40844d52b9927fa9a406a13','POST','a:11:{s:4:\"name\";s:35:\"Astronomy: Exploring Time and Space\";s:7:\"subject\";s:4:\"ASTR\";s:6:\"number\";s:3:\"108\";s:5:\"_term\";s:73:\"https://demo.notebowl.xyz/api/v1.0/terms/JwQlgcfCVRWjDkPiwonbMgGPIaF5WJ1S\";s:11:\"description\";s:268:\"This course is designed for anyone who is interested in learning more about modern astronomy. We will help you get up to date on the most recent astronomical discoveries while also providing support at an introductory level for those who have no background in science.\";s:5:\"price\";s:1:\"0\";s:5:\"units\";s:1:\"3\";s:8:\"location\";s:9:\"Suite 200\";s:10:\"inviteCode\";s:0:\"\";s:13:\"availableDate\";s:10:\"01/01/2014\";s:15:\"enrollmentClose\";s:0:\"\";}'),
	(3,1,'created',1,1,'App\\Models\\Attachment','ud79e9fdc315846ffa1ba61d59332c78','2018-08-28 00:05:20.812300','2018-08-28 00:05:20.812300',NULL,'a:2:{s:17:\"attachment_scheme\";s:4:\"Book\";s:8:\"location\";s:13:\"9780077345099\";}','a:13:{s:17:\"attachment_scheme\";s:4:\"Book\";s:8:\"location\";s:13:\"9780077345099\";s:9:\"parent_id\";i:3;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:12:\"resource_key\";s:32:\"vfc60395a035d41069bf6f8263557350\";s:14:\"available_date\";s:26:\"2018-08-28 00:05:15.806200\";s:11:\"view_scheme\";N;s:8:\"owner_id\";i:1;s:15:\"attachment_name\";s:39:\"Explorations: Introduction to Astronomy\";s:6:\"status\";s:9:\"completed\";s:10:\"updated_at\";s:26:\"2018-08-28 00:05:20.787900\";s:10:\"created_at\";s:26:\"2018-08-28 00:05:20.787900\";s:2:\"id\";i:1;}',NULL,'https://demo.notebowl.xyz/gateway/services/dashboard/addCourseBook/lc70cff6d40844d52b9927fa9a406a13','POST','a:3:{s:4:\"isbn\";s:13:\"9780077345099\";s:10:\"isRequired\";s:2:\"on\";s:15:\"recommendAmazon\";s:2:\"on\";}'),
	(4,1,'created',1,26,'App\\Models\\Enrollment','tef1169d0201a43b5828a6fd1ae337eb','2018-08-28 00:05:35.155700','2018-08-28 00:05:35.155700',NULL,'a:0:{}','a:10:{s:9:\"parent_id\";i:3;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:7:\"user_id\";i:3;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:6:\"origin\";s:6:\"native\";s:12:\"resource_key\";s:32:\"v10654dbd44574da4a7fc36cbda7f976\";s:10:\"updated_at\";s:26:\"2018-08-28 00:05:35.134800\";s:10:\"created_at\";s:26:\"2018-08-28 00:05:35.134800\";s:2:\"id\";i:26;}',NULL,'https://demo.notebowl.xyz/gateway/services/dashboard/addUserEnrollment/d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ?course=lc70cff6d40844d52b9927fa9a406a13&returnUrl=https%3A%2F%2Fdemo.notebowl.xyz%2Fgateway%2Fservices%2Fdashboard%2Fcourse%2Flc70cff6d40844d52b9927fa9a406a13','POST','a:5:{s:4:\"term\";s:32:\"JwQlgcfCVRWjDkPiwonbMgGPIaF5WJ1S\";s:6:\"course\";s:32:\"lc70cff6d40844d52b9927fa9a406a13\";s:4:\"role\";s:9:\"Professor\";s:9:\"addCourse\";s:10:\"Add Course\";s:9:\"returnUrl\";s:92:\"https://demo.notebowl.xyz/gateway/services/dashboard/course/lc70cff6d40844d52b9927fa9a406a13\";}'),
	(5,1,'created',1,27,'App\\Models\\Enrollment','xe1cb0488af5049d4a1a54584a5155fe','2018-08-28 00:06:01.523100','2018-08-28 00:06:01.523100',NULL,'a:0:{}','a:10:{s:9:\"parent_id\";i:3;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:7:\"user_id\";i:1;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:6:\"origin\";s:6:\"native\";s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:2:\"id\";i:27;}',NULL,'https://demo.notebowl.xyz/gateway/services/dashboard/addUserEnrollment/U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi?course=lc70cff6d40844d52b9927fa9a406a13&returnUrl=https%3A%2F%2Fdemo.notebowl.xyz%2Fgateway%2Fservices%2Fdashboard%2Fcourse%2Flc70cff6d40844d52b9927fa9a406a13','POST','a:5:{s:4:\"term\";s:32:\"JwQlgcfCVRWjDkPiwonbMgGPIaF5WJ1S\";s:6:\"course\";s:32:\"lc70cff6d40844d52b9927fa9a406a13\";s:4:\"role\";s:9:\"Professor\";s:9:\"addCourse\";s:10:\"Add Course\";s:9:\"returnUrl\";s:92:\"https://demo.notebowl.xyz/gateway/services/dashboard/course/lc70cff6d40844d52b9927fa9a406a13\";}'),
	(6,1,'updated',2,27,'App\\Models\\Enrollment','b068a4026376c4f6abcb297359a642f0','2018-08-28 00:06:31.743900','2018-08-28 00:06:31.743900',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";N;}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:31.735400\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:06:31.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/begin','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:71:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/begin\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786281\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(7,1,'updated',2,27,'App\\Models\\Enrollment','r414babffe4a44d32a5efe03a312851f','2018-08-28 00:06:32.926700','2018-08-28 00:06:32.926700',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:31.735400\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:06:31.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:32.920000\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:06:32.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/glance','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:72:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/glance\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786284\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(8,1,'updated',2,27,'App\\Models\\Enrollment','ad89ae2d8c1a648de9b62bd04dd8ebce','2018-08-28 00:06:36.754400','2018-08-28 00:06:36.754400',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:32.920000\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:06:32.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:36.748000\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:06:36.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/import','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:72:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/import\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786286\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(9,1,'updated',2,27,'App\\Models\\Enrollment','a5052822c08a94fa28adea64eee287f9','2018-08-28 00:06:40.403800','2018-08-28 00:06:40.403800',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:36.748000\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:06:36.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:40.396700\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:06:40.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/display','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:73:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/display\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786287\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(10,1,'updated',2,27,'App\\Models\\Enrollment','a0c318b4a86314fe3841d35eb42468c2','2018-08-28 00:06:42.133900','2018-08-28 00:06:42.133900',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:40.396700\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:06:40.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:42.125900\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:06:42.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/scale','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:71:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/scale\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786288\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(11,1,'updated',2,27,'App\\Models\\Enrollment','f1c094a4baaf6452cbb2dc31f0078981','2018-08-28 00:06:43.255699','2018-08-28 00:06:43.255699',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:42.125900\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:06:42.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:43.249600\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:06:43.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/books','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:71:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/books\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786289\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(12,1,'updated',2,27,'App\\Models\\Enrollment','tc753476d25ab4c5bb78244715f5520b','2018-08-28 00:06:44.364900','2018-08-28 00:06:44.364900',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:43.249600\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:06:43.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:44.358000\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:06:44.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/final','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:71:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/final\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786290\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(13,1,'updated',2,3,'App\\Models\\Course','b0bccf3435d1746028c006991f267955','2018-08-28 00:06:45.331000','2018-08-28 00:06:45.331000',NULL,'a:72:{s:2:\"id\";i:3;s:13:\"university_id\";i:1;s:7:\"term_id\";i:1;s:4:\"name\";s:35:\"Astronomy: Exploring Time and Space\";s:7:\"subject\";s:4:\"ASTR\";s:6:\"number\";s:3:\"108\";s:9:\"permalink\";s:25:\"astronomy--exploring-time\";s:14:\"available_date\";s:26:\"2014-01-01 00:00:00.000000\";s:8:\"end_date\";s:26:\"2050-01-01 00:00:00.000000\";s:21:\"enrollment_close_date\";N;s:12:\"archive_date\";N;s:5:\"units\";d:3;s:19:\"use_weighted_grades\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:04:20.354200\";s:10:\"updated_at\";s:26:\"2018-08-28 00:04:38.996800\";s:12:\"resource_key\";s:32:\"lc70cff6d40844d52b9927fa9a406a13\";s:10:\"deleted_at\";N;s:15:\"use_drop_lowest\";b:0;s:4:\"type\";N;s:8:\"location\";s:9:\"Suite 200\";s:11:\"description\";s:268:\"This course is designed for anyone who is interested in learning more about modern astronomy. We will help you get up to date on the most recent astronomical discoveries while also providing support at an introductory level for those who have no background in science.\";s:15:\"invite_group_id\";N;s:5:\"price\";d:0;s:29:\"download_restrict_assessments\";N;s:29:\"download_restrict_assignments\";N;s:26:\"download_restrict_bulletin\";N;s:27:\"download_restrict_documents\";N;s:29:\"download_restrict_submissions\";N;s:28:\"download_restrict_extensions\";N;s:24:\"course_tab_enabled_about\";b:1;s:28:\"course_tab_enabled_about_t_a\";b:1;s:32:\"course_tab_enabled_about_student\";b:1;s:30:\"course_tab_enabled_assignments\";b:1;s:34:\"course_tab_enabled_assignments_t_a\";b:1;s:38:\"course_tab_enabled_assignments_student\";b:1;s:28:\"course_tab_enabled_documents\";b:1;s:32:\"course_tab_enabled_documents_t_a\";b:1;s:36:\"course_tab_enabled_documents_student\";b:1;s:25:\"course_tab_enabled_grades\";b:1;s:29:\"course_tab_enabled_grades_t_a\";b:0;s:33:\"course_tab_enabled_grades_student\";b:1;s:25:\"course_tab_enabled_roster\";b:1;s:29:\"course_tab_enabled_roster_t_a\";b:1;s:33:\"course_tab_enabled_roster_student\";b:1;s:21:\"course_tab_name_about\";s:5:\"About\";s:27:\"course_tab_name_assignments\";s:11:\"Assignments\";s:25:\"course_tab_name_documents\";s:9:\"Documents\";s:22:\"course_tab_name_grades\";s:6:\"Grades\";s:22:\"course_tab_name_roster\";s:6:\"Roster\";s:24:\"course_tab_name_bulletin\";s:8:\"Bulletin\";s:14:\"points_enabled\";b:1;s:35:\"enable_student_average_grade_letter\";b:1;s:39:\"enable_student_average_grade_letter_t_a\";b:1;s:43:\"enable_student_average_grade_letter_student\";b:1;s:39:\"enable_student_average_grade_percentage\";b:1;s:43:\"enable_student_average_grade_percentage_t_a\";b:1;s:47:\"enable_student_average_grade_percentage_student\";b:1;s:35:\"enable_student_average_grade_points\";b:0;s:39:\"enable_student_average_grade_points_t_a\";b:0;s:43:\"enable_student_average_grade_points_student\";b:0;s:28:\"enable_letter_grade_override\";b:0;s:18:\"grade_scale_custom\";b:0;s:12:\"grade_scheme\";s:5:\"round\";s:10:\"grade_base\";s:7:\"percent\";s:15:\"grade_precision\";i:1;s:18:\"grade_curve_amount\";d:0;s:19:\"grade_scale_medians\";s:14:\"30;65;75;85;95\";s:18:\"grade_scale_titles\";s:9:\"F;D;C;B;A\";s:18:\"grade_scale_values\";s:13:\"0;60;70;80;90\";s:7:\"paywall\";b:0;s:9:\"published\";b:0;s:15:\"profile_picture\";N;}','a:72:{s:2:\"id\";i:3;s:13:\"university_id\";i:1;s:7:\"term_id\";i:1;s:4:\"name\";s:35:\"Astronomy: Exploring Time and Space\";s:7:\"subject\";s:4:\"ASTR\";s:6:\"number\";s:3:\"108\";s:9:\"permalink\";s:25:\"astronomy--exploring-time\";s:14:\"available_date\";s:26:\"2014-01-01 00:00:00.000000\";s:8:\"end_date\";s:26:\"2050-01-01 00:00:00.000000\";s:21:\"enrollment_close_date\";N;s:12:\"archive_date\";N;s:5:\"units\";d:3;s:19:\"use_weighted_grades\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:04:20.354200\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:45.308500\";s:12:\"resource_key\";s:32:\"lc70cff6d40844d52b9927fa9a406a13\";s:10:\"deleted_at\";N;s:15:\"use_drop_lowest\";b:0;s:4:\"type\";N;s:8:\"location\";s:9:\"Suite 200\";s:11:\"description\";s:268:\"This course is designed for anyone who is interested in learning more about modern astronomy. We will help you get up to date on the most recent astronomical discoveries while also providing support at an introductory level for those who have no background in science.\";s:15:\"invite_group_id\";N;s:5:\"price\";d:0;s:29:\"download_restrict_assessments\";N;s:29:\"download_restrict_assignments\";N;s:26:\"download_restrict_bulletin\";N;s:27:\"download_restrict_documents\";N;s:29:\"download_restrict_submissions\";N;s:28:\"download_restrict_extensions\";N;s:24:\"course_tab_enabled_about\";b:1;s:28:\"course_tab_enabled_about_t_a\";b:1;s:32:\"course_tab_enabled_about_student\";b:1;s:30:\"course_tab_enabled_assignments\";b:1;s:34:\"course_tab_enabled_assignments_t_a\";b:1;s:38:\"course_tab_enabled_assignments_student\";b:1;s:28:\"course_tab_enabled_documents\";b:1;s:32:\"course_tab_enabled_documents_t_a\";b:1;s:36:\"course_tab_enabled_documents_student\";b:1;s:25:\"course_tab_enabled_grades\";b:1;s:29:\"course_tab_enabled_grades_t_a\";b:0;s:33:\"course_tab_enabled_grades_student\";b:1;s:25:\"course_tab_enabled_roster\";b:1;s:29:\"course_tab_enabled_roster_t_a\";b:1;s:33:\"course_tab_enabled_roster_student\";b:1;s:21:\"course_tab_name_about\";s:5:\"About\";s:27:\"course_tab_name_assignments\";s:11:\"Assignments\";s:25:\"course_tab_name_documents\";s:9:\"Documents\";s:22:\"course_tab_name_grades\";s:6:\"Grades\";s:22:\"course_tab_name_roster\";s:6:\"Roster\";s:24:\"course_tab_name_bulletin\";s:8:\"Bulletin\";s:14:\"points_enabled\";b:1;s:35:\"enable_student_average_grade_letter\";b:1;s:39:\"enable_student_average_grade_letter_t_a\";b:1;s:43:\"enable_student_average_grade_letter_student\";b:1;s:39:\"enable_student_average_grade_percentage\";b:1;s:43:\"enable_student_average_grade_percentage_t_a\";b:1;s:47:\"enable_student_average_grade_percentage_student\";b:1;s:35:\"enable_student_average_grade_points\";b:0;s:39:\"enable_student_average_grade_points_t_a\";b:0;s:43:\"enable_student_average_grade_points_student\";b:0;s:28:\"enable_letter_grade_override\";b:0;s:18:\"grade_scale_custom\";b:0;s:12:\"grade_scheme\";s:5:\"round\";s:10:\"grade_base\";s:7:\"percent\";s:15:\"grade_precision\";i:1;s:18:\"grade_curve_amount\";d:0;s:19:\"grade_scale_medians\";s:14:\"30;65;75;85;95\";s:18:\"grade_scale_titles\";s:9:\"F;D;C;B;A\";s:18:\"grade_scale_values\";s:13:\"0;60;70;80;90\";s:7:\"paywall\";b:0;s:9:\"published\";b:1;s:15:\"profile_picture\";N;}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/final','PUT','a:4:{s:9:\"published\";b:1;s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786291\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(14,1,'updated',2,27,'App\\Models\\Enrollment','xcb32b4dc43f7446dbb139eea5616f70','2018-08-28 00:06:45.972700','2018-08-28 00:06:45.972700',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:44.358000\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:06:44.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:45.954900\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:06:45.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/bulletin','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:68:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/bulletin\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786292\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(15,1,'updated',2,27,'App\\Models\\Enrollment','z39ddd092d47d4e719f1c5ffdeda0f51','2018-08-28 00:06:49.260799','2018-08-28 00:06:49.260799',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:45.954900\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:06:45.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:49.255199\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:06:49.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/roster','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:66:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/roster\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786296\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(16,1,'updated',2,27,'App\\Models\\Enrollment','r0c284bcf7e7843748dbc63b3d47ff91','2018-08-28 00:07:42.622700','2018-08-28 00:07:42.622700',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:49.255199\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:06:49.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:07:42.616400\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:07:42.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/about','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:65:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/about\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786297\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(17,1,'updated',2,27,'App\\Models\\Enrollment','z739c8a1b43b146cd90530e7d2b85cd7','2018-08-28 00:07:47.186600','2018-08-28 00:07:47.186600',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:07:42.616400\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:07:42.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:07:47.177600\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:07:47.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/bulletin','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:68:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/bulletin\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786298\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(18,1,'updated',2,3,'App\\Models\\Course','pb49af79ac5ab4bdcb1010c1268cf07c','2018-08-28 00:13:24.778300','2018-08-28 00:13:24.778300',NULL,'a:72:{s:2:\"id\";i:3;s:13:\"university_id\";i:1;s:7:\"term_id\";i:1;s:4:\"name\";s:35:\"Astronomy: Exploring Time and Space\";s:7:\"subject\";s:4:\"ASTR\";s:6:\"number\";s:3:\"108\";s:9:\"permalink\";s:25:\"astronomy--exploring-time\";s:14:\"available_date\";s:26:\"2014-01-01 00:00:00.000000\";s:8:\"end_date\";s:26:\"2050-01-01 00:00:00.000000\";s:21:\"enrollment_close_date\";N;s:12:\"archive_date\";N;s:5:\"units\";d:3;s:19:\"use_weighted_grades\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:04:20.354200\";s:10:\"updated_at\";s:26:\"2018-08-28 00:06:45.308500\";s:12:\"resource_key\";s:32:\"lc70cff6d40844d52b9927fa9a406a13\";s:10:\"deleted_at\";N;s:15:\"use_drop_lowest\";b:0;s:4:\"type\";N;s:8:\"location\";s:9:\"Suite 200\";s:11:\"description\";s:268:\"This course is designed for anyone who is interested in learning more about modern astronomy. We will help you get up to date on the most recent astronomical discoveries while also providing support at an introductory level for those who have no background in science.\";s:15:\"invite_group_id\";N;s:5:\"price\";d:0;s:29:\"download_restrict_assessments\";N;s:29:\"download_restrict_assignments\";N;s:26:\"download_restrict_bulletin\";N;s:27:\"download_restrict_documents\";N;s:29:\"download_restrict_submissions\";N;s:28:\"download_restrict_extensions\";N;s:24:\"course_tab_enabled_about\";b:1;s:28:\"course_tab_enabled_about_t_a\";b:1;s:32:\"course_tab_enabled_about_student\";b:1;s:30:\"course_tab_enabled_assignments\";b:1;s:34:\"course_tab_enabled_assignments_t_a\";b:1;s:38:\"course_tab_enabled_assignments_student\";b:1;s:28:\"course_tab_enabled_documents\";b:1;s:32:\"course_tab_enabled_documents_t_a\";b:1;s:36:\"course_tab_enabled_documents_student\";b:1;s:25:\"course_tab_enabled_grades\";b:1;s:29:\"course_tab_enabled_grades_t_a\";b:0;s:33:\"course_tab_enabled_grades_student\";b:1;s:25:\"course_tab_enabled_roster\";b:1;s:29:\"course_tab_enabled_roster_t_a\";b:1;s:33:\"course_tab_enabled_roster_student\";b:1;s:21:\"course_tab_name_about\";s:5:\"About\";s:27:\"course_tab_name_assignments\";s:11:\"Assignments\";s:25:\"course_tab_name_documents\";s:9:\"Documents\";s:22:\"course_tab_name_grades\";s:6:\"Grades\";s:22:\"course_tab_name_roster\";s:6:\"Roster\";s:24:\"course_tab_name_bulletin\";s:8:\"Bulletin\";s:14:\"points_enabled\";b:1;s:35:\"enable_student_average_grade_letter\";b:1;s:39:\"enable_student_average_grade_letter_t_a\";b:1;s:43:\"enable_student_average_grade_letter_student\";b:1;s:39:\"enable_student_average_grade_percentage\";b:1;s:43:\"enable_student_average_grade_percentage_t_a\";b:1;s:47:\"enable_student_average_grade_percentage_student\";b:1;s:35:\"enable_student_average_grade_points\";b:0;s:39:\"enable_student_average_grade_points_t_a\";b:0;s:43:\"enable_student_average_grade_points_student\";b:0;s:28:\"enable_letter_grade_override\";b:0;s:18:\"grade_scale_custom\";b:0;s:12:\"grade_scheme\";s:5:\"round\";s:10:\"grade_base\";s:7:\"percent\";s:15:\"grade_precision\";i:1;s:18:\"grade_curve_amount\";d:0;s:19:\"grade_scale_medians\";s:14:\"30;65;75;85;95\";s:18:\"grade_scale_titles\";s:9:\"F;D;C;B;A\";s:18:\"grade_scale_values\";s:13:\"0;60;70;80;90\";s:7:\"paywall\";b:0;s:9:\"published\";b:1;s:15:\"profile_picture\";N;}','a:72:{s:2:\"id\";i:3;s:13:\"university_id\";i:1;s:7:\"term_id\";i:1;s:4:\"name\";s:35:\"Astronomy: Exploring Time and Space\";s:7:\"subject\";s:4:\"ASTR\";s:6:\"number\";s:3:\"108\";s:9:\"permalink\";s:25:\"astronomy--exploring-time\";s:14:\"available_date\";s:26:\"2014-01-01 00:00:00.000000\";s:8:\"end_date\";s:26:\"2050-01-01 00:00:00.000000\";s:21:\"enrollment_close_date\";N;s:12:\"archive_date\";N;s:5:\"units\";d:3;s:19:\"use_weighted_grades\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:04:20.354200\";s:10:\"updated_at\";s:26:\"2018-08-28 00:13:24.738000\";s:12:\"resource_key\";s:32:\"lc70cff6d40844d52b9927fa9a406a13\";s:10:\"deleted_at\";N;s:15:\"use_drop_lowest\";b:0;s:4:\"type\";N;s:8:\"location\";s:9:\"Suite 200\";s:11:\"description\";s:268:\"This course is designed for anyone who is interested in learning more about modern astronomy. We will help you get up to date on the most recent astronomical discoveries while also providing support at an introductory level for those who have no background in science.\";s:15:\"invite_group_id\";N;s:5:\"price\";d:0;s:29:\"download_restrict_assessments\";N;s:29:\"download_restrict_assignments\";N;s:26:\"download_restrict_bulletin\";N;s:27:\"download_restrict_documents\";N;s:29:\"download_restrict_submissions\";N;s:28:\"download_restrict_extensions\";N;s:24:\"course_tab_enabled_about\";b:1;s:28:\"course_tab_enabled_about_t_a\";b:1;s:32:\"course_tab_enabled_about_student\";b:1;s:30:\"course_tab_enabled_assignments\";b:1;s:34:\"course_tab_enabled_assignments_t_a\";b:1;s:38:\"course_tab_enabled_assignments_student\";b:1;s:28:\"course_tab_enabled_documents\";b:1;s:32:\"course_tab_enabled_documents_t_a\";b:1;s:36:\"course_tab_enabled_documents_student\";b:1;s:25:\"course_tab_enabled_grades\";b:1;s:29:\"course_tab_enabled_grades_t_a\";b:0;s:33:\"course_tab_enabled_grades_student\";b:1;s:25:\"course_tab_enabled_roster\";b:1;s:29:\"course_tab_enabled_roster_t_a\";b:1;s:33:\"course_tab_enabled_roster_student\";b:1;s:21:\"course_tab_name_about\";s:5:\"About\";s:27:\"course_tab_name_assignments\";s:11:\"Assignments\";s:25:\"course_tab_name_documents\";s:9:\"Documents\";s:22:\"course_tab_name_grades\";s:6:\"Grades\";s:22:\"course_tab_name_roster\";s:6:\"Roster\";s:24:\"course_tab_name_bulletin\";s:8:\"Bulletin\";s:14:\"points_enabled\";b:1;s:35:\"enable_student_average_grade_letter\";b:1;s:39:\"enable_student_average_grade_letter_t_a\";b:1;s:43:\"enable_student_average_grade_letter_student\";b:1;s:39:\"enable_student_average_grade_percentage\";b:1;s:43:\"enable_student_average_grade_percentage_t_a\";b:1;s:47:\"enable_student_average_grade_percentage_student\";b:1;s:35:\"enable_student_average_grade_points\";b:0;s:39:\"enable_student_average_grade_points_t_a\";b:0;s:43:\"enable_student_average_grade_points_student\";b:0;s:28:\"enable_letter_grade_override\";b:0;s:18:\"grade_scale_custom\";b:0;s:12:\"grade_scheme\";s:5:\"round\";s:10:\"grade_base\";s:7:\"percent\";s:15:\"grade_precision\";i:1;s:18:\"grade_curve_amount\";d:0;s:19:\"grade_scale_medians\";s:14:\"30;65;75;85;95\";s:18:\"grade_scale_titles\";s:9:\"F;D;C;B;A\";s:18:\"grade_scale_values\";s:13:\"0;60;70;80;90\";s:7:\"paywall\";b:0;s:9:\"published\";b:1;s:15:\"profile_picture\";s:123:\"https://notebowl.s3.amazonaws.com/courses/lc70cff6d40844d52b9927fa9a406a13/profile-picture/IXXZpb4j9Va4pgvjb0cg7XbrQXwFyFe7\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/bulletin','POST','a:3:{s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786299\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(19,1,'updated',2,27,'App\\Models\\Enrollment','z84eadb93772c40febd46407f02c29cd','2018-08-28 00:13:50.282600','2018-08-28 00:13:50.282600',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:07:47.177600\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:07:47.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:13:50.275600\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:13:50.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/roster','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:66:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/roster\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786300\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(20,1,'created',2,28,'App\\Models\\Enrollment','y5e8bbef6140a415b9eff2a77fbf4274','2018-08-28 00:14:03.004200','2018-08-28 00:14:03.004200',NULL,'a:0:{}','a:11:{s:12:\"resource_key\";s:32:\"k4ee0d0024c6f408fbebb772b4ebf9b5\";s:9:\"parent_id\";i:3;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:7:\"user_id\";i:10;s:4:\"role\";s:7:\"Student\";s:6:\"status\";s:8:\"Accepted\";s:6:\"origin\";s:6:\"native\";s:16:\"payment_required\";b:1;s:10:\"updated_at\";s:26:\"2018-08-28 00:14:02.983500\";s:10:\"created_at\";s:26:\"2018-08-28 00:14:02.983500\";s:2:\"id\";i:28;}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/roster','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:4:\"role\";s:7:\"Student\";s:6:\"status\";s:8:\"Accepted\";s:5:\"_user\";s:73:\"https://demo.notebowl.xyz/api/v1.0/users/zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786303\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(21,1,'created',2,29,'App\\Models\\Enrollment','e1ab496cbab084d7488eabc6c44efed2','2018-08-28 00:14:10.962200','2018-08-28 00:14:10.962200',NULL,'a:0:{}','a:11:{s:12:\"resource_key\";s:32:\"b4f4c2a8e695f4ecca11e7aca71b0a4d\";s:9:\"parent_id\";i:3;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:7:\"user_id\";i:2;s:4:\"role\";s:7:\"Student\";s:6:\"status\";s:8:\"Accepted\";s:6:\"origin\";s:6:\"native\";s:16:\"payment_required\";b:1;s:10:\"updated_at\";s:26:\"2018-08-28 00:14:10.944200\";s:10:\"created_at\";s:26:\"2018-08-28 00:14:10.944200\";s:2:\"id\";i:29;}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/roster','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:4:\"role\";s:7:\"Student\";s:6:\"status\";s:8:\"Accepted\";s:5:\"_user\";s:73:\"https://demo.notebowl.xyz/api/v1.0/users/JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786307\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(22,1,'created',2,30,'App\\Models\\Enrollment','f2368441c4f6543b6b9e46254dc615e3','2018-08-28 00:14:32.430200','2018-08-28 00:14:32.430200',NULL,'a:0:{}','a:11:{s:12:\"resource_key\";s:32:\"g6a3da4f992d74e63bf73335a3d7f9b7\";s:9:\"parent_id\";i:3;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:7:\"user_id\";i:14;s:4:\"role\";s:7:\"Student\";s:6:\"status\";s:8:\"Accepted\";s:6:\"origin\";s:6:\"native\";s:16:\"payment_required\";b:1;s:10:\"updated_at\";s:26:\"2018-08-28 00:14:32.414800\";s:10:\"created_at\";s:26:\"2018-08-28 00:14:32.414800\";s:2:\"id\";i:30;}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/roster','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:4:\"role\";s:7:\"Student\";s:6:\"status\";s:8:\"Accepted\";s:5:\"_user\";s:73:\"https://demo.notebowl.xyz/api/v1.0/users/HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786313\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(23,1,'created',2,31,'App\\Models\\Enrollment','a38c6e777c11f477dbfec8188fa37f6f','2018-08-28 00:14:38.448400','2018-08-28 00:14:38.448400',NULL,'a:0:{}','a:11:{s:12:\"resource_key\";s:32:\"sba6718e290774e3f98feb07a51bd332\";s:9:\"parent_id\";i:3;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:7:\"user_id\";i:11;s:4:\"role\";s:7:\"Student\";s:6:\"status\";s:8:\"Accepted\";s:6:\"origin\";s:6:\"native\";s:16:\"payment_required\";b:1;s:10:\"updated_at\";s:26:\"2018-08-28 00:14:38.435400\";s:10:\"created_at\";s:26:\"2018-08-28 00:14:38.435400\";s:2:\"id\";i:31;}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/roster','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:4:\"role\";s:7:\"Student\";s:6:\"status\";s:8:\"Accepted\";s:5:\"_user\";s:73:\"https://demo.notebowl.xyz/api/v1.0/users/Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786317\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(24,1,'updated',2,27,'App\\Models\\Enrollment','g431063dbb9934b1ab634a138e8f2a6a','2018-08-28 00:14:42.598300','2018-08-28 00:14:42.598300',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:13:50.275600\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:13:50.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:14:42.590500\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:14:42.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/bulletin','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:68:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/bulletin\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786318\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(25,1,'updated',2,27,'App\\Models\\Enrollment','ocbd658f2b1c441b1b29a56fc00ede6f','2018-08-28 00:14:45.538400','2018-08-28 00:14:45.538400',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:14:42.590500\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:14:42.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:14:45.530600\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:14:45.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:71:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786319\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(26,1,'created',2,2,'App\\Models\\Assignment','c4c0c17d02bf04637abe3a8df2765698','2018-08-28 00:15:59.495500','2018-08-28 00:15:59.495500',NULL,'a:0:{}','a:30:{s:12:\"resource_key\";s:32:\"zcda01b14200644a79a16126992f807a\";s:11:\"category_id\";i:11;s:9:\"parent_id\";i:3;s:17:\"anonymous_posting\";b:0;s:14:\"available_date\";s:26:\"2018-08-28 00:15:00.000000\";s:17:\"comments_required\";s:11:\"Recommended\";s:10:\"creator_id\";i:1;s:4:\"desc\";s:183:\"Watch the video and leave ONE post on the discussion board and ONE comment for  25 points. ** Minimum of 40 words for your post and a minimum of 10 words on a comment for full credit.\";s:8:\"due_date\";s:26:\"2018-09-04 06:59:00.000000\";s:26:\"google_convert_submissions\";b:0;s:10:\"grade_only\";b:0;s:12:\"grade_scheme\";s:6:\"Points\";s:13:\"grader_scheme\";s:9:\"Professor\";s:16:\"grades_published\";b:1;s:9:\"group_max\";i:2;s:16:\"min_num_comments\";i:0;s:13:\"min_num_posts\";i:0;s:6:\"points\";i:25;s:14:\"posts_required\";s:11:\"Recommended\";s:15:\"submission_late\";b:1;s:17:\"submission_scheme\";s:16:\"Discussion Board\";s:5:\"title\";s:31:\"Space Freefall Discussion Board\";s:4:\"type\";s:10:\"Individual\";s:26:\"upload_restrict_extensions\";N;s:19:\"word_count_comments\";i:0;s:16:\"word_count_posts\";i:0;s:9:\"permalink\";s:25:\"space-freefall-discussion\";s:10:\"updated_at\";s:26:\"2018-08-28 00:15:59.479800\";s:10:\"created_at\";s:26:\"2018-08-28 00:15:59.479800\";s:2:\"id\";i:2;}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments','POST','a:20:{s:18:\"restrictExtensions\";b:0;s:13:\"availableDate\";s:24:\"2018-08-28T00:15:00.000Z\";s:7:\"dueDate\";s:24:\"2018-09-04T06:59:00.000Z\";s:12:\"graderScheme\";s:9:\"Professor\";s:9:\"_category\";s:78:\"https://demo.notebowl.xyz/api/v1.0/categories/v46402c7b431a4aea80ae220eec5263f\";s:11:\"gradeScheme\";s:6:\"Points\";s:16:\"submissionScheme\";s:16:\"Discussion Board\";s:4:\"type\";s:10:\"Individual\";s:5:\"title\";s:31:\"Space Freefall Discussion Board\";s:6:\"points\";i:25;s:11:\"description\";s:183:\"Watch the video and leave ONE post on the discussion board and ONE comment for  25 points. ** Minimum of 40 words for your post and a minimum of 10 words on a comment for full credit.\";s:13:\"postsRequired\";s:11:\"Recommended\";s:16:\"commentsRequired\";s:11:\"Recommended\";s:23:\"lateSubmissionPermitted\";b:1;s:24:\"uploadRestrictExtensions\";N;s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:9:\"gradeOnly\";b:0;s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786320\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(27,1,'updated',2,27,'App\\Models\\Enrollment','d0972755efc3d4247b03b9a9de052a47','2018-08-28 00:16:00.503800','2018-08-28 00:16:00.503800',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:14:45.530600\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:14:45.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:16:00.495000\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:16:00.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/space-freefall-discussion/submissions','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:109:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/space-freefall-discussion/submissions\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786321\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(28,1,'updated',2,27,'App\\Models\\Enrollment','bf117ed5d55ac4c9585127dc694a19cb','2018-08-28 00:16:10.304100','2018-08-28 00:16:10.304100',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:16:00.495000\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:16:00.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:16:10.297400\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:16:10.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:71:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786328\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(29,1,'created',2,3,'App\\Models\\Assignment','f59aa3919bf3a476182dacb50ac874c6','2018-08-28 00:16:46.997600','2018-08-28 00:16:46.997600',NULL,'a:0:{}','a:30:{s:12:\"resource_key\";s:32:\"h1e210e3ce3aa43a5b3fde8547648cce\";s:11:\"category_id\";i:11;s:9:\"parent_id\";i:3;s:17:\"anonymous_posting\";b:0;s:14:\"available_date\";s:26:\"2018-08-28 00:16:00.000000\";s:17:\"comments_required\";s:11:\"Recommended\";s:10:\"creator_id\";i:1;s:4:\"desc\";s:323:\"For this assignment, each of you will be writing a 4-6 page research paper outlining the US and Soviet attempts to land on the moon, detailing the roadblocks in their way and the impact that the 1969 lunar landing has had on our modern understanding of astronomy. Use at least three scholarly and two non-scholarly sources.\";s:8:\"due_date\";s:26:\"2018-09-04 06:59:00.000000\";s:26:\"google_convert_submissions\";b:0;s:10:\"grade_only\";b:0;s:12:\"grade_scheme\";s:6:\"Points\";s:13:\"grader_scheme\";s:9:\"Professor\";s:16:\"grades_published\";b:1;s:9:\"group_max\";i:2;s:16:\"min_num_comments\";i:0;s:13:\"min_num_posts\";i:0;s:6:\"points\";i:50;s:14:\"posts_required\";s:11:\"Recommended\";s:15:\"submission_late\";b:1;s:17:\"submission_scheme\";s:15:\"File Submission\";s:5:\"title\";s:24:\"Lunar Travel Topic Paper\";s:4:\"type\";s:10:\"Individual\";s:26:\"upload_restrict_extensions\";N;s:19:\"word_count_comments\";i:0;s:16:\"word_count_posts\";i:0;s:9:\"permalink\";s:24:\"lunar-travel-topic-paper\";s:10:\"updated_at\";s:26:\"2018-08-28 00:16:46.982400\";s:10:\"created_at\";s:26:\"2018-08-28 00:16:46.982400\";s:2:\"id\";i:3;}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments','POST','a:20:{s:18:\"restrictExtensions\";b:0;s:13:\"availableDate\";s:24:\"2018-08-28T00:16:00.000Z\";s:7:\"dueDate\";s:24:\"2018-09-04T06:59:00.000Z\";s:12:\"graderScheme\";s:9:\"Professor\";s:9:\"_category\";s:78:\"https://demo.notebowl.xyz/api/v1.0/categories/v46402c7b431a4aea80ae220eec5263f\";s:11:\"gradeScheme\";s:6:\"Points\";s:16:\"submissionScheme\";s:15:\"File Submission\";s:4:\"type\";s:10:\"Individual\";s:5:\"title\";s:24:\"Lunar Travel Topic Paper\";s:6:\"points\";i:50;s:11:\"description\";s:323:\"For this assignment, each of you will be writing a 4-6 page research paper outlining the US and Soviet attempts to land on the moon, detailing the roadblocks in their way and the impact that the 1969 lunar landing has had on our modern understanding of astronomy. Use at least three scholarly and two non-scholarly sources.\";s:23:\"lateSubmissionPermitted\";b:1;s:24:\"uploadRestrictExtensions\";N;s:13:\"postsRequired\";s:11:\"Recommended\";s:16:\"commentsRequired\";s:11:\"Recommended\";s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:9:\"gradeOnly\";b:0;s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786329\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(30,1,'updated',2,27,'App\\Models\\Enrollment','t23c7656adcc64d0b885aaf948085d25','2018-08-28 00:16:47.834700','2018-08-28 00:16:47.834700',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:16:10.297400\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:16:10.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:16:47.824800\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:16:47.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/lunar-travel-topic-paper/submissions/students','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:117:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/lunar-travel-topic-paper/submissions/students\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786330\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(31,1,'updated',2,27,'App\\Models\\Enrollment','g02de07eb6cf444faac9ad549226b177','2018-08-28 00:16:54.352400','2018-08-28 00:16:54.352400',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:16:47.824800\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:16:47.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:16:54.343300\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:16:54.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:71:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786336\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(32,1,'created',2,4,'App\\Models\\Assignment','wf5e94430464641cca9e5739cdcad8a4','2018-08-28 00:18:18.973300','2018-08-28 00:18:18.973300',NULL,'a:0:{}','a:30:{s:12:\"resource_key\";s:32:\"d74943de54eef49108523c16ac493e86\";s:11:\"category_id\";i:11;s:9:\"parent_id\";i:3;s:17:\"anonymous_posting\";b:0;s:14:\"available_date\";s:26:\"2018-08-28 00:16:00.000000\";s:17:\"comments_required\";s:11:\"Recommended\";s:10:\"creator_id\";i:1;s:4:\"desc\";s:535:\"The purpose of this project is to get you to take note of the apparent motion of the constellations with\nrespect to the horizon. The diurnal motion is observed by watching a constellation through one night.\nKeep in mind that the “time of day” is the position of the sun with respect to YOU.\n\nDo this on the first CLEAR NIGHT!! It can cloud up for weeks & weeks!!!\n\n** See attached handout for project details.\n** Attach a photo below for proof of your group stargazing.\n\nWe will discuss in class your experience after winter break.\";s:8:\"due_date\";s:26:\"2018-09-04 06:59:00.000000\";s:26:\"google_convert_submissions\";b:0;s:10:\"grade_only\";b:0;s:12:\"grade_scheme\";s:6:\"Points\";s:13:\"grader_scheme\";s:9:\"Professor\";s:16:\"grades_published\";b:1;s:9:\"group_max\";i:3;s:16:\"min_num_comments\";i:0;s:13:\"min_num_posts\";i:0;s:6:\"points\";i:30;s:14:\"posts_required\";s:11:\"Recommended\";s:15:\"submission_late\";b:1;s:17:\"submission_scheme\";s:15:\"File Submission\";s:5:\"title\";s:25:\"Group Overnight Starwatch\";s:4:\"type\";s:5:\"Group\";s:26:\"upload_restrict_extensions\";N;s:19:\"word_count_comments\";i:0;s:16:\"word_count_posts\";i:0;s:9:\"permalink\";s:25:\"group-overnight-starwatch\";s:10:\"updated_at\";s:26:\"2018-08-28 00:18:18.896200\";s:10:\"created_at\";s:26:\"2018-08-28 00:18:18.896200\";s:2:\"id\";i:4;}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments','POST','a:23:{s:18:\"restrictExtensions\";b:0;s:13:\"availableDate\";s:24:\"2018-08-28T00:16:00.000Z\";s:7:\"dueDate\";s:24:\"2018-09-04T06:59:00.000Z\";s:12:\"graderScheme\";s:9:\"Professor\";s:9:\"_category\";s:78:\"https://demo.notebowl.xyz/api/v1.0/categories/v46402c7b431a4aea80ae220eec5263f\";s:11:\"gradeScheme\";s:6:\"Points\";s:16:\"submissionScheme\";s:15:\"File Submission\";s:4:\"type\";s:5:\"Group\";s:5:\"title\";s:25:\"Group Overnight Starwatch\";s:6:\"points\";i:30;s:11:\"description\";s:535:\"The purpose of this project is to get you to take note of the apparent motion of the constellations with\nrespect to the horizon. The diurnal motion is observed by watching a constellation through one night.\nKeep in mind that the “time of day” is the position of the sun with respect to YOU.\n\nDo this on the first CLEAR NIGHT!! It can cloud up for weeks & weeks!!!\n\n** See attached handout for project details.\n** Attach a photo below for proof of your group stargazing.\n\nWe will discuss in class your experience after winter break.\";s:14:\"enrollmentType\";s:11:\"Self-Enroll\";s:23:\"lateSubmissionPermitted\";b:1;s:8:\"groupMax\";i:3;s:9:\"numGroups\";i:2;s:24:\"uploadRestrictExtensions\";N;s:13:\"postsRequired\";s:11:\"Recommended\";s:16:\"commentsRequired\";s:11:\"Recommended\";s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:9:\"gradeOnly\";b:0;s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786337\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(33,1,'updated',2,27,'App\\Models\\Enrollment','h963c95f4fbf5449daa9c855e706e1cb','2018-08-28 00:18:20.020000','2018-08-28 00:18:20.020000',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:16:54.343300\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:16:54.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:18:19.998300\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:18:19.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/group-overnight-starwatch/submissions/groups','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:116:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/group-overnight-starwatch/submissions/groups\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786338\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(34,1,'updated',2,27,'App\\Models\\Enrollment','a15f9a57fb2174a0ba053f6f8481b9ce','2018-08-28 00:18:27.441100','2018-08-28 00:18:27.441100',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:18:19.998300\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:18:19.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:18:27.431100\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:18:27.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:71:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786346\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(35,1,'created',2,5,'App\\Models\\Assignment','af207f7a3e6194978bedd85a2e58ee5c','2018-08-28 00:19:01.044100','2018-08-28 00:19:01.044100',NULL,'a:0:{}','a:30:{s:12:\"resource_key\";s:32:\"ud7c1186e1a44432a963cdacd4368e4d\";s:11:\"category_id\";i:13;s:9:\"parent_id\";i:3;s:17:\"anonymous_posting\";b:0;s:14:\"available_date\";s:26:\"2018-08-28 00:18:00.000000\";s:17:\"comments_required\";s:11:\"Recommended\";s:10:\"creator_id\";i:1;s:4:\"desc\";s:203:\"Astronomy is the oldest science, and its history shows a growing realization of our insignificant status in a vast and ancient universe.\n\nComplete the quiz and submit for grading, 10 points per question.\";s:8:\"due_date\";s:26:\"2018-09-04 06:59:00.000000\";s:26:\"google_convert_submissions\";b:0;s:10:\"grade_only\";b:0;s:12:\"grade_scheme\";s:10:\"Percentage\";s:13:\"grader_scheme\";s:9:\"Professor\";s:16:\"grades_published\";b:1;s:9:\"group_max\";i:2;s:16:\"min_num_comments\";i:0;s:13:\"min_num_posts\";i:0;s:6:\"points\";i:30;s:14:\"posts_required\";s:11:\"Recommended\";s:15:\"submission_late\";b:0;s:17:\"submission_scheme\";s:13:\"No Submission\";s:5:\"title\";s:18:\"The Night Sky Quiz\";s:4:\"type\";s:10:\"Individual\";s:26:\"upload_restrict_extensions\";N;s:19:\"word_count_comments\";i:0;s:16:\"word_count_posts\";i:0;s:9:\"permalink\";s:18:\"the-night-sky-quiz\";s:10:\"updated_at\";s:26:\"2018-08-28 00:19:01.029000\";s:10:\"created_at\";s:26:\"2018-08-28 00:19:01.029000\";s:2:\"id\";i:5;}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments','POST','a:19:{s:18:\"restrictExtensions\";b:0;s:13:\"availableDate\";s:24:\"2018-08-28T00:18:00.000Z\";s:7:\"dueDate\";s:24:\"2018-09-04T06:59:00.000Z\";s:12:\"graderScheme\";s:9:\"Professor\";s:9:\"_category\";s:78:\"https://demo.notebowl.xyz/api/v1.0/categories/m9fb083f87d3941f987253b40638c738\";s:11:\"gradeScheme\";s:10:\"Percentage\";s:16:\"submissionScheme\";s:13:\"No Submission\";s:4:\"type\";s:10:\"Individual\";s:5:\"title\";s:18:\"The Night Sky Quiz\";s:6:\"points\";i:30;s:11:\"description\";s:203:\"Astronomy is the oldest science, and its history shows a growing realization of our insignificant status in a vast and ancient universe.\n\nComplete the quiz and submit for grading, 10 points per question.\";s:24:\"uploadRestrictExtensions\";N;s:13:\"postsRequired\";s:11:\"Recommended\";s:16:\"commentsRequired\";s:11:\"Recommended\";s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:9:\"gradeOnly\";b:0;s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786347\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(36,1,'updated',2,27,'App\\Models\\Enrollment','kf7145ff2482747769dea01ab35d9baa','2018-08-28 00:19:01.883800','2018-08-28 00:19:01.883800',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:18:27.431100\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:18:27.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:19:01.877700\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:19:01.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/the-night-sky-quiz/submissions/students','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:111:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/the-night-sky-quiz/submissions/students\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786348\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(37,1,'updated',2,27,'App\\Models\\Enrollment','z624ec193059c4c4e85e529fd064ab0e','2018-08-28 00:19:13.476000','2018-08-28 00:19:13.476000',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:19:01.877700\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:19:01.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:19:13.469700\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:19:13.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:71:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786354\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(38,1,'created',2,6,'App\\Models\\Assignment','r1d4812cd52de4c1bb9ab9491dfb7a5f','2018-08-28 00:19:55.756500','2018-08-28 00:19:55.756500',NULL,'a:0:{}','a:30:{s:12:\"resource_key\";s:32:\"c40d8a7ce79894a879ee92d410052626\";s:11:\"category_id\";i:12;s:9:\"parent_id\";i:3;s:17:\"anonymous_posting\";b:0;s:14:\"available_date\";s:26:\"2018-08-28 00:19:00.000000\";s:17:\"comments_required\";s:11:\"Recommended\";s:10:\"creator_id\";i:1;s:4:\"desc\";s:216:\"A continuing revolution in telescope design and construction is giving astronomers an unprecedented set of tools for exploring the universe.\n\nThis exam will be graded before spring break, please ask if any questions!\";s:8:\"due_date\";s:26:\"2018-09-04 06:59:00.000000\";s:26:\"google_convert_submissions\";b:0;s:10:\"grade_only\";b:0;s:12:\"grade_scheme\";s:12:\"Letter Grade\";s:13:\"grader_scheme\";s:9:\"Professor\";s:16:\"grades_published\";b:1;s:9:\"group_max\";i:2;s:16:\"min_num_comments\";i:0;s:13:\"min_num_posts\";i:0;s:6:\"points\";i:40;s:14:\"posts_required\";s:11:\"Recommended\";s:15:\"submission_late\";b:0;s:17:\"submission_scheme\";s:13:\"No Submission\";s:5:\"title\";s:23:\"Intro to Astronomy Exam\";s:4:\"type\";s:10:\"Individual\";s:26:\"upload_restrict_extensions\";N;s:19:\"word_count_comments\";i:0;s:16:\"word_count_posts\";i:0;s:9:\"permalink\";s:23:\"intro-to-astronomy-exam\";s:10:\"updated_at\";s:26:\"2018-08-28 00:19:55.745200\";s:10:\"created_at\";s:26:\"2018-08-28 00:19:55.745200\";s:2:\"id\";i:6;}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments','POST','a:19:{s:18:\"restrictExtensions\";b:0;s:13:\"availableDate\";s:24:\"2018-08-28T00:19:00.000Z\";s:7:\"dueDate\";s:24:\"2018-09-04T06:59:00.000Z\";s:12:\"graderScheme\";s:9:\"Professor\";s:9:\"_category\";s:78:\"https://demo.notebowl.xyz/api/v1.0/categories/ebaa086f7065d4c3c86781403b3aab5f\";s:11:\"gradeScheme\";s:12:\"Letter Grade\";s:16:\"submissionScheme\";s:13:\"No Submission\";s:4:\"type\";s:10:\"Individual\";s:5:\"title\";s:23:\"Intro to Astronomy Exam\";s:6:\"points\";i:40;s:11:\"description\";s:216:\"A continuing revolution in telescope design and construction is giving astronomers an unprecedented set of tools for exploring the universe.\n\nThis exam will be graded before spring break, please ask if any questions!\";s:24:\"uploadRestrictExtensions\";N;s:13:\"postsRequired\";s:11:\"Recommended\";s:16:\"commentsRequired\";s:11:\"Recommended\";s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:9:\"gradeOnly\";b:0;s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786355\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(39,1,'updated',2,27,'App\\Models\\Enrollment','zf2e0bfa8f1e34029b3cd76a535521b9','2018-08-28 00:19:56.482300','2018-08-28 00:19:56.482300',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:19:13.469700\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:19:13.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:19:56.474800\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:19:56.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/intro-to-astronomy-exam/submissions/students','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:116:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/intro-to-astronomy-exam/submissions/students\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786356\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(40,1,'updated',2,27,'App\\Models\\Enrollment','aad2e2347d7044663a9a517ff4289961','2018-08-28 00:19:58.951200','2018-08-28 00:19:58.951200',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:19:56.474800\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:19:56.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:19:58.943500\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:19:58.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:71:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786361\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(41,1,'created',2,7,'App\\Models\\Assignment','xe1cc0c0926ac49f8926b8d0b98bd9ec','2018-08-28 00:20:29.873700','2018-08-28 00:20:29.873700',NULL,'a:0:{}','a:30:{s:12:\"resource_key\";s:32:\"lf1f97d5feb6746769401727a7d7988e\";s:11:\"category_id\";i:14;s:9:\"parent_id\";i:3;s:17:\"anonymous_posting\";b:0;s:14:\"available_date\";s:26:\"2018-08-28 00:20:00.000000\";s:17:\"comments_required\";s:11:\"Recommended\";s:10:\"creator_id\";i:1;s:4:\"desc\";s:162:\"Review the SpaceX Mission to Mars and write up a one-page paper with your opinions on the pros and cons of this mission. And your thoughts on when it is possible.\";s:8:\"due_date\";s:26:\"2018-09-04 06:59:00.000000\";s:26:\"google_convert_submissions\";b:0;s:10:\"grade_only\";b:0;s:12:\"grade_scheme\";s:6:\"Points\";s:13:\"grader_scheme\";s:9:\"Professor\";s:16:\"grades_published\";b:1;s:9:\"group_max\";i:2;s:16:\"min_num_comments\";i:0;s:13:\"min_num_posts\";i:0;s:6:\"points\";i:50;s:14:\"posts_required\";s:11:\"Recommended\";s:15:\"submission_late\";b:1;s:17:\"submission_scheme\";s:15:\"File Submission\";s:5:\"title\";s:15:\"Mission to Mars\";s:4:\"type\";s:10:\"Individual\";s:26:\"upload_restrict_extensions\";N;s:19:\"word_count_comments\";i:0;s:16:\"word_count_posts\";i:0;s:9:\"permalink\";s:15:\"mission-to-mars\";s:10:\"updated_at\";s:26:\"2018-08-28 00:20:29.855900\";s:10:\"created_at\";s:26:\"2018-08-28 00:20:29.855900\";s:2:\"id\";i:7;}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments','POST','a:20:{s:18:\"restrictExtensions\";b:0;s:13:\"availableDate\";s:24:\"2018-08-28T00:20:00.000Z\";s:7:\"dueDate\";s:24:\"2018-09-04T06:59:00.000Z\";s:12:\"graderScheme\";s:9:\"Professor\";s:9:\"_category\";s:78:\"https://demo.notebowl.xyz/api/v1.0/categories/xc97a04a91e4e461c8bdaf1ee57397a9\";s:11:\"gradeScheme\";s:6:\"Points\";s:16:\"submissionScheme\";s:15:\"File Submission\";s:4:\"type\";s:10:\"Individual\";s:5:\"title\";s:15:\"Mission to Mars\";s:6:\"points\";i:50;s:11:\"description\";s:162:\"Review the SpaceX Mission to Mars and write up a one-page paper with your opinions on the pros and cons of this mission. And your thoughts on when it is possible.\";s:23:\"lateSubmissionPermitted\";b:1;s:24:\"uploadRestrictExtensions\";N;s:13:\"postsRequired\";s:11:\"Recommended\";s:16:\"commentsRequired\";s:11:\"Recommended\";s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:9:\"gradeOnly\";b:0;s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786362\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(42,1,'updated',2,27,'App\\Models\\Enrollment','ab887b210f3724424b0d08d57a48b793','2018-08-28 00:20:30.884100','2018-08-28 00:20:30.884100',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:19:58.943500\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:19:58.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:20:30.874300\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:20:30.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/mission-to-mars/submissions/students','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:108:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/mission-to-mars/submissions/students\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786363\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(43,1,'updated',2,27,'App\\Models\\Enrollment','maa85675579c14924ae68e22bbe3ff9b','2018-08-28 00:20:38.386100','2018-08-28 00:20:38.386100',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:20:30.874300\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:20:30.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:20:38.378900\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:20:38.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:71:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786369\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(44,1,'updated',2,27,'App\\Models\\Enrollment','i9a3b3274cbfa401eb5c0129c94aaa0d','2018-08-28 00:20:41.480700','2018-08-28 00:20:41.480700',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:20:38.378900\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:20:38.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:20:41.472400\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:20:41.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/documents','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:69:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/documents\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786370\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(45,1,'updated',2,27,'App\\Models\\Enrollment','fcc291eec31fe44ed9151ebcc2065fba','2018-08-28 00:20:43.567900','2018-08-28 00:20:43.567900',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:20:41.472400\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:20:41.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:20:43.558300\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:20:43.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:71:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786372\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(46,1,'updated',2,27,'App\\Models\\Enrollment','d617d6feabcfe4a86bbe8a9cb3894742','2018-08-28 00:20:50.742500','2018-08-28 00:20:50.742500',NULL,'a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:20:43.558300\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:20:43.000000\";}','a:13:{s:9:\"parent_id\";i:3;s:7:\"user_id\";i:1;s:2:\"id\";i:27;s:12:\"resource_key\";s:32:\"y2dfd06aceeb94d648c36ee201dbad72\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:06:01.514300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:20:50.735300\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:20:50.000000\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/bulletin','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:68:\"https://demo.notebowl.xyz/courses/astronomy--exploring-time/bulletin\";s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786373\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(47,1,'created',2,1,'App\\Models\\Post','m6d1c172ce76e40f0b01f87e1cad55df','2018-08-28 00:21:09.216400','2018-08-28 00:21:09.216400',NULL,'a:0:{}','a:15:{s:12:\"resource_key\";s:32:\"a94879b1c3b8e482babd7d8141d0d269\";s:9:\"parent_id\";i:3;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:7:\"user_id\";i:1;s:8:\"owner_id\";i:3;s:10:\"owner_type\";s:17:\"App\\Models\\Course\";s:10:\"related_id\";i:3;s:12:\"related_type\";s:17:\"App\\Models\\Course\";s:14:\"available_date\";s:26:\"2018-08-28 00:21:07.000000\";s:4:\"text\";s:118:\"Elon Musk knows how to market space technology with sending a rocket with a \"Starman\" on a Tesla Roadster. A must see!\";s:9:\"anonymous\";b:0;s:6:\"pinned\";b:0;s:10:\"updated_at\";s:26:\"2018-08-28 00:21:09.203400\";s:10:\"created_at\";s:26:\"2018-08-28 00:21:09.203400\";s:2:\"id\";i:1;}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/bulletin','POST','a:11:{s:11:\"isAnonymous\";b:0;s:6:\"pinned\";b:0;s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:8:\"_creator\";s:73:\"https://demo.notebowl.xyz/api/v1.0/users/U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";s:4:\"text\";s:118:\"Elon Musk knows how to market space technology with sending a rocket with a \"Starman\" on a Tesla Roadster. A must see!\";s:6:\"_owner\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:8:\"_related\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:13:\"availableDate\";b:1;s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786374\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(48,1,'updated',2,1,'App\\Models\\Post','x2f4da9d8e05d4676a0f0957e4eeceda','2018-08-28 00:21:13.869300','2018-08-28 00:21:13.869300',NULL,'a:17:{s:2:\"id\";i:1;s:4:\"text\";s:118:\"Elon Musk knows how to market space technology with sending a rocket with a \"Starman\" on a Tesla Roadster. A must see!\";s:7:\"user_id\";i:1;s:9:\"parent_id\";i:3;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:9:\"anonymous\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:21:09.203400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:21:09.203400\";s:12:\"resource_key\";s:32:\"a94879b1c3b8e482babd7d8141d0d269\";s:10:\"deleted_at\";N;s:9:\"edited_at\";N;s:6:\"pinned\";b:0;s:14:\"available_date\";s:26:\"2018-08-28 00:21:07.000000\";s:8:\"owner_id\";i:3;s:10:\"owner_type\";s:17:\"App\\Models\\Course\";s:10:\"related_id\";i:3;s:12:\"related_type\";s:17:\"App\\Models\\Course\";}','a:17:{s:2:\"id\";i:1;s:4:\"text\";s:118:\"Elon Musk knows how to market space technology with sending a rocket with a \"Starman\" on a Tesla Roadster. A must see!\";s:7:\"user_id\";i:1;s:9:\"parent_id\";i:3;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:9:\"anonymous\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:21:09.203400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:21:13.836300\";s:12:\"resource_key\";s:32:\"a94879b1c3b8e482babd7d8141d0d269\";s:10:\"deleted_at\";N;s:9:\"edited_at\";N;s:6:\"pinned\";b:1;s:14:\"available_date\";s:26:\"2018-08-28 00:21:07.000000\";s:8:\"owner_id\";i:3;s:10:\"owner_type\";s:17:\"App\\Models\\Course\";s:10:\"related_id\";i:3;s:12:\"related_type\";s:17:\"App\\Models\\Course\";}',NULL,'https://demo.notebowl.xyz/courses/astronomy--exploring-time/bulletin','PUT','a:4:{s:6:\"pinned\";b:1;s:4:\"__sK\";s:27:\"1535414786218-0.5xs65v8en9u\";s:4:\"__rK\";s:13:\"1535414786378\";s:4:\"__uK\";s:32:\"U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi\";}'),
	(49,14,'created',3,2,'App\\Models\\Post','v010f257daf5a4a219dcfda88b131c34','2018-08-28 00:22:52.549300','2018-08-28 00:22:52.549300',NULL,'a:0:{}','a:15:{s:12:\"resource_key\";s:32:\"jf4547db62c1e4a309a85db18fbaf4a8\";s:9:\"parent_id\";i:3;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:7:\"user_id\";i:14;s:8:\"owner_id\";i:3;s:10:\"owner_type\";s:17:\"App\\Models\\Course\";s:10:\"related_id\";i:3;s:12:\"related_type\";s:17:\"App\\Models\\Course\";s:14:\"available_date\";s:26:\"2018-08-28 00:22:50.000000\";s:4:\"text\";s:94:\"I\'m having trouble understanding the different types of radiation. Can we go over that Monday?\";s:9:\"anonymous\";b:0;s:6:\"pinned\";b:0;s:10:\"updated_at\";s:26:\"2018-08-28 00:22:52.530000\";s:10:\"created_at\";s:26:\"2018-08-28 00:22:52.530000\";s:2:\"id\";i:2;}',NULL,'https://demo.notebowl.xyz/bulletin','POST','a:11:{s:11:\"isAnonymous\";b:0;s:6:\"pinned\";b:0;s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:8:\"_creator\";s:73:\"https://demo.notebowl.xyz/api/v1.0/users/HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3\";s:13:\"availableDate\";b:1;s:4:\"text\";s:94:\"I\'m having trouble understanding the different types of radiation. Can we go over that Monday?\";s:6:\"_owner\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:8:\"_related\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:4:\"__sK\";s:27:\"1535415760858-0.vj1pxc1f2xq\";s:4:\"__rK\";s:13:\"1535415760953\";s:4:\"__uK\";s:32:\"HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3\";}'),
	(50,14,'created',3,1,'App\\Models\\Comment','oe0ed6f8251d34def828f33553ab7722','2018-08-28 00:23:09.137900','2018-08-28 00:23:09.137900',NULL,'a:0:{}','a:8:{s:12:\"resource_key\";s:32:\"jf1833e8545654e0abdbd81b7a422d4b\";s:7:\"user_id\";i:14;s:7:\"post_id\";i:1;s:9:\"anonymous\";b:0;s:4:\"text\";s:33:\"Thanks for sharing! This is nuts!\";s:10:\"updated_at\";s:26:\"2018-08-28 00:23:09.125596\";s:10:\"created_at\";s:26:\"2018-08-28 00:23:09.125596\";s:2:\"id\";i:1;}',NULL,'https://demo.notebowl.xyz/bulletin','POST','a:7:{s:8:\"_creator\";s:73:\"https://demo.notebowl.xyz/api/v1.0/users/HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3\";s:6:\"_owner\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:7:\"_parent\";s:73:\"https://demo.notebowl.xyz/api/v1.0/posts/a94879b1c3b8e482babd7d8141d0d269\";s:4:\"text\";s:33:\"Thanks for sharing! This is nuts!\";s:4:\"__sK\";s:27:\"1535415760858-0.vj1pxc1f2xq\";s:4:\"__rK\";s:13:\"1535415760958\";s:4:\"__uK\";s:32:\"HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3\";}'),
	(51,10,'created',4,2,'App\\Models\\Comment','u1ee185dc3ae24558a001b4c79d932a7','2018-08-28 00:23:50.957200','2018-08-28 00:23:50.957200',NULL,'a:0:{}','a:8:{s:12:\"resource_key\";s:32:\"ff9c7c33fcb5d4d49b66cc8d2f9cdff6\";s:7:\"user_id\";i:10;s:7:\"post_id\";i:2;s:9:\"anonymous\";b:0;s:4:\"text\";s:86:\"I will be at the library after school going over the radiation chapter. Let\'s team up!\";s:10:\"updated_at\";s:26:\"2018-08-28 00:23:50.942000\";s:10:\"created_at\";s:26:\"2018-08-28 00:23:50.942000\";s:2:\"id\";i:2;}',NULL,'https://demo.notebowl.xyz/bulletin','POST','a:7:{s:8:\"_creator\";s:73:\"https://demo.notebowl.xyz/api/v1.0/users/zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP\";s:6:\"_owner\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:7:\"_parent\";s:73:\"https://demo.notebowl.xyz/api/v1.0/posts/jf4547db62c1e4a309a85db18fbaf4a8\";s:4:\"text\";s:86:\"I will be at the library after school going over the radiation chapter. Let\'s team up!\";s:4:\"__sK\";s:27:\"1535415807790-0.w8nufy44j18\";s:4:\"__rK\";s:13:\"1535415807864\";s:4:\"__uK\";s:32:\"zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP\";}'),
	(52,11,'created',5,3,'App\\Models\\Comment','wcfd20fdfd2b4413a9b9cfde3016175a','2018-08-28 00:24:25.496700','2018-08-28 00:24:25.496700',NULL,'a:0:{}','a:8:{s:12:\"resource_key\";s:32:\"aece9a9845f6b47d481c171b95cba06e\";s:7:\"user_id\";i:11;s:7:\"post_id\";i:2;s:9:\"anonymous\";b:0;s:4:\"text\";s:18:\"I will be as well!\";s:10:\"updated_at\";s:26:\"2018-08-28 00:24:25.483000\";s:10:\"created_at\";s:26:\"2018-08-28 00:24:25.483000\";s:2:\"id\";i:3;}',NULL,'https://demo.notebowl.xyz/bulletin','POST','a:7:{s:8:\"_creator\";s:73:\"https://demo.notebowl.xyz/api/v1.0/users/Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC\";s:6:\"_owner\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:7:\"_parent\";s:73:\"https://demo.notebowl.xyz/api/v1.0/posts/jf4547db62c1e4a309a85db18fbaf4a8\";s:4:\"text\";s:18:\"I will be as well!\";s:4:\"__sK\";s:27:\"1535415853700-0.4feyajp0te4\";s:4:\"__rK\";s:13:\"1535415853769\";s:4:\"__uK\";s:32:\"Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC\";}'),
	(53,11,'created',5,3,'App\\Models\\Post','eb69d2d1c12164023b3f4058970ea2d2','2018-08-28 00:24:44.327500','2018-08-28 00:24:44.327500',NULL,'a:0:{}','a:15:{s:12:\"resource_key\";s:32:\"oba9021da33144e3aa35ea346c95a083\";s:9:\"parent_id\";i:3;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:7:\"user_id\";i:11;s:8:\"owner_id\";i:3;s:10:\"owner_type\";s:17:\"App\\Models\\Course\";s:10:\"related_id\";i:3;s:12:\"related_type\";s:17:\"App\\Models\\Course\";s:14:\"available_date\";s:26:\"2018-08-28 00:24:42.000000\";s:4:\"text\";s:75:\"I need help with yesterday\'s lecture. Can someone please share their notes?\";s:9:\"anonymous\";b:0;s:6:\"pinned\";b:0;s:10:\"updated_at\";s:26:\"2018-08-28 00:24:44.315100\";s:10:\"created_at\";s:26:\"2018-08-28 00:24:44.315100\";s:2:\"id\";i:3;}',NULL,'https://demo.notebowl.xyz/bulletin','POST','a:11:{s:11:\"isAnonymous\";b:0;s:6:\"pinned\";b:0;s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:8:\"_creator\";s:73:\"https://demo.notebowl.xyz/api/v1.0/users/Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC\";s:13:\"availableDate\";b:1;s:4:\"text\";s:75:\"I need help with yesterday\'s lecture. Can someone please share their notes?\";s:6:\"_owner\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:8:\"_related\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:4:\"__sK\";s:27:\"1535415853700-0.4feyajp0te4\";s:4:\"__rK\";s:13:\"1535415853775\";s:4:\"__uK\";s:32:\"Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC\";}'),
	(54,2,'created',6,4,'App\\Models\\Post','b5cd8fa7d37574172a55be6ade071e63','2018-08-28 00:25:20.390900','2018-08-28 00:25:20.390900',NULL,'a:0:{}','a:15:{s:12:\"resource_key\";s:32:\"re1ac9f174d0c4febb2d48e4075ce4cf\";s:9:\"parent_id\";i:3;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:7:\"user_id\";i:2;s:8:\"owner_id\";i:3;s:10:\"owner_type\";s:17:\"App\\Models\\Course\";s:10:\"related_id\";i:3;s:12:\"related_type\";s:17:\"App\\Models\\Course\";s:14:\"available_date\";s:26:\"2018-08-28 00:25:18.000000\";s:4:\"text\";s:228:\"Hey class - I am having trouble digesting the content in chapter 3 on what black hole formation looks like in Newtonian gravitation theory and how that differs from the relativistic case, can anyone help explain what this means?\";s:9:\"anonymous\";b:0;s:6:\"pinned\";b:0;s:10:\"updated_at\";s:26:\"2018-08-28 00:25:20.376000\";s:10:\"created_at\";s:26:\"2018-08-28 00:25:20.376000\";s:2:\"id\";i:4;}',NULL,'https://demo.notebowl.xyz/bulletin','POST','a:11:{s:11:\"isAnonymous\";b:0;s:6:\"pinned\";b:0;s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:8:\"_creator\";s:73:\"https://demo.notebowl.xyz/api/v1.0/users/JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4\";s:13:\"availableDate\";b:1;s:4:\"text\";s:228:\"Hey class - I am having trouble digesting the content in chapter 3 on what black hole formation looks like in Newtonian gravitation theory and how that differs from the relativistic case, can anyone help explain what this means?\";s:6:\"_owner\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:8:\"_related\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:4:\"__sK\";s:27:\"1535415908084-0.niptov0hyfd\";s:4:\"__rK\";s:13:\"1535415908157\";s:4:\"__uK\";s:32:\"JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4\";}'),
	(55,2,'created',6,4,'App\\Models\\Comment','na2ff7994a08c4b6b906a098b927e8d4','2018-08-28 00:25:35.920400','2018-08-28 00:25:35.920400',NULL,'a:0:{}','a:8:{s:12:\"resource_key\";s:32:\"sf822f7043fd3412cb1c32b818ac8258\";s:7:\"user_id\";i:2;s:7:\"post_id\";i:3;s:9:\"anonymous\";b:0;s:4:\"text\";s:26:\"I\'ll send them to you now!\";s:10:\"updated_at\";s:26:\"2018-08-28 00:25:35.906600\";s:10:\"created_at\";s:26:\"2018-08-28 00:25:35.906600\";s:2:\"id\";i:4;}',NULL,'https://demo.notebowl.xyz/bulletin','POST','a:7:{s:8:\"_creator\";s:73:\"https://demo.notebowl.xyz/api/v1.0/users/JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4\";s:6:\"_owner\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:7:\"_parent\";s:73:\"https://demo.notebowl.xyz/api/v1.0/posts/oba9021da33144e3aa35ea346c95a083\";s:4:\"text\";s:26:\"I\'ll send them to you now!\";s:4:\"__sK\";s:27:\"1535415908084-0.niptov0hyfd\";s:4:\"__rK\";s:13:\"1535415908163\";s:4:\"__uK\";s:32:\"JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4\";}'),
	(56,14,'created',7,5,'App\\Models\\Comment','g086133502f0a45a1a8766441b85efea','2018-08-28 00:26:12.740900','2018-08-28 00:26:12.740900',NULL,'a:0:{}','a:8:{s:12:\"resource_key\";s:32:\"k65fbc2e78d884ff8bed9cd133115b8c\";s:7:\"user_id\";i:14;s:7:\"post_id\";i:4;s:9:\"anonymous\";b:0;s:4:\"text\";s:204:\"In a Newtonian black hole, infinite energy is released in the collapse that forms the black hole. For general relativistic black holes, finite energy is released in the collapse that forms the black hole.\";s:10:\"updated_at\";s:26:\"2018-08-28 00:26:12.729800\";s:10:\"created_at\";s:26:\"2018-08-28 00:26:12.729800\";s:2:\"id\";i:5;}',NULL,'https://demo.notebowl.xyz/bulletin','POST','a:7:{s:8:\"_creator\";s:73:\"https://demo.notebowl.xyz/api/v1.0/users/HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3\";s:6:\"_owner\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:7:\"_parent\";s:73:\"https://demo.notebowl.xyz/api/v1.0/posts/re1ac9f174d0c4febb2d48e4075ce4cf\";s:4:\"text\";s:204:\"In a Newtonian black hole, infinite energy is released in the collapse that forms the black hole. For general relativistic black holes, finite energy is released in the collapse that forms the black hole.\";s:4:\"__sK\";s:27:\"1535415952332-0.8i3jti7aooi\";s:4:\"__rK\";s:13:\"1535415952417\";s:4:\"__uK\";s:32:\"HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3\";}'),
	(57,14,'created',7,6,'App\\Models\\Comment','icaa200f3694d46fa800d25e1e515db4','2018-08-28 00:26:30.279400','2018-08-28 00:26:30.279400',NULL,'a:0:{}','a:8:{s:12:\"resource_key\";s:32:\"t937f86900159428eb470f6b13be8d09\";s:7:\"user_id\";i:14;s:7:\"post_id\";i:2;s:9:\"anonymous\";b:0;s:4:\"text\";s:25:\"Thanks guys, let\'s do it!\";s:10:\"updated_at\";s:26:\"2018-08-28 00:26:30.262700\";s:10:\"created_at\";s:26:\"2018-08-28 00:26:30.262700\";s:2:\"id\";i:6;}',NULL,'https://demo.notebowl.xyz/bulletin','POST','a:7:{s:8:\"_creator\";s:73:\"https://demo.notebowl.xyz/api/v1.0/users/HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3\";s:6:\"_owner\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:7:\"_parent\";s:73:\"https://demo.notebowl.xyz/api/v1.0/posts/jf4547db62c1e4a309a85db18fbaf4a8\";s:4:\"text\";s:25:\"Thanks guys, let\'s do it!\";s:4:\"__sK\";s:27:\"1535415952332-0.8i3jti7aooi\";s:4:\"__rK\";s:13:\"1535415952422\";s:4:\"__uK\";s:32:\"HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3\";}'),
	(58,3,'created',8,7,'App\\Models\\Comment','pf67389fb63344ec696d48cf7e6418dd','2018-08-28 00:27:35.722500','2018-08-28 00:27:35.722500',NULL,'a:0:{}','a:8:{s:12:\"resource_key\";s:32:\"zb0f9f713f87c4daf995245fbe004f92\";s:7:\"user_id\";i:3;s:7:\"post_id\";i:4;s:9:\"anonymous\";b:0;s:4:\"text\";s:179:\"Also, the Newtonian black hole involves no disturbance to space and time. Compared to general relativistic black holes where there are causally isolated regions of space and time.\";s:10:\"updated_at\";s:26:\"2018-08-28 00:27:35.711900\";s:10:\"created_at\";s:26:\"2018-08-28 00:27:35.711900\";s:2:\"id\";i:7;}',NULL,'https://demo.notebowl.xyz/bulletin','POST','a:7:{s:8:\"_creator\";s:73:\"https://demo.notebowl.xyz/api/v1.0/users/d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";s:6:\"_owner\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:7:\"_parent\";s:73:\"https://demo.notebowl.xyz/api/v1.0/posts/re1ac9f174d0c4febb2d48e4075ce4cf\";s:4:\"text\";s:179:\"Also, the Newtonian black hole involves no disturbance to space and time. Compared to general relativistic black holes where there are causally isolated regions of space and time.\";s:4:\"__sK\";s:26:\"1535416036081-0.cyzmijmw3e\";s:4:\"__rK\";s:13:\"1535416036147\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(59,3,'created',8,5,'App\\Models\\Post','d652116083a3647c78fbd5882fa54e7b','2018-08-28 00:27:58.008100','2018-08-28 00:35:09.199400','2018-08-28 00:35:09.199400','a:0:{}','a:15:{s:12:\"resource_key\";s:32:\"c0c0908f08fb24edaa443172b7d8ff10\";s:9:\"parent_id\";i:3;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:7:\"user_id\";i:3;s:8:\"owner_id\";i:3;s:10:\"owner_type\";s:17:\"App\\Models\\Course\";s:10:\"related_id\";i:3;s:12:\"related_type\";s:17:\"App\\Models\\Course\";s:14:\"available_date\";s:26:\"2018-08-28 00:27:55.000000\";s:4:\"text\";s:88:\"Hey class - make sure to check the assignment for tomorrow and ask questions below here.\";s:9:\"anonymous\";b:0;s:6:\"pinned\";b:0;s:10:\"updated_at\";s:26:\"2018-08-28 00:27:57.996600\";s:10:\"created_at\";s:26:\"2018-08-28 00:27:57.996600\";s:2:\"id\";i:5;}',NULL,'https://demo.notebowl.xyz/bulletin','POST','a:11:{s:11:\"isAnonymous\";b:0;s:6:\"pinned\";b:0;s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:8:\"_creator\";s:73:\"https://demo.notebowl.xyz/api/v1.0/users/d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";s:13:\"availableDate\";b:1;s:4:\"text\";s:88:\"Hey class - make sure to check the assignment for tomorrow and ask questions below here.\";s:6:\"_owner\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:8:\"_related\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:4:\"__sK\";s:26:\"1535416036081-0.cyzmijmw3e\";s:4:\"__rK\";s:13:\"1535416036150\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(60,3,'updated',8,5,'App\\Models\\Post','b30f3d69f6d1540068c3a7cbdab275c7','2018-08-28 00:28:25.399600','2018-08-28 00:35:09.203600','2018-08-28 00:35:09.203600','a:17:{s:2:\"id\";i:5;s:4:\"text\";s:88:\"Hey class - make sure to check the assignment for tomorrow and ask questions below here.\";s:7:\"user_id\";i:3;s:9:\"parent_id\";i:3;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:9:\"anonymous\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:27:57.996600\";s:10:\"updated_at\";s:26:\"2018-08-28 00:27:57.996600\";s:12:\"resource_key\";s:32:\"c0c0908f08fb24edaa443172b7d8ff10\";s:10:\"deleted_at\";N;s:9:\"edited_at\";N;s:6:\"pinned\";b:0;s:14:\"available_date\";s:26:\"2018-08-28 00:27:55.000000\";s:8:\"owner_id\";i:3;s:10:\"owner_type\";s:17:\"App\\Models\\Course\";s:10:\"related_id\";i:3;s:12:\"related_type\";s:17:\"App\\Models\\Course\";}','a:17:{s:2:\"id\";i:5;s:4:\"text\";s:86:\"Remember: make sure to check the assignment for tomorrow and ask questions below here.\";s:7:\"user_id\";i:3;s:9:\"parent_id\";i:3;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:9:\"anonymous\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:27:57.996600\";s:10:\"updated_at\";s:26:\"2018-08-28 00:28:25.374900\";s:12:\"resource_key\";s:32:\"c0c0908f08fb24edaa443172b7d8ff10\";s:10:\"deleted_at\";N;s:9:\"edited_at\";s:26:\"2018-08-28 00:28:25.367000\";s:6:\"pinned\";b:0;s:14:\"available_date\";s:26:\"2018-08-28 00:27:55.000000\";s:8:\"owner_id\";i:3;s:10:\"owner_type\";s:17:\"App\\Models\\Course\";s:10:\"related_id\";i:3;s:12:\"related_type\";s:17:\"App\\Models\\Course\";}',NULL,'https://demo.notebowl.xyz/bulletin','PUT','a:4:{s:4:\"text\";s:86:\"Remember: make sure to check the assignment for tomorrow and ask questions below here.\";s:4:\"__sK\";s:26:\"1535416036081-0.cyzmijmw3e\";s:4:\"__rK\";s:13:\"1535416036154\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(61,10,'created',9,8,'App\\Models\\Comment','n0197aa68c9a448cea4f175a00169301','2018-08-28 00:29:04.217300','2018-08-28 00:29:04.217300',NULL,'a:0:{}','a:8:{s:12:\"resource_key\";s:32:\"hc16cc4a29bdf4ed79838367aa4b5aec\";s:7:\"user_id\";i:10;s:7:\"post_id\";i:4;s:9:\"anonymous\";b:0;s:4:\"text\";s:88:\"This link will help you determine the difference between the two black holes formations!\";s:10:\"updated_at\";s:26:\"2018-08-28 00:29:04.204100\";s:10:\"created_at\";s:26:\"2018-08-28 00:29:04.204100\";s:2:\"id\";i:8;}',NULL,'https://demo.notebowl.xyz/bulletin','POST','a:7:{s:8:\"_creator\";s:73:\"https://demo.notebowl.xyz/api/v1.0/users/zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP\";s:6:\"_owner\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/lc70cff6d40844d52b9927fa9a406a13\";s:7:\"_parent\";s:73:\"https://demo.notebowl.xyz/api/v1.0/posts/re1ac9f174d0c4febb2d48e4075ce4cf\";s:4:\"text\";s:88:\"This link will help you determine the difference between the two black holes formations!\";s:4:\"__sK\";s:28:\"1535416125491-0.0cqszb1aghq5\";s:4:\"__rK\";s:13:\"1535416125604\";s:4:\"__uK\";s:32:\"zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP\";}'),
	(62,10,'updated',9,8,'App\\Models\\Comment','pb0049a5b18ec4eebb6e7fbd80ee205e','2018-08-28 00:29:11.052800','2018-08-28 00:29:11.052800',NULL,'a:10:{s:2:\"id\";i:8;s:7:\"user_id\";i:10;s:7:\"post_id\";i:4;s:4:\"text\";s:88:\"This link will help you determine the difference between the two black holes formations!\";s:10:\"created_at\";s:26:\"2018-08-28 00:29:04.204100\";s:10:\"updated_at\";s:26:\"2018-08-28 00:29:04.204100\";s:12:\"resource_key\";s:32:\"hc16cc4a29bdf4ed79838367aa4b5aec\";s:10:\"deleted_at\";N;s:9:\"edited_at\";N;s:9:\"anonymous\";b:0;}','a:10:{s:2:\"id\";i:8;s:7:\"user_id\";i:10;s:7:\"post_id\";i:4;s:4:\"text\";s:169:\"This link will help you determine the difference between the two black holes formations!\nhttp://www.pitt.edu/~jdnorton/teaching/HPS_0410/chapters/black_holes/#Newtonian1\";s:10:\"created_at\";s:26:\"2018-08-28 00:29:04.204100\";s:10:\"updated_at\";s:26:\"2018-08-28 00:29:11.033200\";s:12:\"resource_key\";s:32:\"hc16cc4a29bdf4ed79838367aa4b5aec\";s:10:\"deleted_at\";N;s:9:\"edited_at\";s:26:\"2018-08-28 00:29:11.018700\";s:9:\"anonymous\";b:0;}',NULL,'https://demo.notebowl.xyz/bulletin','PUT','a:4:{s:4:\"text\";s:169:\"This link will help you determine the difference between the two black holes formations!\nhttp://www.pitt.edu/~jdnorton/teaching/HPS_0410/chapters/black_holes/#Newtonian1\";s:4:\"__sK\";s:28:\"1535416125491-0.0cqszb1aghq5\";s:4:\"__rK\";s:13:\"1535416125607\";s:4:\"__uK\";s:32:\"zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP\";}'),
	(63,1,'created',10,4,'App\\Models\\Course','u4c0406fbed5a42f0a40b18f27f1d26e','2018-08-28 00:31:37.083900','2018-08-28 00:31:37.083900',NULL,'a:0:{}','a:69:{s:5:\"units\";d:0;s:12:\"resource_key\";s:32:\"le4acf50aaacc4d86a8ad041040cfa3d\";s:7:\"term_id\";i:1;s:13:\"university_id\";i:1;s:14:\"available_date\";s:26:\"2014-01-01 00:00:00.000000\";s:24:\"course_tab_enabled_about\";b:1;s:32:\"course_tab_enabled_about_student\";b:1;s:28:\"course_tab_enabled_about_t_a\";b:1;s:30:\"course_tab_enabled_assignments\";b:1;s:38:\"course_tab_enabled_assignments_student\";b:1;s:34:\"course_tab_enabled_assignments_t_a\";b:1;s:28:\"course_tab_enabled_documents\";b:1;s:36:\"course_tab_enabled_documents_student\";b:1;s:32:\"course_tab_enabled_documents_t_a\";b:1;s:25:\"course_tab_enabled_grades\";b:1;s:33:\"course_tab_enabled_grades_student\";b:1;s:29:\"course_tab_enabled_grades_t_a\";b:0;s:25:\"course_tab_enabled_roster\";b:1;s:33:\"course_tab_enabled_roster_student\";b:1;s:29:\"course_tab_enabled_roster_t_a\";b:1;s:21:\"course_tab_name_about\";s:5:\"About\";s:27:\"course_tab_name_assignments\";s:11:\"Assignments\";s:24:\"course_tab_name_bulletin\";s:8:\"Bulletin\";s:25:\"course_tab_name_documents\";s:9:\"Documents\";s:22:\"course_tab_name_grades\";s:6:\"Grades\";s:22:\"course_tab_name_roster\";s:6:\"Roster\";s:11:\"description\";N;s:29:\"download_restrict_assessments\";N;s:29:\"download_restrict_assignments\";N;s:26:\"download_restrict_bulletin\";N;s:27:\"download_restrict_documents\";N;s:28:\"download_restrict_extensions\";N;s:29:\"download_restrict_submissions\";N;s:28:\"enable_letter_grade_override\";b:0;s:35:\"enable_student_average_grade_letter\";b:1;s:43:\"enable_student_average_grade_letter_student\";b:1;s:39:\"enable_student_average_grade_letter_t_a\";b:1;s:39:\"enable_student_average_grade_percentage\";b:1;s:47:\"enable_student_average_grade_percentage_student\";b:1;s:43:\"enable_student_average_grade_percentage_t_a\";b:1;s:35:\"enable_student_average_grade_points\";b:0;s:43:\"enable_student_average_grade_points_student\";b:0;s:39:\"enable_student_average_grade_points_t_a\";b:0;s:8:\"end_date\";s:26:\"2050-01-01 00:00:00.000000\";s:21:\"enrollment_close_date\";N;s:10:\"grade_base\";s:7:\"percent\";s:18:\"grade_curve_amount\";d:0;s:15:\"grade_precision\";i:1;s:18:\"grade_scale_custom\";b:0;s:19:\"grade_scale_medians\";s:14:\"30;65;75;85;95\";s:18:\"grade_scale_titles\";s:9:\"F;D;C;B;A\";s:18:\"grade_scale_values\";s:13:\"0;60;70;80;90\";s:12:\"grade_scheme\";s:5:\"round\";s:8:\"location\";N;s:4:\"name\";s:53:\"American History: The Role of Politics and Government\";s:6:\"number\";s:3:\"400\";s:14:\"points_enabled\";b:1;s:5:\"price\";d:0;s:15:\"profile_picture\";N;s:9:\"published\";b:0;s:7:\"subject\";s:3:\"AMH\";s:4:\"type\";N;s:15:\"use_drop_lowest\";b:0;s:19:\"use_weighted_grades\";b:0;s:7:\"paywall\";b:0;s:9:\"permalink\";s:25:\"american-history--the-rol\";s:10:\"updated_at\";s:26:\"2018-08-28 00:31:37.039100\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:37.039100\";s:2:\"id\";i:4;}',NULL,'https://demo.notebowl.xyz/gateway/services/dashboard/newCourse','POST','a:5:{s:4:\"name\";s:53:\"American History: The Role of Politics and Government\";s:7:\"subject\";s:3:\"AMH\";s:6:\"number\";s:3:\"400\";s:5:\"_term\";s:73:\"https://demo.notebowl.xyz/api/v1.0/terms/JwQlgcfCVRWjDkPiwonbMgGPIaF5WJ1S\";s:6:\"method\";s:5:\"reset\";}'),
	(64,1,'created',10,32,'App\\Models\\Enrollment','n50b1b3be96aa492fb03e3528e587fb9','2018-08-28 00:31:51.682000','2018-08-28 00:31:51.682000',NULL,'a:0:{}','a:10:{s:9:\"parent_id\";i:4;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:7:\"user_id\";i:3;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:6:\"origin\";s:6:\"native\";s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:10:\"updated_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:2:\"id\";i:32;}',NULL,'https://demo.notebowl.xyz/gateway/services/dashboard/addUserEnrollment/d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ?course=le4acf50aaacc4d86a8ad041040cfa3d&returnUrl=https%3A%2F%2Fdemo.notebowl.xyz%2Fgateway%2Fservices%2Fdashboard%2Fcourse%2Fle4acf50aaacc4d86a8ad041040cfa3d','POST','a:5:{s:4:\"term\";s:32:\"JwQlgcfCVRWjDkPiwonbMgGPIaF5WJ1S\";s:6:\"course\";s:32:\"le4acf50aaacc4d86a8ad041040cfa3d\";s:4:\"role\";s:9:\"Professor\";s:9:\"addCourse\";s:10:\"Add Course\";s:9:\"returnUrl\";s:92:\"https://demo.notebowl.xyz/gateway/services/dashboard/course/le4acf50aaacc4d86a8ad041040cfa3d\";}'),
	(65,1,'created',10,5,'App\\Models\\Course','ib0a042815e9e46aa97cb6d4681117a4','2018-08-28 00:32:17.818400','2018-08-28 00:32:17.818400',NULL,'a:0:{}','a:69:{s:5:\"units\";d:0;s:12:\"resource_key\";s:32:\"s5802ee9570f642b28342df283d297af\";s:7:\"term_id\";i:1;s:13:\"university_id\";i:1;s:14:\"available_date\";s:26:\"2014-01-01 00:00:00.000000\";s:24:\"course_tab_enabled_about\";b:1;s:32:\"course_tab_enabled_about_student\";b:1;s:28:\"course_tab_enabled_about_t_a\";b:1;s:30:\"course_tab_enabled_assignments\";b:1;s:38:\"course_tab_enabled_assignments_student\";b:1;s:34:\"course_tab_enabled_assignments_t_a\";b:1;s:28:\"course_tab_enabled_documents\";b:1;s:36:\"course_tab_enabled_documents_student\";b:1;s:32:\"course_tab_enabled_documents_t_a\";b:1;s:25:\"course_tab_enabled_grades\";b:1;s:33:\"course_tab_enabled_grades_student\";b:1;s:29:\"course_tab_enabled_grades_t_a\";b:0;s:25:\"course_tab_enabled_roster\";b:1;s:33:\"course_tab_enabled_roster_student\";b:1;s:29:\"course_tab_enabled_roster_t_a\";b:1;s:21:\"course_tab_name_about\";s:5:\"About\";s:27:\"course_tab_name_assignments\";s:11:\"Assignments\";s:24:\"course_tab_name_bulletin\";s:8:\"Bulletin\";s:25:\"course_tab_name_documents\";s:9:\"Documents\";s:22:\"course_tab_name_grades\";s:6:\"Grades\";s:22:\"course_tab_name_roster\";s:6:\"Roster\";s:11:\"description\";N;s:29:\"download_restrict_assessments\";N;s:29:\"download_restrict_assignments\";N;s:26:\"download_restrict_bulletin\";N;s:27:\"download_restrict_documents\";N;s:28:\"download_restrict_extensions\";N;s:29:\"download_restrict_submissions\";N;s:28:\"enable_letter_grade_override\";b:0;s:35:\"enable_student_average_grade_letter\";b:1;s:43:\"enable_student_average_grade_letter_student\";b:1;s:39:\"enable_student_average_grade_letter_t_a\";b:1;s:39:\"enable_student_average_grade_percentage\";b:1;s:47:\"enable_student_average_grade_percentage_student\";b:1;s:43:\"enable_student_average_grade_percentage_t_a\";b:1;s:35:\"enable_student_average_grade_points\";b:0;s:43:\"enable_student_average_grade_points_student\";b:0;s:39:\"enable_student_average_grade_points_t_a\";b:0;s:8:\"end_date\";s:26:\"2050-01-01 00:00:00.000000\";s:21:\"enrollment_close_date\";N;s:10:\"grade_base\";s:7:\"percent\";s:18:\"grade_curve_amount\";d:0;s:15:\"grade_precision\";i:1;s:18:\"grade_scale_custom\";b:0;s:19:\"grade_scale_medians\";s:14:\"30;65;75;85;95\";s:18:\"grade_scale_titles\";s:9:\"F;D;C;B;A\";s:18:\"grade_scale_values\";s:13:\"0;60;70;80;90\";s:12:\"grade_scheme\";s:5:\"round\";s:8:\"location\";N;s:4:\"name\";s:37:\"Google Leadership Development Program\";s:6:\"number\";s:3:\"007\";s:14:\"points_enabled\";b:1;s:5:\"price\";d:0;s:15:\"profile_picture\";N;s:9:\"published\";b:0;s:7:\"subject\";s:4:\"GOOG\";s:4:\"type\";N;s:15:\"use_drop_lowest\";b:0;s:19:\"use_weighted_grades\";b:0;s:7:\"paywall\";b:0;s:9:\"permalink\";s:25:\"google-leadership-develop\";s:10:\"updated_at\";s:26:\"2018-08-28 00:32:17.769300\";s:10:\"created_at\";s:26:\"2018-08-28 00:32:17.769300\";s:2:\"id\";i:5;}',NULL,'https://demo.notebowl.xyz/gateway/services/dashboard/newCourse','POST','a:5:{s:4:\"name\";s:37:\"Google Leadership Development Program\";s:7:\"subject\";s:4:\"GOOG\";s:6:\"number\";s:3:\"007\";s:5:\"_term\";s:73:\"https://demo.notebowl.xyz/api/v1.0/terms/JwQlgcfCVRWjDkPiwonbMgGPIaF5WJ1S\";s:6:\"method\";s:5:\"reset\";}'),
	(66,1,'updated',10,5,'App\\Models\\Course','g261b4091935e455d9ec59f027c16573','2018-08-28 00:32:28.639100','2018-08-28 00:32:28.639100',NULL,'a:72:{s:2:\"id\";i:5;s:13:\"university_id\";i:1;s:7:\"term_id\";i:1;s:4:\"name\";s:37:\"Google Leadership Development Program\";s:7:\"subject\";s:4:\"GOOG\";s:6:\"number\";s:3:\"007\";s:9:\"permalink\";s:25:\"google-leadership-develop\";s:14:\"available_date\";s:26:\"2014-01-01 00:00:00.000000\";s:8:\"end_date\";s:26:\"2050-01-01 00:00:00.000000\";s:21:\"enrollment_close_date\";N;s:12:\"archive_date\";N;s:5:\"units\";d:0;s:19:\"use_weighted_grades\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:32:17.769300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:32:17.769300\";s:12:\"resource_key\";s:32:\"s5802ee9570f642b28342df283d297af\";s:10:\"deleted_at\";N;s:15:\"use_drop_lowest\";b:0;s:4:\"type\";N;s:8:\"location\";N;s:11:\"description\";N;s:15:\"invite_group_id\";N;s:5:\"price\";d:0;s:29:\"download_restrict_assessments\";N;s:29:\"download_restrict_assignments\";N;s:26:\"download_restrict_bulletin\";N;s:27:\"download_restrict_documents\";N;s:29:\"download_restrict_submissions\";N;s:28:\"download_restrict_extensions\";N;s:24:\"course_tab_enabled_about\";b:1;s:28:\"course_tab_enabled_about_t_a\";b:1;s:32:\"course_tab_enabled_about_student\";b:1;s:30:\"course_tab_enabled_assignments\";b:1;s:34:\"course_tab_enabled_assignments_t_a\";b:1;s:38:\"course_tab_enabled_assignments_student\";b:1;s:28:\"course_tab_enabled_documents\";b:1;s:32:\"course_tab_enabled_documents_t_a\";b:1;s:36:\"course_tab_enabled_documents_student\";b:1;s:25:\"course_tab_enabled_grades\";b:1;s:29:\"course_tab_enabled_grades_t_a\";b:0;s:33:\"course_tab_enabled_grades_student\";b:1;s:25:\"course_tab_enabled_roster\";b:1;s:29:\"course_tab_enabled_roster_t_a\";b:1;s:33:\"course_tab_enabled_roster_student\";b:1;s:21:\"course_tab_name_about\";s:5:\"About\";s:27:\"course_tab_name_assignments\";s:11:\"Assignments\";s:25:\"course_tab_name_documents\";s:9:\"Documents\";s:22:\"course_tab_name_grades\";s:6:\"Grades\";s:22:\"course_tab_name_roster\";s:6:\"Roster\";s:24:\"course_tab_name_bulletin\";s:8:\"Bulletin\";s:14:\"points_enabled\";b:1;s:35:\"enable_student_average_grade_letter\";b:1;s:39:\"enable_student_average_grade_letter_t_a\";b:1;s:43:\"enable_student_average_grade_letter_student\";b:1;s:39:\"enable_student_average_grade_percentage\";b:1;s:43:\"enable_student_average_grade_percentage_t_a\";b:1;s:47:\"enable_student_average_grade_percentage_student\";b:1;s:35:\"enable_student_average_grade_points\";b:0;s:39:\"enable_student_average_grade_points_t_a\";b:0;s:43:\"enable_student_average_grade_points_student\";b:0;s:28:\"enable_letter_grade_override\";b:0;s:18:\"grade_scale_custom\";b:0;s:12:\"grade_scheme\";s:5:\"round\";s:10:\"grade_base\";s:7:\"percent\";s:15:\"grade_precision\";i:1;s:18:\"grade_curve_amount\";d:0;s:19:\"grade_scale_medians\";s:14:\"30;65;75;85;95\";s:18:\"grade_scale_titles\";s:9:\"F;D;C;B;A\";s:18:\"grade_scale_values\";s:13:\"0;60;70;80;90\";s:7:\"paywall\";b:0;s:9:\"published\";b:0;s:15:\"profile_picture\";N;}','a:72:{s:2:\"id\";i:5;s:13:\"university_id\";i:1;s:7:\"term_id\";i:1;s:4:\"name\";s:37:\"Google Leadership Development Program\";s:7:\"subject\";s:4:\"GOOG\";s:6:\"number\";s:3:\"007\";s:9:\"permalink\";s:25:\"google-leadership-develop\";s:14:\"available_date\";s:26:\"2014-01-01 00:00:00.000000\";s:8:\"end_date\";s:26:\"2050-01-01 00:00:00.000000\";s:21:\"enrollment_close_date\";N;s:12:\"archive_date\";N;s:5:\"units\";d:0;s:19:\"use_weighted_grades\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:32:17.769300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:32:28.609900\";s:12:\"resource_key\";s:32:\"s5802ee9570f642b28342df283d297af\";s:10:\"deleted_at\";N;s:15:\"use_drop_lowest\";b:0;s:4:\"type\";N;s:8:\"location\";s:0:\"\";s:11:\"description\";s:435:\"This course is designed to hone business expertise and develop skills for a leadership position. \r\n\r\nProgram Objectives:\r\n1. Discover how experiences, beliefs and values effect our leadership style.\r\n2. Develop human potential and build relationships of mutual trust and respect.\r\n3. Create and maintain processes and procedures that drive innovation.\r\n4. Develop leadership by demonstrating effective questioning and listening skills.\";s:15:\"invite_group_id\";N;s:5:\"price\";d:0;s:29:\"download_restrict_assessments\";N;s:29:\"download_restrict_assignments\";N;s:26:\"download_restrict_bulletin\";N;s:27:\"download_restrict_documents\";N;s:29:\"download_restrict_submissions\";N;s:28:\"download_restrict_extensions\";N;s:24:\"course_tab_enabled_about\";b:1;s:28:\"course_tab_enabled_about_t_a\";b:1;s:32:\"course_tab_enabled_about_student\";b:1;s:30:\"course_tab_enabled_assignments\";b:1;s:34:\"course_tab_enabled_assignments_t_a\";b:1;s:38:\"course_tab_enabled_assignments_student\";b:1;s:28:\"course_tab_enabled_documents\";b:1;s:32:\"course_tab_enabled_documents_t_a\";b:1;s:36:\"course_tab_enabled_documents_student\";b:1;s:25:\"course_tab_enabled_grades\";b:1;s:29:\"course_tab_enabled_grades_t_a\";b:0;s:33:\"course_tab_enabled_grades_student\";b:1;s:25:\"course_tab_enabled_roster\";b:1;s:29:\"course_tab_enabled_roster_t_a\";b:1;s:33:\"course_tab_enabled_roster_student\";b:1;s:21:\"course_tab_name_about\";s:5:\"About\";s:27:\"course_tab_name_assignments\";s:11:\"Assignments\";s:25:\"course_tab_name_documents\";s:9:\"Documents\";s:22:\"course_tab_name_grades\";s:6:\"Grades\";s:22:\"course_tab_name_roster\";s:6:\"Roster\";s:24:\"course_tab_name_bulletin\";s:8:\"Bulletin\";s:14:\"points_enabled\";b:1;s:35:\"enable_student_average_grade_letter\";b:1;s:39:\"enable_student_average_grade_letter_t_a\";b:1;s:43:\"enable_student_average_grade_letter_student\";b:1;s:39:\"enable_student_average_grade_percentage\";b:1;s:43:\"enable_student_average_grade_percentage_t_a\";b:1;s:47:\"enable_student_average_grade_percentage_student\";b:1;s:35:\"enable_student_average_grade_points\";b:0;s:39:\"enable_student_average_grade_points_t_a\";b:0;s:43:\"enable_student_average_grade_points_student\";b:0;s:28:\"enable_letter_grade_override\";b:0;s:18:\"grade_scale_custom\";b:0;s:12:\"grade_scheme\";s:5:\"round\";s:10:\"grade_base\";s:7:\"percent\";s:15:\"grade_precision\";i:1;s:18:\"grade_curve_amount\";d:0;s:19:\"grade_scale_medians\";s:14:\"30;65;75;85;95\";s:18:\"grade_scale_titles\";s:9:\"F;D;C;B;A\";s:18:\"grade_scale_values\";s:13:\"0;60;70;80;90\";s:7:\"paywall\";b:0;s:9:\"published\";b:0;s:15:\"profile_picture\";N;}',NULL,'https://demo.notebowl.xyz/gateway/services/dashboard/course/s5802ee9570f642b28342df283d297af','POST','a:11:{s:4:\"name\";s:37:\"Google Leadership Development Program\";s:7:\"subject\";s:4:\"GOOG\";s:6:\"number\";s:3:\"007\";s:5:\"_term\";s:73:\"https://demo.notebowl.xyz/api/v1.0/terms/JwQlgcfCVRWjDkPiwonbMgGPIaF5WJ1S\";s:11:\"description\";s:435:\"This course is designed to hone business expertise and develop skills for a leadership position. \r\n\r\nProgram Objectives:\r\n1. Discover how experiences, beliefs and values effect our leadership style.\r\n2. Develop human potential and build relationships of mutual trust and respect.\r\n3. Create and maintain processes and procedures that drive innovation.\r\n4. Develop leadership by demonstrating effective questioning and listening skills.\";s:5:\"price\";s:1:\"0\";s:5:\"units\";s:1:\"0\";s:8:\"location\";s:0:\"\";s:10:\"inviteCode\";s:0:\"\";s:13:\"availableDate\";s:10:\"01/01/2014\";s:15:\"enrollmentClose\";s:0:\"\";}'),
	(67,1,'created',10,33,'App\\Models\\Enrollment','m4e21ea3537f6494191a671cdd56abb6','2018-08-28 00:32:38.236000','2018-08-28 00:32:38.236000',NULL,'a:0:{}','a:10:{s:9:\"parent_id\";i:5;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:7:\"user_id\";i:3;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:6:\"origin\";s:6:\"native\";s:12:\"resource_key\";s:32:\"obd58aaaf121440c8afa9b47d25522af\";s:10:\"updated_at\";s:26:\"2018-08-28 00:32:38.218400\";s:10:\"created_at\";s:26:\"2018-08-28 00:32:38.218400\";s:2:\"id\";i:33;}',NULL,'https://demo.notebowl.xyz/gateway/services/dashboard/addUserEnrollment/d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ?course=s5802ee9570f642b28342df283d297af&returnUrl=https%3A%2F%2Fdemo.notebowl.xyz%2Fgateway%2Fservices%2Fdashboard%2Fcourse%2Fs5802ee9570f642b28342df283d297af','POST','a:5:{s:4:\"term\";s:32:\"JwQlgcfCVRWjDkPiwonbMgGPIaF5WJ1S\";s:6:\"course\";s:32:\"s5802ee9570f642b28342df283d297af\";s:4:\"role\";s:9:\"Professor\";s:9:\"addCourse\";s:10:\"Add Course\";s:9:\"returnUrl\";s:92:\"https://demo.notebowl.xyz/gateway/services/dashboard/course/s5802ee9570f642b28342df283d297af\";}'),
	(68,1,'created',10,6,'App\\Models\\Course','r3aea361a9577426ca5e7065913b5639','2018-08-28 00:33:06.316800','2018-08-28 00:33:06.316800',NULL,'a:0:{}','a:69:{s:5:\"units\";d:0;s:12:\"resource_key\";s:32:\"d4f7a84149dff4e92a9180d8d97bdd1c\";s:7:\"term_id\";i:1;s:13:\"university_id\";i:1;s:14:\"available_date\";s:26:\"2014-01-01 00:00:00.000000\";s:24:\"course_tab_enabled_about\";b:1;s:32:\"course_tab_enabled_about_student\";b:1;s:28:\"course_tab_enabled_about_t_a\";b:1;s:30:\"course_tab_enabled_assignments\";b:1;s:38:\"course_tab_enabled_assignments_student\";b:1;s:34:\"course_tab_enabled_assignments_t_a\";b:1;s:28:\"course_tab_enabled_documents\";b:1;s:36:\"course_tab_enabled_documents_student\";b:1;s:32:\"course_tab_enabled_documents_t_a\";b:1;s:25:\"course_tab_enabled_grades\";b:1;s:33:\"course_tab_enabled_grades_student\";b:1;s:29:\"course_tab_enabled_grades_t_a\";b:0;s:25:\"course_tab_enabled_roster\";b:1;s:33:\"course_tab_enabled_roster_student\";b:1;s:29:\"course_tab_enabled_roster_t_a\";b:1;s:21:\"course_tab_name_about\";s:5:\"About\";s:27:\"course_tab_name_assignments\";s:11:\"Assignments\";s:24:\"course_tab_name_bulletin\";s:8:\"Bulletin\";s:25:\"course_tab_name_documents\";s:9:\"Documents\";s:22:\"course_tab_name_grades\";s:6:\"Grades\";s:22:\"course_tab_name_roster\";s:6:\"Roster\";s:11:\"description\";N;s:29:\"download_restrict_assessments\";N;s:29:\"download_restrict_assignments\";N;s:26:\"download_restrict_bulletin\";N;s:27:\"download_restrict_documents\";N;s:28:\"download_restrict_extensions\";N;s:29:\"download_restrict_submissions\";N;s:28:\"enable_letter_grade_override\";b:0;s:35:\"enable_student_average_grade_letter\";b:1;s:43:\"enable_student_average_grade_letter_student\";b:1;s:39:\"enable_student_average_grade_letter_t_a\";b:1;s:39:\"enable_student_average_grade_percentage\";b:1;s:47:\"enable_student_average_grade_percentage_student\";b:1;s:43:\"enable_student_average_grade_percentage_t_a\";b:1;s:35:\"enable_student_average_grade_points\";b:0;s:43:\"enable_student_average_grade_points_student\";b:0;s:39:\"enable_student_average_grade_points_t_a\";b:0;s:8:\"end_date\";s:26:\"2050-01-01 00:00:00.000000\";s:21:\"enrollment_close_date\";N;s:10:\"grade_base\";s:7:\"percent\";s:18:\"grade_curve_amount\";d:0;s:15:\"grade_precision\";i:1;s:18:\"grade_scale_custom\";b:0;s:19:\"grade_scale_medians\";s:14:\"30;65;75;85;95\";s:18:\"grade_scale_titles\";s:9:\"F;D;C;B;A\";s:18:\"grade_scale_values\";s:13:\"0;60;70;80;90\";s:12:\"grade_scheme\";s:5:\"round\";s:8:\"location\";N;s:4:\"name\";s:15:\"Mission to Mars\";s:6:\"number\";s:3:\"100\";s:14:\"points_enabled\";b:1;s:5:\"price\";d:0;s:15:\"profile_picture\";N;s:9:\"published\";b:0;s:7:\"subject\";s:5:\"SPACE\";s:4:\"type\";N;s:15:\"use_drop_lowest\";b:0;s:19:\"use_weighted_grades\";b:0;s:7:\"paywall\";b:0;s:9:\"permalink\";s:15:\"mission-to-mars\";s:10:\"updated_at\";s:26:\"2018-08-28 00:33:06.264900\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:06.264900\";s:2:\"id\";i:6;}',NULL,'https://demo.notebowl.xyz/gateway/services/dashboard/newCourse','POST','a:5:{s:4:\"name\";s:15:\"Mission to Mars\";s:7:\"subject\";s:5:\"SPACE\";s:6:\"number\";s:3:\"100\";s:5:\"_term\";s:73:\"https://demo.notebowl.xyz/api/v1.0/terms/JwQlgcfCVRWjDkPiwonbMgGPIaF5WJ1S\";s:6:\"method\";s:5:\"reset\";}'),
	(69,1,'created',10,34,'App\\Models\\Enrollment','dc8c5c80a1b344ad0b5b9ead920e85b2','2018-08-28 00:33:18.686900','2018-08-28 00:33:18.686900',NULL,'a:0:{}','a:10:{s:9:\"parent_id\";i:6;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:7:\"user_id\";i:3;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:6:\"origin\";s:6:\"native\";s:12:\"resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:10:\"updated_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:2:\"id\";i:34;}',NULL,'https://demo.notebowl.xyz/gateway/services/dashboard/addUserEnrollment/d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ?course=d4f7a84149dff4e92a9180d8d97bdd1c&returnUrl=https%3A%2F%2Fdemo.notebowl.xyz%2Fgateway%2Fservices%2Fdashboard%2Fcourse%2Fd4f7a84149dff4e92a9180d8d97bdd1c','POST','a:5:{s:4:\"term\";s:32:\"JwQlgcfCVRWjDkPiwonbMgGPIaF5WJ1S\";s:6:\"course\";s:32:\"d4f7a84149dff4e92a9180d8d97bdd1c\";s:4:\"role\";s:9:\"Professor\";s:9:\"addCourse\";s:10:\"Add Course\";s:9:\"returnUrl\";s:92:\"https://demo.notebowl.xyz/gateway/services/dashboard/course/d4f7a84149dff4e92a9180d8d97bdd1c\";}'),
	(70,1,'created',10,35,'App\\Models\\Enrollment','s1f3bb24892794a95a6fe38d94fb6846','2018-08-28 00:34:24.724000','2018-08-28 00:34:24.724000',NULL,'a:0:{}','a:10:{s:9:\"parent_id\";i:4;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:7:\"user_id\";i:10;s:4:\"role\";s:7:\"Student\";s:6:\"status\";s:8:\"Accepted\";s:6:\"origin\";s:6:\"native\";s:12:\"resource_key\";s:32:\"h8c1d469106224e308f0704c03ab98ac\";s:10:\"updated_at\";s:26:\"2018-08-28 00:34:24.713100\";s:10:\"created_at\";s:26:\"2018-08-28 00:34:24.713100\";s:2:\"id\";i:35;}',NULL,'https://demo.notebowl.xyz/gateway/services/dashboard/addUserEnrollment/zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP?course=le4acf50aaacc4d86a8ad041040cfa3d&returnUrl=https%3A%2F%2Fdemo.notebowl.xyz%2Fgateway%2Fservices%2Fdashboard%2Fcourse%2Fle4acf50aaacc4d86a8ad041040cfa3d','POST','a:5:{s:4:\"term\";s:32:\"JwQlgcfCVRWjDkPiwonbMgGPIaF5WJ1S\";s:6:\"course\";s:32:\"le4acf50aaacc4d86a8ad041040cfa3d\";s:4:\"role\";s:7:\"Student\";s:9:\"addCourse\";s:10:\"Add Course\";s:9:\"returnUrl\";s:92:\"https://demo.notebowl.xyz/gateway/services/dashboard/course/le4acf50aaacc4d86a8ad041040cfa3d\";}'),
	(71,3,'deleted',12,5,'App\\Models\\Post','cb3a43dd1566f4f6fa4399da9a62d5f7','2018-08-28 00:35:09.243100','2018-08-28 00:35:09.243100',NULL,'a:17:{s:2:\"id\";i:5;s:4:\"text\";s:86:\"Remember: make sure to check the assignment for tomorrow and ask questions below here.\";s:7:\"user_id\";i:3;s:9:\"parent_id\";i:3;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:9:\"anonymous\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:27:57.996600\";s:10:\"updated_at\";s:26:\"2018-08-28 00:28:25.374900\";s:12:\"resource_key\";s:32:\"c0c0908f08fb24edaa443172b7d8ff10\";s:10:\"deleted_at\";N;s:9:\"edited_at\";s:26:\"2018-08-28 00:28:25.367000\";s:6:\"pinned\";b:0;s:14:\"available_date\";s:26:\"2018-08-28 00:27:55.000000\";s:8:\"owner_id\";i:3;s:10:\"owner_type\";s:17:\"App\\Models\\Course\";s:10:\"related_id\";i:3;s:12:\"related_type\";s:17:\"App\\Models\\Course\";}','a:17:{s:2:\"id\";i:5;s:4:\"text\";s:86:\"Remember: make sure to check the assignment for tomorrow and ask questions below here.\";s:7:\"user_id\";i:3;s:9:\"parent_id\";i:3;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:9:\"anonymous\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:27:57.996600\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:09.211300\";s:12:\"resource_key\";s:32:\"c0c0908f08fb24edaa443172b7d8ff10\";s:10:\"deleted_at\";s:26:\"2018-08-28 00:35:09.211300\";s:9:\"edited_at\";s:26:\"2018-08-28 00:28:25.367000\";s:6:\"pinned\";b:0;s:14:\"available_date\";s:26:\"2018-08-28 00:27:55.000000\";s:8:\"owner_id\";i:3;s:10:\"owner_type\";s:17:\"App\\Models\\Course\";s:10:\"related_id\";i:3;s:12:\"related_type\";s:17:\"App\\Models\\Course\";}',NULL,'https://demo.notebowl.xyz/bulletin','DELETE','a:3:{s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494844\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(72,3,'updated',12,32,'App\\Models\\Enrollment','xdfe01be095e644738960cba7ab1ad7c','2018-08-28 00:35:11.754900','2018-08-28 00:35:11.754900',NULL,'a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";N;}','a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:11.743700\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:11.000000\";}',NULL,'https://demo.notebowl.xyz/courses/american-history--the-rol/setup/begin','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/le4acf50aaacc4d86a8ad041040cfa3d\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:71:\"https://demo.notebowl.xyz/courses/american-history--the-rol/setup/begin\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494845\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(73,3,'updated',12,32,'App\\Models\\Enrollment','baaaa3a012c124506a41ef69601bc9e2','2018-08-28 00:35:12.884900','2018-08-28 00:35:12.884900',NULL,'a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:11.743700\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:11.000000\";}','a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:12.878000\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:12.000000\";}',NULL,'https://demo.notebowl.xyz/courses/american-history--the-rol/setup/glance','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/le4acf50aaacc4d86a8ad041040cfa3d\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:72:\"https://demo.notebowl.xyz/courses/american-history--the-rol/setup/glance\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494848\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(74,3,'updated',12,32,'App\\Models\\Enrollment','nd6c1c29258394028b662472c4c34eeb','2018-08-28 00:35:14.419200','2018-08-28 00:35:14.419200',NULL,'a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:12.878000\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:12.000000\";}','a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:14.412900\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:14.000000\";}',NULL,'https://demo.notebowl.xyz/courses/american-history--the-rol/setup/import','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/le4acf50aaacc4d86a8ad041040cfa3d\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:72:\"https://demo.notebowl.xyz/courses/american-history--the-rol/setup/import\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494850\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(75,3,'updated',12,32,'App\\Models\\Enrollment','jb0253f65d64e41809a5da191cca8f01','2018-08-28 00:35:15.545100','2018-08-28 00:35:15.545100',NULL,'a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:14.412900\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:14.000000\";}','a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:15.540100\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:15.000000\";}',NULL,'https://demo.notebowl.xyz/courses/american-history--the-rol/setup/display','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/le4acf50aaacc4d86a8ad041040cfa3d\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:73:\"https://demo.notebowl.xyz/courses/american-history--the-rol/setup/display\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494851\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(76,3,'updated',12,32,'App\\Models\\Enrollment','kf57ddc71fcba475a85620d34ab90dd7','2018-08-28 00:35:16.777800','2018-08-28 00:35:16.777800',NULL,'a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:15.540100\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:15.000000\";}','a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:16.771200\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:16.000000\";}',NULL,'https://demo.notebowl.xyz/courses/american-history--the-rol/setup/scale','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/le4acf50aaacc4d86a8ad041040cfa3d\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:71:\"https://demo.notebowl.xyz/courses/american-history--the-rol/setup/scale\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494852\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(77,3,'updated',12,32,'App\\Models\\Enrollment','zd247cc4f58a74155a70b18de31b5cda','2018-08-28 00:35:17.715600','2018-08-28 00:35:17.715600',NULL,'a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:16.771200\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:16.000000\";}','a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:17.707600\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:17.000000\";}',NULL,'https://demo.notebowl.xyz/courses/american-history--the-rol/setup/books','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/le4acf50aaacc4d86a8ad041040cfa3d\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:71:\"https://demo.notebowl.xyz/courses/american-history--the-rol/setup/books\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494853\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(78,3,'updated',12,32,'App\\Models\\Enrollment','oec807026fb894c6fa812ef201d750d9','2018-08-28 00:35:18.879400','2018-08-28 00:35:18.879400',NULL,'a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:17.707600\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:17.000000\";}','a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:18.873200\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:18.000000\";}',NULL,'https://demo.notebowl.xyz/courses/american-history--the-rol/setup/final','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/le4acf50aaacc4d86a8ad041040cfa3d\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:71:\"https://demo.notebowl.xyz/courses/american-history--the-rol/setup/final\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494854\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(79,3,'updated',12,4,'App\\Models\\Course','k925d9279c08a4e0d86588cceb05f50f','2018-08-28 00:35:19.612100','2018-08-28 00:35:19.612100',NULL,'a:82:{s:2:\"id\";i:4;s:13:\"university_id\";i:1;s:7:\"term_id\";i:1;s:4:\"name\";s:53:\"American History: The Role of Politics and Government\";s:7:\"subject\";s:3:\"AMH\";s:6:\"number\";s:3:\"400\";s:9:\"permalink\";s:25:\"american-history--the-rol\";s:14:\"available_date\";s:26:\"2014-01-01 00:00:00.000000\";s:8:\"end_date\";s:26:\"2050-01-01 00:00:00.000000\";s:21:\"enrollment_close_date\";N;s:12:\"archive_date\";N;s:5:\"units\";d:0;s:19:\"use_weighted_grades\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:31:37.039100\";s:10:\"updated_at\";s:26:\"2018-08-28 00:31:37.039100\";s:12:\"resource_key\";s:32:\"le4acf50aaacc4d86a8ad041040cfa3d\";s:10:\"deleted_at\";N;s:15:\"use_drop_lowest\";b:0;s:4:\"type\";N;s:8:\"location\";N;s:11:\"description\";N;s:15:\"invite_group_id\";N;s:5:\"price\";d:0;s:29:\"download_restrict_assessments\";N;s:29:\"download_restrict_assignments\";N;s:26:\"download_restrict_bulletin\";N;s:27:\"download_restrict_documents\";N;s:29:\"download_restrict_submissions\";N;s:28:\"download_restrict_extensions\";N;s:24:\"course_tab_enabled_about\";b:1;s:28:\"course_tab_enabled_about_t_a\";b:1;s:32:\"course_tab_enabled_about_student\";b:1;s:30:\"course_tab_enabled_assignments\";b:1;s:34:\"course_tab_enabled_assignments_t_a\";b:1;s:38:\"course_tab_enabled_assignments_student\";b:1;s:28:\"course_tab_enabled_documents\";b:1;s:32:\"course_tab_enabled_documents_t_a\";b:1;s:36:\"course_tab_enabled_documents_student\";b:1;s:25:\"course_tab_enabled_grades\";b:1;s:29:\"course_tab_enabled_grades_t_a\";b:0;s:33:\"course_tab_enabled_grades_student\";b:1;s:25:\"course_tab_enabled_roster\";b:1;s:29:\"course_tab_enabled_roster_t_a\";b:1;s:33:\"course_tab_enabled_roster_student\";b:1;s:21:\"course_tab_name_about\";s:5:\"About\";s:27:\"course_tab_name_assignments\";s:11:\"Assignments\";s:25:\"course_tab_name_documents\";s:9:\"Documents\";s:22:\"course_tab_name_grades\";s:6:\"Grades\";s:22:\"course_tab_name_roster\";s:6:\"Roster\";s:24:\"course_tab_name_bulletin\";s:8:\"Bulletin\";s:14:\"points_enabled\";b:1;s:35:\"enable_student_average_grade_letter\";b:1;s:39:\"enable_student_average_grade_letter_t_a\";b:1;s:43:\"enable_student_average_grade_letter_student\";b:1;s:39:\"enable_student_average_grade_percentage\";b:1;s:43:\"enable_student_average_grade_percentage_t_a\";b:1;s:47:\"enable_student_average_grade_percentage_student\";b:1;s:35:\"enable_student_average_grade_points\";b:0;s:39:\"enable_student_average_grade_points_t_a\";b:0;s:43:\"enable_student_average_grade_points_student\";b:0;s:28:\"enable_letter_grade_override\";b:0;s:18:\"grade_scale_custom\";b:0;s:12:\"grade_scheme\";s:5:\"round\";s:10:\"grade_base\";s:7:\"percent\";s:15:\"grade_precision\";i:1;s:18:\"grade_curve_amount\";d:0;s:19:\"grade_scale_medians\";s:14:\"30;65;75;85;95\";s:18:\"grade_scale_titles\";s:9:\"F;D;C;B;A\";s:18:\"grade_scale_values\";s:13:\"0;60;70;80;90\";s:7:\"paywall\";b:0;s:9:\"published\";b:0;s:15:\"profile_picture\";N;s:13:\"pivot_user_id\";s:1:\"3\";s:15:\"pivot_parent_id\";s:1:\"4\";s:16:\"pivot_created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:16:\"pivot_updated_at\";s:26:\"2018-08-28 00:35:18.873200\";s:16:\"pivot_deleted_at\";N;s:10:\"pivot_role\";s:9:\"Professor\";s:12:\"pivot_status\";s:8:\"Accepted\";s:12:\"pivot_origin\";s:6:\"native\";s:18:\"pivot_resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:22:\"pivot_payment_required\";s:1:\"1\";}','a:72:{s:2:\"id\";i:4;s:13:\"university_id\";i:1;s:7:\"term_id\";i:1;s:4:\"name\";s:53:\"American History: The Role of Politics and Government\";s:7:\"subject\";s:3:\"AMH\";s:6:\"number\";s:3:\"400\";s:9:\"permalink\";s:25:\"american-history--the-rol\";s:14:\"available_date\";s:26:\"2014-01-01 00:00:00.000000\";s:8:\"end_date\";s:26:\"2050-01-01 00:00:00.000000\";s:21:\"enrollment_close_date\";N;s:12:\"archive_date\";N;s:5:\"units\";d:0;s:19:\"use_weighted_grades\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:31:37.039100\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:19.588900\";s:12:\"resource_key\";s:32:\"le4acf50aaacc4d86a8ad041040cfa3d\";s:10:\"deleted_at\";N;s:15:\"use_drop_lowest\";b:0;s:4:\"type\";N;s:8:\"location\";N;s:11:\"description\";N;s:15:\"invite_group_id\";N;s:5:\"price\";d:0;s:29:\"download_restrict_assessments\";N;s:29:\"download_restrict_assignments\";N;s:26:\"download_restrict_bulletin\";N;s:27:\"download_restrict_documents\";N;s:29:\"download_restrict_submissions\";N;s:28:\"download_restrict_extensions\";N;s:24:\"course_tab_enabled_about\";b:1;s:28:\"course_tab_enabled_about_t_a\";b:1;s:32:\"course_tab_enabled_about_student\";b:1;s:30:\"course_tab_enabled_assignments\";b:1;s:34:\"course_tab_enabled_assignments_t_a\";b:1;s:38:\"course_tab_enabled_assignments_student\";b:1;s:28:\"course_tab_enabled_documents\";b:1;s:32:\"course_tab_enabled_documents_t_a\";b:1;s:36:\"course_tab_enabled_documents_student\";b:1;s:25:\"course_tab_enabled_grades\";b:1;s:29:\"course_tab_enabled_grades_t_a\";b:0;s:33:\"course_tab_enabled_grades_student\";b:1;s:25:\"course_tab_enabled_roster\";b:1;s:29:\"course_tab_enabled_roster_t_a\";b:1;s:33:\"course_tab_enabled_roster_student\";b:1;s:21:\"course_tab_name_about\";s:5:\"About\";s:27:\"course_tab_name_assignments\";s:11:\"Assignments\";s:25:\"course_tab_name_documents\";s:9:\"Documents\";s:22:\"course_tab_name_grades\";s:6:\"Grades\";s:22:\"course_tab_name_roster\";s:6:\"Roster\";s:24:\"course_tab_name_bulletin\";s:8:\"Bulletin\";s:14:\"points_enabled\";b:1;s:35:\"enable_student_average_grade_letter\";b:1;s:39:\"enable_student_average_grade_letter_t_a\";b:1;s:43:\"enable_student_average_grade_letter_student\";b:1;s:39:\"enable_student_average_grade_percentage\";b:1;s:43:\"enable_student_average_grade_percentage_t_a\";b:1;s:47:\"enable_student_average_grade_percentage_student\";b:1;s:35:\"enable_student_average_grade_points\";b:0;s:39:\"enable_student_average_grade_points_t_a\";b:0;s:43:\"enable_student_average_grade_points_student\";b:0;s:28:\"enable_letter_grade_override\";b:0;s:18:\"grade_scale_custom\";b:0;s:12:\"grade_scheme\";s:5:\"round\";s:10:\"grade_base\";s:7:\"percent\";s:15:\"grade_precision\";i:1;s:18:\"grade_curve_amount\";d:0;s:19:\"grade_scale_medians\";s:14:\"30;65;75;85;95\";s:18:\"grade_scale_titles\";s:9:\"F;D;C;B;A\";s:18:\"grade_scale_values\";s:13:\"0;60;70;80;90\";s:7:\"paywall\";b:0;s:9:\"published\";b:1;s:15:\"profile_picture\";N;}',NULL,'https://demo.notebowl.xyz/courses/american-history--the-rol/setup/final','PUT','a:4:{s:9:\"published\";b:1;s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494855\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(80,3,'updated',12,32,'App\\Models\\Enrollment','c6ed6929f09c543b0bdf0386d899cafc','2018-08-28 00:35:20.237100','2018-08-28 00:35:20.237100',NULL,'a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:18.873200\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:18.000000\";}','a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:20.231200\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:20.000000\";}',NULL,'https://demo.notebowl.xyz/courses/american-history--the-rol/bulletin','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/le4acf50aaacc4d86a8ad041040cfa3d\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:68:\"https://demo.notebowl.xyz/courses/american-history--the-rol/bulletin\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494856\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(81,3,'updated',12,33,'App\\Models\\Enrollment','qfb2681d8fa7747f78bc231788c776d8','2018-08-28 00:35:22.037800','2018-08-28 00:35:22.037800',NULL,'a:13:{s:9:\"parent_id\";i:5;s:7:\"user_id\";i:3;s:2:\"id\";i:33;s:12:\"resource_key\";s:32:\"obd58aaaf121440c8afa9b47d25522af\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:32:38.218400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:32:38.218400\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";N;}','a:13:{s:9:\"parent_id\";i:5;s:7:\"user_id\";i:3;s:2:\"id\";i:33;s:12:\"resource_key\";s:32:\"obd58aaaf121440c8afa9b47d25522af\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:32:38.218400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:22.030400\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:22.000000\";}',NULL,'https://demo.notebowl.xyz/courses/google-leadership-develop/setup/begin','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/s5802ee9570f642b28342df283d297af\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:71:\"https://demo.notebowl.xyz/courses/google-leadership-develop/setup/begin\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494860\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(82,3,'updated',12,33,'App\\Models\\Enrollment','c4640bea0c5df4cd7a9d1d1e19cdff1e','2018-08-28 00:35:23.155100','2018-08-28 00:35:23.155100',NULL,'a:13:{s:9:\"parent_id\";i:5;s:7:\"user_id\";i:3;s:2:\"id\";i:33;s:12:\"resource_key\";s:32:\"obd58aaaf121440c8afa9b47d25522af\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:32:38.218400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:22.030400\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:22.000000\";}','a:13:{s:9:\"parent_id\";i:5;s:7:\"user_id\";i:3;s:2:\"id\";i:33;s:12:\"resource_key\";s:32:\"obd58aaaf121440c8afa9b47d25522af\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:32:38.218400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:23.147900\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:23.000000\";}',NULL,'https://demo.notebowl.xyz/courses/google-leadership-develop/setup/glance','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/s5802ee9570f642b28342df283d297af\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:72:\"https://demo.notebowl.xyz/courses/google-leadership-develop/setup/glance\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494862\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(83,3,'updated',12,33,'App\\Models\\Enrollment','l7e5f98927ec64f708f4b2255856093f','2018-08-28 00:35:24.434400','2018-08-28 00:35:24.434400',NULL,'a:13:{s:9:\"parent_id\";i:5;s:7:\"user_id\";i:3;s:2:\"id\";i:33;s:12:\"resource_key\";s:32:\"obd58aaaf121440c8afa9b47d25522af\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:32:38.218400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:23.147900\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:23.000000\";}','a:13:{s:9:\"parent_id\";i:5;s:7:\"user_id\";i:3;s:2:\"id\";i:33;s:12:\"resource_key\";s:32:\"obd58aaaf121440c8afa9b47d25522af\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:32:38.218400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:24.427900\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:24.000000\";}',NULL,'https://demo.notebowl.xyz/courses/google-leadership-develop/setup/import','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/s5802ee9570f642b28342df283d297af\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:72:\"https://demo.notebowl.xyz/courses/google-leadership-develop/setup/import\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494864\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(84,3,'updated',12,33,'App\\Models\\Enrollment','g817738b0feae4842b83686ef77aa3cf','2018-08-28 00:35:25.152900','2018-08-28 00:35:25.152900',NULL,'a:13:{s:9:\"parent_id\";i:5;s:7:\"user_id\";i:3;s:2:\"id\";i:33;s:12:\"resource_key\";s:32:\"obd58aaaf121440c8afa9b47d25522af\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:32:38.218400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:24.427900\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:24.000000\";}','a:13:{s:9:\"parent_id\";i:5;s:7:\"user_id\";i:3;s:2:\"id\";i:33;s:12:\"resource_key\";s:32:\"obd58aaaf121440c8afa9b47d25522af\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:32:38.218400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:25.145800\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:25.000000\";}',NULL,'https://demo.notebowl.xyz/courses/google-leadership-develop/setup/display','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/s5802ee9570f642b28342df283d297af\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:73:\"https://demo.notebowl.xyz/courses/google-leadership-develop/setup/display\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494865\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(85,3,'updated',12,33,'App\\Models\\Enrollment','ea6c48cfbce9d48289c6b72f8b487f0f','2018-08-28 00:35:26.129700','2018-08-28 00:35:26.129700',NULL,'a:13:{s:9:\"parent_id\";i:5;s:7:\"user_id\";i:3;s:2:\"id\";i:33;s:12:\"resource_key\";s:32:\"obd58aaaf121440c8afa9b47d25522af\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:32:38.218400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:25.145800\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:25.000000\";}','a:13:{s:9:\"parent_id\";i:5;s:7:\"user_id\";i:3;s:2:\"id\";i:33;s:12:\"resource_key\";s:32:\"obd58aaaf121440c8afa9b47d25522af\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:32:38.218400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:26.123300\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:26.000000\";}',NULL,'https://demo.notebowl.xyz/courses/google-leadership-develop/setup/scale','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/s5802ee9570f642b28342df283d297af\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:71:\"https://demo.notebowl.xyz/courses/google-leadership-develop/setup/scale\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494866\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(86,3,'updated',12,33,'App\\Models\\Enrollment','nf7e0c00fae2849698d97e624966dbe5','2018-08-28 00:35:27.849200','2018-08-28 00:35:27.849200',NULL,'a:13:{s:9:\"parent_id\";i:5;s:7:\"user_id\";i:3;s:2:\"id\";i:33;s:12:\"resource_key\";s:32:\"obd58aaaf121440c8afa9b47d25522af\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:32:38.218400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:26.123300\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:26.000000\";}','a:13:{s:9:\"parent_id\";i:5;s:7:\"user_id\";i:3;s:2:\"id\";i:33;s:12:\"resource_key\";s:32:\"obd58aaaf121440c8afa9b47d25522af\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:32:38.218400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:27.843000\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:27.000000\";}',NULL,'https://demo.notebowl.xyz/courses/google-leadership-develop/setup/final','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/s5802ee9570f642b28342df283d297af\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:71:\"https://demo.notebowl.xyz/courses/google-leadership-develop/setup/final\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494868\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(87,3,'updated',12,5,'App\\Models\\Course','l17140f19953245f78d54174caf8e1fc','2018-08-28 00:35:28.580300','2018-08-28 00:35:28.580300',NULL,'a:82:{s:2:\"id\";i:5;s:13:\"university_id\";i:1;s:7:\"term_id\";i:1;s:4:\"name\";s:37:\"Google Leadership Development Program\";s:7:\"subject\";s:4:\"GOOG\";s:6:\"number\";s:3:\"007\";s:9:\"permalink\";s:25:\"google-leadership-develop\";s:14:\"available_date\";s:26:\"2014-01-01 00:00:00.000000\";s:8:\"end_date\";s:26:\"2050-01-01 00:00:00.000000\";s:21:\"enrollment_close_date\";N;s:12:\"archive_date\";N;s:5:\"units\";d:0;s:19:\"use_weighted_grades\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:32:17.769300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:32:28.609900\";s:12:\"resource_key\";s:32:\"s5802ee9570f642b28342df283d297af\";s:10:\"deleted_at\";N;s:15:\"use_drop_lowest\";b:0;s:4:\"type\";N;s:8:\"location\";s:0:\"\";s:11:\"description\";s:435:\"This course is designed to hone business expertise and develop skills for a leadership position. \r\n\r\nProgram Objectives:\r\n1. Discover how experiences, beliefs and values effect our leadership style.\r\n2. Develop human potential and build relationships of mutual trust and respect.\r\n3. Create and maintain processes and procedures that drive innovation.\r\n4. Develop leadership by demonstrating effective questioning and listening skills.\";s:15:\"invite_group_id\";N;s:5:\"price\";d:0;s:29:\"download_restrict_assessments\";N;s:29:\"download_restrict_assignments\";N;s:26:\"download_restrict_bulletin\";N;s:27:\"download_restrict_documents\";N;s:29:\"download_restrict_submissions\";N;s:28:\"download_restrict_extensions\";N;s:24:\"course_tab_enabled_about\";b:1;s:28:\"course_tab_enabled_about_t_a\";b:1;s:32:\"course_tab_enabled_about_student\";b:1;s:30:\"course_tab_enabled_assignments\";b:1;s:34:\"course_tab_enabled_assignments_t_a\";b:1;s:38:\"course_tab_enabled_assignments_student\";b:1;s:28:\"course_tab_enabled_documents\";b:1;s:32:\"course_tab_enabled_documents_t_a\";b:1;s:36:\"course_tab_enabled_documents_student\";b:1;s:25:\"course_tab_enabled_grades\";b:1;s:29:\"course_tab_enabled_grades_t_a\";b:0;s:33:\"course_tab_enabled_grades_student\";b:1;s:25:\"course_tab_enabled_roster\";b:1;s:29:\"course_tab_enabled_roster_t_a\";b:1;s:33:\"course_tab_enabled_roster_student\";b:1;s:21:\"course_tab_name_about\";s:5:\"About\";s:27:\"course_tab_name_assignments\";s:11:\"Assignments\";s:25:\"course_tab_name_documents\";s:9:\"Documents\";s:22:\"course_tab_name_grades\";s:6:\"Grades\";s:22:\"course_tab_name_roster\";s:6:\"Roster\";s:24:\"course_tab_name_bulletin\";s:8:\"Bulletin\";s:14:\"points_enabled\";b:1;s:35:\"enable_student_average_grade_letter\";b:1;s:39:\"enable_student_average_grade_letter_t_a\";b:1;s:43:\"enable_student_average_grade_letter_student\";b:1;s:39:\"enable_student_average_grade_percentage\";b:1;s:43:\"enable_student_average_grade_percentage_t_a\";b:1;s:47:\"enable_student_average_grade_percentage_student\";b:1;s:35:\"enable_student_average_grade_points\";b:0;s:39:\"enable_student_average_grade_points_t_a\";b:0;s:43:\"enable_student_average_grade_points_student\";b:0;s:28:\"enable_letter_grade_override\";b:0;s:18:\"grade_scale_custom\";b:0;s:12:\"grade_scheme\";s:5:\"round\";s:10:\"grade_base\";s:7:\"percent\";s:15:\"grade_precision\";i:1;s:18:\"grade_curve_amount\";d:0;s:19:\"grade_scale_medians\";s:14:\"30;65;75;85;95\";s:18:\"grade_scale_titles\";s:9:\"F;D;C;B;A\";s:18:\"grade_scale_values\";s:13:\"0;60;70;80;90\";s:7:\"paywall\";b:0;s:9:\"published\";b:0;s:15:\"profile_picture\";N;s:13:\"pivot_user_id\";s:1:\"3\";s:15:\"pivot_parent_id\";s:1:\"5\";s:16:\"pivot_created_at\";s:26:\"2018-08-28 00:32:38.218400\";s:16:\"pivot_updated_at\";s:26:\"2018-08-28 00:35:27.843000\";s:16:\"pivot_deleted_at\";N;s:10:\"pivot_role\";s:9:\"Professor\";s:12:\"pivot_status\";s:8:\"Accepted\";s:12:\"pivot_origin\";s:6:\"native\";s:18:\"pivot_resource_key\";s:32:\"obd58aaaf121440c8afa9b47d25522af\";s:22:\"pivot_payment_required\";s:1:\"1\";}','a:72:{s:2:\"id\";i:5;s:13:\"university_id\";i:1;s:7:\"term_id\";i:1;s:4:\"name\";s:37:\"Google Leadership Development Program\";s:7:\"subject\";s:4:\"GOOG\";s:6:\"number\";s:3:\"007\";s:9:\"permalink\";s:25:\"google-leadership-develop\";s:14:\"available_date\";s:26:\"2014-01-01 00:00:00.000000\";s:8:\"end_date\";s:26:\"2050-01-01 00:00:00.000000\";s:21:\"enrollment_close_date\";N;s:12:\"archive_date\";N;s:5:\"units\";d:0;s:19:\"use_weighted_grades\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:32:17.769300\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:28.552600\";s:12:\"resource_key\";s:32:\"s5802ee9570f642b28342df283d297af\";s:10:\"deleted_at\";N;s:15:\"use_drop_lowest\";b:0;s:4:\"type\";N;s:8:\"location\";s:0:\"\";s:11:\"description\";s:435:\"This course is designed to hone business expertise and develop skills for a leadership position. \r\n\r\nProgram Objectives:\r\n1. Discover how experiences, beliefs and values effect our leadership style.\r\n2. Develop human potential and build relationships of mutual trust and respect.\r\n3. Create and maintain processes and procedures that drive innovation.\r\n4. Develop leadership by demonstrating effective questioning and listening skills.\";s:15:\"invite_group_id\";N;s:5:\"price\";d:0;s:29:\"download_restrict_assessments\";N;s:29:\"download_restrict_assignments\";N;s:26:\"download_restrict_bulletin\";N;s:27:\"download_restrict_documents\";N;s:29:\"download_restrict_submissions\";N;s:28:\"download_restrict_extensions\";N;s:24:\"course_tab_enabled_about\";b:1;s:28:\"course_tab_enabled_about_t_a\";b:1;s:32:\"course_tab_enabled_about_student\";b:1;s:30:\"course_tab_enabled_assignments\";b:1;s:34:\"course_tab_enabled_assignments_t_a\";b:1;s:38:\"course_tab_enabled_assignments_student\";b:1;s:28:\"course_tab_enabled_documents\";b:1;s:32:\"course_tab_enabled_documents_t_a\";b:1;s:36:\"course_tab_enabled_documents_student\";b:1;s:25:\"course_tab_enabled_grades\";b:1;s:29:\"course_tab_enabled_grades_t_a\";b:0;s:33:\"course_tab_enabled_grades_student\";b:1;s:25:\"course_tab_enabled_roster\";b:1;s:29:\"course_tab_enabled_roster_t_a\";b:1;s:33:\"course_tab_enabled_roster_student\";b:1;s:21:\"course_tab_name_about\";s:5:\"About\";s:27:\"course_tab_name_assignments\";s:11:\"Assignments\";s:25:\"course_tab_name_documents\";s:9:\"Documents\";s:22:\"course_tab_name_grades\";s:6:\"Grades\";s:22:\"course_tab_name_roster\";s:6:\"Roster\";s:24:\"course_tab_name_bulletin\";s:8:\"Bulletin\";s:14:\"points_enabled\";b:1;s:35:\"enable_student_average_grade_letter\";b:1;s:39:\"enable_student_average_grade_letter_t_a\";b:1;s:43:\"enable_student_average_grade_letter_student\";b:1;s:39:\"enable_student_average_grade_percentage\";b:1;s:43:\"enable_student_average_grade_percentage_t_a\";b:1;s:47:\"enable_student_average_grade_percentage_student\";b:1;s:35:\"enable_student_average_grade_points\";b:0;s:39:\"enable_student_average_grade_points_t_a\";b:0;s:43:\"enable_student_average_grade_points_student\";b:0;s:28:\"enable_letter_grade_override\";b:0;s:18:\"grade_scale_custom\";b:0;s:12:\"grade_scheme\";s:5:\"round\";s:10:\"grade_base\";s:7:\"percent\";s:15:\"grade_precision\";i:1;s:18:\"grade_curve_amount\";d:0;s:19:\"grade_scale_medians\";s:14:\"30;65;75;85;95\";s:18:\"grade_scale_titles\";s:9:\"F;D;C;B;A\";s:18:\"grade_scale_values\";s:13:\"0;60;70;80;90\";s:7:\"paywall\";b:0;s:9:\"published\";b:1;s:15:\"profile_picture\";N;}',NULL,'https://demo.notebowl.xyz/courses/google-leadership-develop/setup/final','PUT','a:4:{s:9:\"published\";b:1;s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494869\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(88,3,'updated',12,33,'App\\Models\\Enrollment','ycc694abf11544b26b1decc0ad432f24','2018-08-28 00:35:29.234100','2018-08-28 00:35:29.234100',NULL,'a:13:{s:9:\"parent_id\";i:5;s:7:\"user_id\";i:3;s:2:\"id\";i:33;s:12:\"resource_key\";s:32:\"obd58aaaf121440c8afa9b47d25522af\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:32:38.218400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:27.843000\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:27.000000\";}','a:13:{s:9:\"parent_id\";i:5;s:7:\"user_id\";i:3;s:2:\"id\";i:33;s:12:\"resource_key\";s:32:\"obd58aaaf121440c8afa9b47d25522af\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:32:38.218400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:29.227700\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:29.000000\";}',NULL,'https://demo.notebowl.xyz/courses/google-leadership-develop/bulletin','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/s5802ee9570f642b28342df283d297af\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:68:\"https://demo.notebowl.xyz/courses/google-leadership-develop/bulletin\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494870\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(89,3,'updated',12,34,'App\\Models\\Enrollment','s383062f75f9c403abc452c34111165c','2018-08-28 00:35:30.456900','2018-08-28 00:35:30.456900',NULL,'a:13:{s:9:\"parent_id\";i:6;s:7:\"user_id\";i:3;s:2:\"id\";i:34;s:12:\"resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"updated_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";N;}','a:13:{s:9:\"parent_id\";i:6;s:7:\"user_id\";i:3;s:2:\"id\";i:34;s:12:\"resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:30.451500\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:30.000000\";}',NULL,'https://demo.notebowl.xyz/courses/mission-to-mars/setup/begin','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/d4f7a84149dff4e92a9180d8d97bdd1c\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:61:\"https://demo.notebowl.xyz/courses/mission-to-mars/setup/begin\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494874\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(90,3,'updated',12,34,'App\\Models\\Enrollment','h2023fc5b72664ca686f9b6fe8865a99','2018-08-28 00:35:31.742800','2018-08-28 00:35:31.742800',NULL,'a:13:{s:9:\"parent_id\";i:6;s:7:\"user_id\";i:3;s:2:\"id\";i:34;s:12:\"resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:30.451500\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:30.000000\";}','a:13:{s:9:\"parent_id\";i:6;s:7:\"user_id\";i:3;s:2:\"id\";i:34;s:12:\"resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:31.736600\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:31.000000\";}',NULL,'https://demo.notebowl.xyz/courses/mission-to-mars/setup/glance','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/d4f7a84149dff4e92a9180d8d97bdd1c\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:62:\"https://demo.notebowl.xyz/courses/mission-to-mars/setup/glance\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494876\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(91,3,'updated',12,34,'App\\Models\\Enrollment','f0cff185fc4f84c0cae428dd4ef0bab9','2018-08-28 00:35:32.841500','2018-08-28 00:35:32.841500',NULL,'a:13:{s:9:\"parent_id\";i:6;s:7:\"user_id\";i:3;s:2:\"id\";i:34;s:12:\"resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:31.736600\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:31.000000\";}','a:13:{s:9:\"parent_id\";i:6;s:7:\"user_id\";i:3;s:2:\"id\";i:34;s:12:\"resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:32.833500\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:32.000000\";}',NULL,'https://demo.notebowl.xyz/courses/mission-to-mars/setup/import','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/d4f7a84149dff4e92a9180d8d97bdd1c\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:62:\"https://demo.notebowl.xyz/courses/mission-to-mars/setup/import\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494878\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(92,3,'updated',12,34,'App\\Models\\Enrollment','decc9651cb1ff404b95ba33b072669f5','2018-08-28 00:35:33.562400','2018-08-28 00:35:33.562400',NULL,'a:13:{s:9:\"parent_id\";i:6;s:7:\"user_id\";i:3;s:2:\"id\";i:34;s:12:\"resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:32.833500\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:32.000000\";}','a:13:{s:9:\"parent_id\";i:6;s:7:\"user_id\";i:3;s:2:\"id\";i:34;s:12:\"resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:33.555000\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:33.000000\";}',NULL,'https://demo.notebowl.xyz/courses/mission-to-mars/setup/display','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/d4f7a84149dff4e92a9180d8d97bdd1c\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:63:\"https://demo.notebowl.xyz/courses/mission-to-mars/setup/display\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494879\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(93,3,'updated',12,34,'App\\Models\\Enrollment','ud3f58cba734143b1a7152bf6afa60f9','2018-08-28 00:35:34.617300','2018-08-28 00:35:34.617300',NULL,'a:13:{s:9:\"parent_id\";i:6;s:7:\"user_id\";i:3;s:2:\"id\";i:34;s:12:\"resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:33.555000\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:33.000000\";}','a:13:{s:9:\"parent_id\";i:6;s:7:\"user_id\";i:3;s:2:\"id\";i:34;s:12:\"resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:34.612200\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:34.000000\";}',NULL,'https://demo.notebowl.xyz/courses/mission-to-mars/setup/scale','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/d4f7a84149dff4e92a9180d8d97bdd1c\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:61:\"https://demo.notebowl.xyz/courses/mission-to-mars/setup/scale\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494880\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(94,3,'updated',12,34,'App\\Models\\Enrollment','a832de6921ac54877b4bf2f9a1796457','2018-08-28 00:35:35.660000','2018-08-28 00:35:35.660000',NULL,'a:13:{s:9:\"parent_id\";i:6;s:7:\"user_id\";i:3;s:2:\"id\";i:34;s:12:\"resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:34.612200\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:34.000000\";}','a:13:{s:9:\"parent_id\";i:6;s:7:\"user_id\";i:3;s:2:\"id\";i:34;s:12:\"resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:35.653800\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:35.000000\";}',NULL,'https://demo.notebowl.xyz/courses/mission-to-mars/setup/books','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/d4f7a84149dff4e92a9180d8d97bdd1c\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:61:\"https://demo.notebowl.xyz/courses/mission-to-mars/setup/books\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494881\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(95,3,'updated',12,34,'App\\Models\\Enrollment','i9e61d4697ad04ba6bccd25083cd136c','2018-08-28 00:35:37.429000','2018-08-28 00:35:37.429000',NULL,'a:13:{s:9:\"parent_id\";i:6;s:7:\"user_id\";i:3;s:2:\"id\";i:34;s:12:\"resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:35.653800\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:35.000000\";}','a:13:{s:9:\"parent_id\";i:6;s:7:\"user_id\";i:3;s:2:\"id\";i:34;s:12:\"resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:37.422500\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:37.000000\";}',NULL,'https://demo.notebowl.xyz/courses/mission-to-mars/setup/final','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/d4f7a84149dff4e92a9180d8d97bdd1c\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:61:\"https://demo.notebowl.xyz/courses/mission-to-mars/setup/final\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494882\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(96,3,'updated',12,6,'App\\Models\\Course','f2f624cadbcb940c2b65edcfd8dda4f4','2018-08-28 00:35:38.287200','2018-08-28 00:35:38.287200',NULL,'a:82:{s:2:\"id\";i:6;s:13:\"university_id\";i:1;s:7:\"term_id\";i:1;s:4:\"name\";s:15:\"Mission to Mars\";s:7:\"subject\";s:5:\"SPACE\";s:6:\"number\";s:3:\"100\";s:9:\"permalink\";s:15:\"mission-to-mars\";s:14:\"available_date\";s:26:\"2014-01-01 00:00:00.000000\";s:8:\"end_date\";s:26:\"2050-01-01 00:00:00.000000\";s:21:\"enrollment_close_date\";N;s:12:\"archive_date\";N;s:5:\"units\";d:0;s:19:\"use_weighted_grades\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:33:06.264900\";s:10:\"updated_at\";s:26:\"2018-08-28 00:33:06.264900\";s:12:\"resource_key\";s:32:\"d4f7a84149dff4e92a9180d8d97bdd1c\";s:10:\"deleted_at\";N;s:15:\"use_drop_lowest\";b:0;s:4:\"type\";N;s:8:\"location\";N;s:11:\"description\";N;s:15:\"invite_group_id\";N;s:5:\"price\";d:0;s:29:\"download_restrict_assessments\";N;s:29:\"download_restrict_assignments\";N;s:26:\"download_restrict_bulletin\";N;s:27:\"download_restrict_documents\";N;s:29:\"download_restrict_submissions\";N;s:28:\"download_restrict_extensions\";N;s:24:\"course_tab_enabled_about\";b:1;s:28:\"course_tab_enabled_about_t_a\";b:1;s:32:\"course_tab_enabled_about_student\";b:1;s:30:\"course_tab_enabled_assignments\";b:1;s:34:\"course_tab_enabled_assignments_t_a\";b:1;s:38:\"course_tab_enabled_assignments_student\";b:1;s:28:\"course_tab_enabled_documents\";b:1;s:32:\"course_tab_enabled_documents_t_a\";b:1;s:36:\"course_tab_enabled_documents_student\";b:1;s:25:\"course_tab_enabled_grades\";b:1;s:29:\"course_tab_enabled_grades_t_a\";b:0;s:33:\"course_tab_enabled_grades_student\";b:1;s:25:\"course_tab_enabled_roster\";b:1;s:29:\"course_tab_enabled_roster_t_a\";b:1;s:33:\"course_tab_enabled_roster_student\";b:1;s:21:\"course_tab_name_about\";s:5:\"About\";s:27:\"course_tab_name_assignments\";s:11:\"Assignments\";s:25:\"course_tab_name_documents\";s:9:\"Documents\";s:22:\"course_tab_name_grades\";s:6:\"Grades\";s:22:\"course_tab_name_roster\";s:6:\"Roster\";s:24:\"course_tab_name_bulletin\";s:8:\"Bulletin\";s:14:\"points_enabled\";b:1;s:35:\"enable_student_average_grade_letter\";b:1;s:39:\"enable_student_average_grade_letter_t_a\";b:1;s:43:\"enable_student_average_grade_letter_student\";b:1;s:39:\"enable_student_average_grade_percentage\";b:1;s:43:\"enable_student_average_grade_percentage_t_a\";b:1;s:47:\"enable_student_average_grade_percentage_student\";b:1;s:35:\"enable_student_average_grade_points\";b:0;s:39:\"enable_student_average_grade_points_t_a\";b:0;s:43:\"enable_student_average_grade_points_student\";b:0;s:28:\"enable_letter_grade_override\";b:0;s:18:\"grade_scale_custom\";b:0;s:12:\"grade_scheme\";s:5:\"round\";s:10:\"grade_base\";s:7:\"percent\";s:15:\"grade_precision\";i:1;s:18:\"grade_curve_amount\";d:0;s:19:\"grade_scale_medians\";s:14:\"30;65;75;85;95\";s:18:\"grade_scale_titles\";s:9:\"F;D;C;B;A\";s:18:\"grade_scale_values\";s:13:\"0;60;70;80;90\";s:7:\"paywall\";b:0;s:9:\"published\";b:0;s:15:\"profile_picture\";N;s:13:\"pivot_user_id\";s:1:\"3\";s:15:\"pivot_parent_id\";s:1:\"6\";s:16:\"pivot_created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:16:\"pivot_updated_at\";s:26:\"2018-08-28 00:35:37.422500\";s:16:\"pivot_deleted_at\";N;s:10:\"pivot_role\";s:9:\"Professor\";s:12:\"pivot_status\";s:8:\"Accepted\";s:12:\"pivot_origin\";s:6:\"native\";s:18:\"pivot_resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:22:\"pivot_payment_required\";s:1:\"1\";}','a:72:{s:2:\"id\";i:6;s:13:\"university_id\";i:1;s:7:\"term_id\";i:1;s:4:\"name\";s:15:\"Mission to Mars\";s:7:\"subject\";s:5:\"SPACE\";s:6:\"number\";s:3:\"100\";s:9:\"permalink\";s:15:\"mission-to-mars\";s:14:\"available_date\";s:26:\"2014-01-01 00:00:00.000000\";s:8:\"end_date\";s:26:\"2050-01-01 00:00:00.000000\";s:21:\"enrollment_close_date\";N;s:12:\"archive_date\";N;s:5:\"units\";d:0;s:19:\"use_weighted_grades\";b:0;s:10:\"created_at\";s:26:\"2018-08-28 00:33:06.264900\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:38.262000\";s:12:\"resource_key\";s:32:\"d4f7a84149dff4e92a9180d8d97bdd1c\";s:10:\"deleted_at\";N;s:15:\"use_drop_lowest\";b:0;s:4:\"type\";N;s:8:\"location\";N;s:11:\"description\";N;s:15:\"invite_group_id\";N;s:5:\"price\";d:0;s:29:\"download_restrict_assessments\";N;s:29:\"download_restrict_assignments\";N;s:26:\"download_restrict_bulletin\";N;s:27:\"download_restrict_documents\";N;s:29:\"download_restrict_submissions\";N;s:28:\"download_restrict_extensions\";N;s:24:\"course_tab_enabled_about\";b:1;s:28:\"course_tab_enabled_about_t_a\";b:1;s:32:\"course_tab_enabled_about_student\";b:1;s:30:\"course_tab_enabled_assignments\";b:1;s:34:\"course_tab_enabled_assignments_t_a\";b:1;s:38:\"course_tab_enabled_assignments_student\";b:1;s:28:\"course_tab_enabled_documents\";b:1;s:32:\"course_tab_enabled_documents_t_a\";b:1;s:36:\"course_tab_enabled_documents_student\";b:1;s:25:\"course_tab_enabled_grades\";b:1;s:29:\"course_tab_enabled_grades_t_a\";b:0;s:33:\"course_tab_enabled_grades_student\";b:1;s:25:\"course_tab_enabled_roster\";b:1;s:29:\"course_tab_enabled_roster_t_a\";b:1;s:33:\"course_tab_enabled_roster_student\";b:1;s:21:\"course_tab_name_about\";s:5:\"About\";s:27:\"course_tab_name_assignments\";s:11:\"Assignments\";s:25:\"course_tab_name_documents\";s:9:\"Documents\";s:22:\"course_tab_name_grades\";s:6:\"Grades\";s:22:\"course_tab_name_roster\";s:6:\"Roster\";s:24:\"course_tab_name_bulletin\";s:8:\"Bulletin\";s:14:\"points_enabled\";b:1;s:35:\"enable_student_average_grade_letter\";b:1;s:39:\"enable_student_average_grade_letter_t_a\";b:1;s:43:\"enable_student_average_grade_letter_student\";b:1;s:39:\"enable_student_average_grade_percentage\";b:1;s:43:\"enable_student_average_grade_percentage_t_a\";b:1;s:47:\"enable_student_average_grade_percentage_student\";b:1;s:35:\"enable_student_average_grade_points\";b:0;s:39:\"enable_student_average_grade_points_t_a\";b:0;s:43:\"enable_student_average_grade_points_student\";b:0;s:28:\"enable_letter_grade_override\";b:0;s:18:\"grade_scale_custom\";b:0;s:12:\"grade_scheme\";s:5:\"round\";s:10:\"grade_base\";s:7:\"percent\";s:15:\"grade_precision\";i:1;s:18:\"grade_curve_amount\";d:0;s:19:\"grade_scale_medians\";s:14:\"30;65;75;85;95\";s:18:\"grade_scale_titles\";s:9:\"F;D;C;B;A\";s:18:\"grade_scale_values\";s:13:\"0;60;70;80;90\";s:7:\"paywall\";b:0;s:9:\"published\";b:1;s:15:\"profile_picture\";N;}',NULL,'https://demo.notebowl.xyz/courses/mission-to-mars/setup/final','PUT','a:4:{s:9:\"published\";b:1;s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494883\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(97,3,'updated',12,34,'App\\Models\\Enrollment','u589e8b287f5b4400bb84f52963f4949','2018-08-28 00:35:38.848500','2018-08-28 00:35:38.848500',NULL,'a:13:{s:9:\"parent_id\";i:6;s:7:\"user_id\";i:3;s:2:\"id\";i:34;s:12:\"resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:37.422500\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:37.000000\";}','a:13:{s:9:\"parent_id\";i:6;s:7:\"user_id\";i:3;s:2:\"id\";i:34;s:12:\"resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:38.841500\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:38.000000\";}',NULL,'https://demo.notebowl.xyz/courses/mission-to-mars/bulletin','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/d4f7a84149dff4e92a9180d8d97bdd1c\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:58:\"https://demo.notebowl.xyz/courses/mission-to-mars/bulletin\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494884\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(98,3,'updated',12,32,'App\\Models\\Enrollment','pd92e520b1e48425aba3d17f398f152c','2018-08-28 00:35:41.595000','2018-08-28 00:35:41.595000',NULL,'a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:20.231200\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:20.000000\";}','a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:41.588600\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:41.000000\";}',NULL,'https://demo.notebowl.xyz/courses/american-history--the-rol/bulletin','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/le4acf50aaacc4d86a8ad041040cfa3d\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:68:\"https://demo.notebowl.xyz/courses/american-history--the-rol/bulletin\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494888\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(99,3,'updated',12,34,'App\\Models\\Enrollment','s8287f6b38eba47c49bfaae061131e3b','2018-08-28 00:35:44.714600','2018-08-28 00:35:44.714600',NULL,'a:13:{s:9:\"parent_id\";i:6;s:7:\"user_id\";i:3;s:2:\"id\";i:34;s:12:\"resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:38.841500\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:38.000000\";}','a:13:{s:9:\"parent_id\";i:6;s:7:\"user_id\";i:3;s:2:\"id\";i:34;s:12:\"resource_key\";s:32:\"yb1f56e05de0b4d0fa9947708cafb791\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:33:18.675000\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:44.707700\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:44.000000\";}',NULL,'https://demo.notebowl.xyz/courses/mission-to-mars/bulletin','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/d4f7a84149dff4e92a9180d8d97bdd1c\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:58:\"https://demo.notebowl.xyz/courses/mission-to-mars/bulletin\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494889\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(100,3,'updated',12,32,'App\\Models\\Enrollment','o3b60c354d1984153b4476c287e35626','2018-08-28 00:35:46.401000','2018-08-28 00:35:46.401000',NULL,'a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:41.588600\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:41.000000\";}','a:13:{s:9:\"parent_id\";i:4;s:7:\"user_id\";i:3;s:2:\"id\";i:32;s:12:\"resource_key\";s:32:\"j521e4337397c4b2484eabf265e314cd\";s:6:\"origin\";s:6:\"native\";s:10:\"created_at\";s:26:\"2018-08-28 00:31:51.672400\";s:10:\"updated_at\";s:26:\"2018-08-28 00:35:46.394000\";s:10:\"deleted_at\";N;s:4:\"role\";s:9:\"Professor\";s:6:\"status\";s:8:\"Accepted\";s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:16:\"payment_required\";b:1;s:14:\"last_access_at\";s:26:\"2018-08-28 00:35:46.000000\";}',NULL,'https://demo.notebowl.xyz/courses/american-history--the-rol/bulletin','POST','a:7:{s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/le4acf50aaacc4d86a8ad041040cfa3d\";s:6:\"source\";s:3:\"web\";s:4:\"type\";s:10:\"navigation\";s:7:\"viewUrl\";s:68:\"https://demo.notebowl.xyz/courses/american-history--the-rol/bulletin\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494890\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}'),
	(101,3,'created',12,6,'App\\Models\\Post','gca369096257d40b1a59911dfa5b26d9','2018-08-28 00:35:54.182300','2018-08-28 00:35:54.182300',NULL,'a:0:{}','a:15:{s:12:\"resource_key\";s:32:\"tcc103f3018c9471caae122e1b4630c0\";s:9:\"parent_id\";i:4;s:11:\"parent_type\";s:17:\"App\\Models\\Course\";s:7:\"user_id\";i:3;s:8:\"owner_id\";i:4;s:10:\"owner_type\";s:17:\"App\\Models\\Course\";s:10:\"related_id\";i:4;s:12:\"related_type\";s:17:\"App\\Models\\Course\";s:14:\"available_date\";s:26:\"2018-08-28 00:35:52.000000\";s:4:\"text\";s:141:\"Hi Class! Let\'s expand on our lecture from earlier today, how does social media impact politics and the news? What\'s a great example of this?\";s:9:\"anonymous\";b:0;s:6:\"pinned\";b:0;s:10:\"updated_at\";s:26:\"2018-08-28 00:35:54.170800\";s:10:\"created_at\";s:26:\"2018-08-28 00:35:54.170800\";s:2:\"id\";i:6;}',NULL,'https://demo.notebowl.xyz/bulletin','POST','a:11:{s:11:\"isAnonymous\";b:0;s:6:\"pinned\";b:0;s:7:\"_parent\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/le4acf50aaacc4d86a8ad041040cfa3d\";s:8:\"_creator\";s:73:\"https://demo.notebowl.xyz/api/v1.0/users/d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";s:13:\"availableDate\";b:1;s:4:\"text\";s:141:\"Hi Class! Let\'s expand on our lecture from earlier today, how does social media impact politics and the news? What\'s a great example of this?\";s:6:\"_owner\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/le4acf50aaacc4d86a8ad041040cfa3d\";s:8:\"_related\";s:75:\"https://demo.notebowl.xyz/api/v1.0/courses/le4acf50aaacc4d86a8ad041040cfa3d\";s:4:\"__sK\";s:26:\"1535416494756-0.hzjxh8iuxc\";s:4:\"__rK\";s:13:\"1535416494892\";s:4:\"__uK\";s:32:\"d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ\";}');

/*!40000 ALTER TABLE `activity_logs` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table analytics
# ------------------------------------------------------------

DROP TABLE IF EXISTS `analytics`;

CREATE TABLE `analytics` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `source` enum('web','email') NOT NULL DEFAULT 'web',
  `type` enum('click','navigation') NOT NULL DEFAULT 'click',
  `view_url` varchar(190) DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `resource_key` varchar(32) NOT NULL,
  `parent_id` int(10) unsigned NOT NULL,
  `parent_type` varchar(190) NOT NULL,
  `user_session_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `analytics_resource_key_unique` (`resource_key`),
  KEY `analytics_parent_id_parent_type_index` (`parent_id`,`parent_type`),
  KEY `analytics_user_id_index` (`user_id`),
  KEY `analytics_user_session_id_index` (`user_session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `analytics` WRITE;
/*!40000 ALTER TABLE `analytics` DISABLE KEYS */;

INSERT INTO `analytics` (`id`, `source`, `type`, `view_url`, `user_id`, `created_at`, `updated_at`, `deleted_at`, `resource_key`, `parent_id`, `parent_type`, `user_session_id`)
VALUES
	(1,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/begin',1,'2018-08-28 00:06:31.720000','2018-08-28 00:06:31.720000',NULL,'ye9b1e1b5218940e189e6b296a717832',3,'App\\Models\\Course',2),
	(2,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/glance',1,'2018-08-28 00:06:32.903800','2018-08-28 00:06:32.903800',NULL,'y65717da12fe8412db3a0008f689db1b',3,'App\\Models\\Course',2),
	(3,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/import',1,'2018-08-28 00:06:36.735500','2018-08-28 00:06:36.735500',NULL,'g7fab02ef0be843068f20193d54e49e8',3,'App\\Models\\Course',2),
	(4,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/display',1,'2018-08-28 00:06:40.385300','2018-08-28 00:06:40.385300',NULL,'v2ba4867a07044aca828e46445a91ebc',3,'App\\Models\\Course',2),
	(5,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/scale',1,'2018-08-28 00:06:42.114000','2018-08-28 00:06:42.114000',NULL,'j6bc40034726a4ddf848974a3759d6b9',3,'App\\Models\\Course',2),
	(6,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/books',1,'2018-08-28 00:06:43.238700','2018-08-28 00:06:43.238700',NULL,'v243377b596054307b5a1db98eb04b20',3,'App\\Models\\Course',2),
	(7,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/setup/final',1,'2018-08-28 00:06:44.344700','2018-08-28 00:06:44.344700',NULL,'g7df80727e2524e67b7ca10ffdaacd81',3,'App\\Models\\Course',2),
	(8,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/bulletin',1,'2018-08-28 00:06:45.942100','2018-08-28 00:06:45.942100',NULL,'k3ac392be8c9f4c9dbb304b944320ba6',3,'App\\Models\\Course',2),
	(9,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/roster',1,'2018-08-28 00:06:49.241600','2018-08-28 00:06:49.241600',NULL,'p0da9ac5b6a2d470398462d8adfa9137',3,'App\\Models\\Course',2),
	(10,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/about',1,'2018-08-28 00:07:42.607100','2018-08-28 00:07:42.607100',NULL,'l0701dd44a9a341058f93ae2209ba30e',3,'App\\Models\\Course',2),
	(11,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/bulletin',1,'2018-08-28 00:07:47.165300','2018-08-28 00:07:47.165300',NULL,'r3eb7be0d0b944397a10bdb498c5964f',3,'App\\Models\\Course',2),
	(12,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/roster',1,'2018-08-28 00:13:50.260799','2018-08-28 00:13:50.260799',NULL,'t403687ad811d4a169717a1024211d38',3,'App\\Models\\Course',2),
	(13,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/bulletin',1,'2018-08-28 00:14:42.578400','2018-08-28 00:14:42.578400',NULL,'q5bf7f68c5bcd4937a19f029d39037b9',3,'App\\Models\\Course',2),
	(14,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments',1,'2018-08-28 00:14:45.518300','2018-08-28 00:14:45.518300',NULL,'rf3e9e1b9642d4a3f98d0a2ab4e30002',3,'App\\Models\\Course',2),
	(15,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/space-freefall-discussion/submissions',1,'2018-08-28 00:16:00.461900','2018-08-28 00:16:00.461900',NULL,'s7b46d3383459454ea6c2732a72dc2af',3,'App\\Models\\Course',2),
	(16,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/space-freefall-discussion/submissions',1,'2018-08-28 00:16:01.350800','2018-08-28 00:16:01.350800',NULL,'s0bfad5a6600a4045abd74f4c8834054',2,'App\\Models\\Assignment',2),
	(17,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments',1,'2018-08-28 00:16:10.278900','2018-08-28 00:16:10.278900',NULL,'b092e95d5e21f4e47ab5e803489b0932',3,'App\\Models\\Course',2),
	(18,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/lunar-travel-topic-paper/submissions/students',1,'2018-08-28 00:16:47.802300','2018-08-28 00:16:47.802300',NULL,'sdb31a1106f96455c9b96919a626950a',3,'App\\Models\\Course',2),
	(19,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/lunar-travel-topic-paper/submissions/students',1,'2018-08-28 00:16:48.758700','2018-08-28 00:16:48.758700',NULL,'w24a8c52a869f45c28e2233b49e4314e',3,'App\\Models\\Assignment',2),
	(20,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments',1,'2018-08-28 00:16:54.330700','2018-08-28 00:16:54.330700',NULL,'ja6f2413acddc472f8646fee9366682d',3,'App\\Models\\Course',2),
	(21,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/group-overnight-starwatch/submissions/groups',1,'2018-08-28 00:18:19.971500','2018-08-28 00:18:19.971500',NULL,'h049433a491d8474c922bffbf2d767a4',3,'App\\Models\\Course',2),
	(22,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/group-overnight-starwatch/submissions/groups',1,'2018-08-28 00:18:21.936400','2018-08-28 00:18:21.936400',NULL,'p9942d3a1081c42799dd54fa6255ab7b',4,'App\\Models\\Assignment',2),
	(23,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments',1,'2018-08-28 00:18:27.414800','2018-08-28 00:18:27.414800',NULL,'baca96d607d78466d84c071a4aed14a1',3,'App\\Models\\Course',2),
	(24,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/the-night-sky-quiz/submissions/students',1,'2018-08-28 00:19:01.864600','2018-08-28 00:19:01.864600',NULL,'cd6d516f11de4463dab6f26baa8e983e',3,'App\\Models\\Course',2),
	(25,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/the-night-sky-quiz/submissions/students',1,'2018-08-28 00:19:02.605300','2018-08-28 00:19:02.605300',NULL,'d693a7a39421e41e08ea33f6221ca618',5,'App\\Models\\Assignment',2),
	(26,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments',1,'2018-08-28 00:19:13.454100','2018-08-28 00:19:13.454100',NULL,'e4111bcadd2b94e5e931f7c7269ca8ae',3,'App\\Models\\Course',2),
	(27,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/intro-to-astronomy-exam/submissions/students',1,'2018-08-28 00:19:56.456900','2018-08-28 00:19:56.456900',NULL,'j0601c2fa0c304f378d65eb019e4c692',3,'App\\Models\\Course',2),
	(28,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/intro-to-astronomy-exam/submissions/students',1,'2018-08-28 00:19:57.150300','2018-08-28 00:19:57.150300',NULL,'tb00ee7a3f8f34358ac8182959437f06',6,'App\\Models\\Assignment',2),
	(29,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments',1,'2018-08-28 00:19:58.923400','2018-08-28 00:19:58.923400',NULL,'w3e79986aa029421b867f63b2ce7fca1',3,'App\\Models\\Course',2),
	(30,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/mission-to-mars/submissions/students',1,'2018-08-28 00:20:30.854400','2018-08-28 00:20:30.854400',NULL,'b4e003bf99ca74b1db22c46e48495e04',3,'App\\Models\\Course',2),
	(31,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments/mission-to-mars/submissions/students',1,'2018-08-28 00:20:31.531900','2018-08-28 00:20:31.531900',NULL,'ob8835ac01cac4ed3ab354d2af8a06a0',7,'App\\Models\\Assignment',2),
	(32,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments',1,'2018-08-28 00:20:38.368200','2018-08-28 00:20:38.368200',NULL,'b70c99e6f30ce43ceb6e03c15e0a4cbf',3,'App\\Models\\Course',2),
	(33,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/documents',1,'2018-08-28 00:20:41.459900','2018-08-28 00:20:41.459900',NULL,'m5d5b4981940e4941994be2905225be9',3,'App\\Models\\Course',2),
	(34,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/assignments',1,'2018-08-28 00:20:43.547000','2018-08-28 00:20:43.547000',NULL,'rb2f190c77733413b83dae301476a267',3,'App\\Models\\Course',2),
	(35,'web','navigation','https://demo.notebowl.xyz/courses/astronomy--exploring-time/bulletin',1,'2018-08-28 00:20:50.723500','2018-08-28 00:20:50.723500',NULL,'f124573e631ec4af9b42db18b99d6aac',3,'App\\Models\\Course',2),
	(36,'web','navigation','https://demo.notebowl.xyz/courses/american-history--the-rol/setup/begin',3,'2018-08-28 00:35:11.729900','2018-08-28 00:35:11.729900',NULL,'j094edaead00f452680c11ec746813f1',4,'App\\Models\\Course',12),
	(37,'web','navigation','https://demo.notebowl.xyz/courses/american-history--the-rol/setup/glance',3,'2018-08-28 00:35:12.867200','2018-08-28 00:35:12.867200',NULL,'xad49cab4cb6d4e6b9d03ace03461e56',4,'App\\Models\\Course',12),
	(38,'web','navigation','https://demo.notebowl.xyz/courses/american-history--the-rol/setup/import',3,'2018-08-28 00:35:14.399700','2018-08-28 00:35:14.399700',NULL,'nff36a883f9904906bfabb9c93b4040d',4,'App\\Models\\Course',12),
	(39,'web','navigation','https://demo.notebowl.xyz/courses/american-history--the-rol/setup/display',3,'2018-08-28 00:35:15.526300','2018-08-28 00:35:15.526300',NULL,'d3ef8cc2cfb67418db58d4c84fc61200',4,'App\\Models\\Course',12),
	(40,'web','navigation','https://demo.notebowl.xyz/courses/american-history--the-rol/setup/scale',3,'2018-08-28 00:35:16.754300','2018-08-28 00:35:16.754300',NULL,'c92f106be4e754026a72fba85c1ad4cd',4,'App\\Models\\Course',12),
	(41,'web','navigation','https://demo.notebowl.xyz/courses/american-history--the-rol/setup/books',3,'2018-08-28 00:35:17.697400','2018-08-28 00:35:17.697400',NULL,'j6fdc806a0d6a4f179c07609e39f6396',4,'App\\Models\\Course',12),
	(42,'web','navigation','https://demo.notebowl.xyz/courses/american-history--the-rol/setup/final',3,'2018-08-28 00:35:18.862400','2018-08-28 00:35:18.862400',NULL,'je7f336d2f96944b19892a0646e0c7ac',4,'App\\Models\\Course',12),
	(43,'web','navigation','https://demo.notebowl.xyz/courses/american-history--the-rol/bulletin',3,'2018-08-28 00:35:20.220700','2018-08-28 00:35:20.220700',NULL,'jd9acf6ab2bfd4646a768ca03f889a94',4,'App\\Models\\Course',12),
	(44,'web','navigation','https://demo.notebowl.xyz/courses/google-leadership-develop/setup/begin',3,'2018-08-28 00:35:22.011700','2018-08-28 00:35:22.011700',NULL,'o143ed9b40257483dbbd5608424612d7',5,'App\\Models\\Course',12),
	(45,'web','navigation','https://demo.notebowl.xyz/courses/google-leadership-develop/setup/glance',3,'2018-08-28 00:35:23.138300','2018-08-28 00:35:23.138300',NULL,'z9bdf6b898a244ad9a66638ab9156231',5,'App\\Models\\Course',12),
	(46,'web','navigation','https://demo.notebowl.xyz/courses/google-leadership-develop/setup/import',3,'2018-08-28 00:35:24.415600','2018-08-28 00:35:24.415600',NULL,'zfb4fee01454f4e5c874529cddb012d3',5,'App\\Models\\Course',12),
	(47,'web','navigation','https://demo.notebowl.xyz/courses/google-leadership-develop/setup/display',3,'2018-08-28 00:35:25.133700','2018-08-28 00:35:25.133700',NULL,'pd89339924b3d4127a26c47333228c3d',5,'App\\Models\\Course',12),
	(48,'web','navigation','https://demo.notebowl.xyz/courses/google-leadership-develop/setup/scale',3,'2018-08-28 00:35:26.111900','2018-08-28 00:35:26.111900',NULL,'j34ef05ee860a4dbb9d0c0c9cd488a74',5,'App\\Models\\Course',12),
	(49,'web','navigation','https://demo.notebowl.xyz/courses/google-leadership-develop/setup/books',3,'2018-08-28 00:35:26.978400','2018-08-28 00:35:26.978400',NULL,'h755d0f657a9b4b148f2862020b0f713',5,'App\\Models\\Course',12),
	(50,'web','navigation','https://demo.notebowl.xyz/courses/google-leadership-develop/setup/final',3,'2018-08-28 00:35:27.831700','2018-08-28 00:35:27.831700',NULL,'sfb08dca4b2864df8aceb7d6f0e1126d',5,'App\\Models\\Course',12),
	(51,'web','navigation','https://demo.notebowl.xyz/courses/google-leadership-develop/bulletin',3,'2018-08-28 00:35:29.216600','2018-08-28 00:35:29.216600',NULL,'i0232537fe9074c52806d7108e1c2e4d',5,'App\\Models\\Course',12),
	(52,'web','navigation','https://demo.notebowl.xyz/courses/mission-to-mars/setup/begin',3,'2018-08-28 00:35:30.439400','2018-08-28 00:35:30.439400',NULL,'r0922d88d8f0c4695a817f717a950f41',6,'App\\Models\\Course',12),
	(53,'web','navigation','https://demo.notebowl.xyz/courses/mission-to-mars/setup/glance',3,'2018-08-28 00:35:31.725600','2018-08-28 00:35:31.725600',NULL,'jdaa64eefe88f42fdbcb753cf51bd367',6,'App\\Models\\Course',12),
	(54,'web','navigation','https://demo.notebowl.xyz/courses/mission-to-mars/setup/import',3,'2018-08-28 00:35:32.821600','2018-08-28 00:35:32.821600',NULL,'jc8e0ee815ebf463487de2d3182df009',6,'App\\Models\\Course',12),
	(55,'web','navigation','https://demo.notebowl.xyz/courses/mission-to-mars/setup/display',3,'2018-08-28 00:35:33.544400','2018-08-28 00:35:33.544400',NULL,'jb3b5ca7fd39e402caa02cf45c5fa1cd',6,'App\\Models\\Course',12),
	(56,'web','navigation','https://demo.notebowl.xyz/courses/mission-to-mars/setup/scale',3,'2018-08-28 00:35:34.601000','2018-08-28 00:35:34.601000',NULL,'p403874b221164863be0da08a49a6f90',6,'App\\Models\\Course',12),
	(57,'web','navigation','https://demo.notebowl.xyz/courses/mission-to-mars/setup/books',3,'2018-08-28 00:35:35.639600','2018-08-28 00:35:35.639600',NULL,'zdc9645e2bc354ccbb37bc8df3dfc3f1',6,'App\\Models\\Course',12),
	(58,'web','navigation','https://demo.notebowl.xyz/courses/mission-to-mars/setup/final',3,'2018-08-28 00:35:37.411300','2018-08-28 00:35:37.411300',NULL,'b1e98dbc8414844388a05581a1a99cd6',6,'App\\Models\\Course',12),
	(59,'web','navigation','https://demo.notebowl.xyz/courses/mission-to-mars/bulletin',3,'2018-08-28 00:35:38.828100','2018-08-28 00:35:38.828100',NULL,'bd34b979494cc49d280acc0164c6a598',6,'App\\Models\\Course',12),
	(60,'web','navigation','https://demo.notebowl.xyz/courses/american-history--the-rol/bulletin',3,'2018-08-28 00:35:41.578400','2018-08-28 00:35:41.578400',NULL,'aa6f6e930f0c4487ca3ba99bb8319017',4,'App\\Models\\Course',12),
	(61,'web','navigation','https://demo.notebowl.xyz/courses/mission-to-mars/bulletin',3,'2018-08-28 00:35:44.697400','2018-08-28 00:35:44.697400',NULL,'vdf5733800cda4023aef2381a5fcb916',6,'App\\Models\\Course',12),
	(62,'web','navigation','https://demo.notebowl.xyz/courses/american-history--the-rol/bulletin',3,'2018-08-28 00:35:46.382600','2018-08-28 00:35:46.382600',NULL,'hd30626d647d846c1afe6bc328320b00',4,'App\\Models\\Course',12);

/*!40000 ALTER TABLE `analytics` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table assessment_answers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assessment_answers`;

CREATE TABLE `assessment_answers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` mediumtext,
  `question_id` int(10) unsigned NOT NULL,
  `is_correct` tinyint(1) NOT NULL DEFAULT '0',
  `creator_id` int(10) unsigned NOT NULL,
  `resource_key` varchar(32) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `assessment_question_answers_resource_key_unique` (`resource_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table assessment_questions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assessment_questions`;

CREATE TABLE `assessment_questions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` mediumtext,
  `points` double NOT NULL DEFAULT '0',
  `question_scheme` enum('radio','checkbox','free_response','true_false','fill_in','file_upload') NOT NULL,
  `assessment_id` int(10) unsigned NOT NULL,
  `creator_id` int(10) unsigned NOT NULL,
  `resource_key` varchar(32) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `description` longtext,
  `extra_credit` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `assessment_questions_resource_key_unique` (`resource_key`),
  KEY `assessment_questions_assessment_id_index` (`assessment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table assessment_responses
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assessment_responses`;

CREATE TABLE `assessment_responses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `answer_id` int(10) unsigned DEFAULT NULL,
  `assessment_id` int(10) unsigned NOT NULL,
  `submission_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `text_content` mediumtext,
  `resource_key` varchar(32) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `question_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `assessment_responses_resource_key_unique` (`resource_key`),
  KEY `assessment_responses_submission_id_deleted_at_index` (`submission_id`,`deleted_at`),
  KEY `assessment_responses_answer_id_index` (`answer_id`),
  KEY `assessment_responses_assessment_id_index` (`assessment_id`),
  KEY `assessment_responses_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table assessment_submissions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assessment_submissions`;

CREATE TABLE `assessment_submissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `assessment_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `time_started` timestamp(6) NULL DEFAULT NULL,
  `time_completed` timestamp(6) NULL DEFAULT NULL,
  `resource_key` varchar(32) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `assessment_submissions_resource_key_unique` (`resource_key`),
  KEY `assessment_submissions_assessment_id_index` (`assessment_id`),
  KEY `assessment_submissions_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table assessments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assessments`;

CREATE TABLE `assessments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(190) NOT NULL,
  `permalink` varchar(190) NOT NULL,
  `resource_key` varchar(32) NOT NULL,
  `description` mediumtext,
  `attempts` int(11) NOT NULL DEFAULT '1',
  `time_limit` int(10) unsigned NOT NULL DEFAULT '0',
  `grace_period` int(11) NOT NULL DEFAULT '0',
  `parent_id` int(10) unsigned NOT NULL,
  `creator_id` int(10) unsigned NOT NULL,
  `category_id` int(10) unsigned DEFAULT NULL,
  `available_date` datetime DEFAULT NULL,
  `due_date` datetime DEFAULT NULL,
  `result_scheme` enum('score','summary','correct','incorrect') NOT NULL DEFAULT 'score',
  `question_scheme` enum('radio','checkbox','free_response','true_false','file_upload') NOT NULL DEFAULT 'true_false',
  `partial_credit` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `default_question_points` int(10) unsigned NOT NULL DEFAULT '0',
  `answer_order` enum('normal','random') NOT NULL DEFAULT 'normal',
  `question_order` enum('normal','random') NOT NULL DEFAULT 'normal',
  `parent_type` varchar(190) NOT NULL,
  `locked` tinyint(1) NOT NULL DEFAULT '0',
  `action_mode` varchar(255) DEFAULT NULL,
  `grade_scheme` enum('Points','Percentage','Letter Grade') NOT NULL DEFAULT 'Points',
  `grades_published` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `assessments_resource_key_unique` (`resource_key`),
  UNIQUE KEY `assessments_permalink_course_id_deleted_at_unique` (`permalink`,`parent_id`,`deleted_at`),
  KEY `assessments_course_id_index` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table assignment_group_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assignment_group_users`;

CREATE TABLE `assignment_group_users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `resource_key` varchar(32) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `parent_type` varchar(190) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `assignment_group_users_resource_key_unique` (`resource_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table assignment_groups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assignment_groups`;

CREATE TABLE `assignment_groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) DEFAULT NULL,
  `name` mediumtext NOT NULL,
  `resource_key` varchar(32) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `parent_type` varchar(190) NOT NULL,
  `locked` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `assignment_groups_resource_key_unique` (`resource_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `assignment_groups` WRITE;
/*!40000 ALTER TABLE `assignment_groups` DISABLE KEYS */;

INSERT INTO `assignment_groups` (`id`, `parent_id`, `name`, `resource_key`, `created_at`, `updated_at`, `deleted_at`, `parent_type`, `locked`)
VALUES
	(1,4,'Group 1','u7129256ba9ac406bab45cb471a1ec48','2018-08-28 00:18:18.943400','2018-08-28 00:18:18.943400',NULL,'App\\Models\\Assignment',0),
	(2,4,'Group 2','xe4f2cc7ff1024db0b94ba891fa0319d','2018-08-28 00:18:18.962700','2018-08-28 00:18:18.962700',NULL,'App\\Models\\Assignment',0);

/*!40000 ALTER TABLE `assignment_groups` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table assignments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assignments`;

CREATE TABLE `assignments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(190) NOT NULL,
  `desc` mediumtext,
  `due_date` datetime NOT NULL,
  `available_date` datetime NOT NULL,
  `points` int(10) unsigned NOT NULL,
  `parent_id` int(10) unsigned NOT NULL,
  `creator_id` int(10) unsigned NOT NULL,
  `grade_only` tinyint(1) NOT NULL DEFAULT '0',
  `category_id` int(10) unsigned NOT NULL,
  `submission_late` tinyint(1) NOT NULL DEFAULT '0',
  `permalink` varchar(190) NOT NULL,
  `type` enum('Individual','Group') NOT NULL DEFAULT 'Individual',
  `group_max` int(11) NOT NULL,
  `min_num_posts` int(11) NOT NULL DEFAULT '0',
  `min_num_comments` int(11) NOT NULL DEFAULT '0',
  `word_count_posts` int(11) NOT NULL DEFAULT '0',
  `word_count_comments` int(11) NOT NULL DEFAULT '0',
  `posts_required` enum('Recommended','Required') NOT NULL DEFAULT 'Recommended',
  `comments_required` enum('Recommended','Required') NOT NULL DEFAULT 'Recommended',
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `resource_key` varchar(32) NOT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `grades_published` tinyint(1) NOT NULL DEFAULT '1',
  `grader_scheme` enum('Professor','Student') NOT NULL DEFAULT 'Professor',
  `google_convert_submissions` tinyint(1) NOT NULL,
  `upload_restrict_extensions` varchar(190) DEFAULT NULL,
  `grade_scheme` enum('Points','(In)complete','Percentage','Letter Grade') NOT NULL DEFAULT 'Points',
  `submission_scheme` enum('No Submission','File Submission','Discussion Board') NOT NULL DEFAULT 'No Submission',
  `anonymous_posting` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `assignments_resource_key_unique` (`resource_key`),
  UNIQUE KEY `assignments_permalink_course_id_deleted_at_unique` (`permalink`,`parent_id`,`deleted_at`),
  KEY `assignments_course_id_deleted_at_index` (`parent_id`,`deleted_at`),
  KEY `assignments_course_id_index` (`parent_id`),
  KEY `assignments_parent_id_index` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `assignments` WRITE;
/*!40000 ALTER TABLE `assignments` DISABLE KEYS */;

INSERT INTO `assignments` (`id`, `title`, `desc`, `due_date`, `available_date`, `points`, `parent_id`, `creator_id`, `grade_only`, `category_id`, `submission_late`, `permalink`, `type`, `group_max`, `min_num_posts`, `min_num_comments`, `word_count_posts`, `word_count_comments`, `posts_required`, `comments_required`, `created_at`, `updated_at`, `resource_key`, `deleted_at`, `grades_published`, `grader_scheme`, `google_convert_submissions`, `upload_restrict_extensions`, `grade_scheme`, `submission_scheme`, `anonymous_posting`)
VALUES
	(2,'Space Freefall Discussion Board','Watch the video and leave ONE post on the discussion board and ONE comment for  25 points. ** Minimum of 40 words for your post and a minimum of 10 words on a comment for full credit.','2018-09-04 06:59:00','2018-08-28 00:15:00',25,3,1,0,11,1,'space-freefall-discussion','Individual',2,0,0,0,0,'Recommended','Recommended','2018-08-28 00:15:59.479800','2018-08-28 00:15:59.479800','zcda01b14200644a79a16126992f807a',NULL,1,'Professor',0,NULL,'Points','Discussion Board',0),
	(3,'Lunar Travel Topic Paper','For this assignment, each of you will be writing a 4-6 page research paper outlining the US and Soviet attempts to land on the moon, detailing the roadblocks in their way and the impact that the 1969 lunar landing has had on our modern understanding of astronomy. Use at least three scholarly and two non-scholarly sources.','2018-09-04 06:59:00','2018-08-28 00:16:00',50,3,1,0,11,1,'lunar-travel-topic-paper','Individual',2,0,0,0,0,'Recommended','Recommended','2018-08-28 00:16:46.982400','2018-08-28 00:16:46.982400','h1e210e3ce3aa43a5b3fde8547648cce',NULL,1,'Professor',0,NULL,'Points','File Submission',0),
	(4,'Group Overnight Starwatch','The purpose of this project is to get you to take note of the apparent motion of the constellations with\nrespect to the horizon. The diurnal motion is observed by watching a constellation through one night.\nKeep in mind that the “time of day” is the position of the sun with respect to YOU.\n\nDo this on the first CLEAR NIGHT!! It can cloud up for weeks & weeks!!!\n\n** See attached handout for project details.\n** Attach a photo below for proof of your group stargazing.\n\nWe will discuss in class your experience after winter break.','2018-09-04 06:59:00','2018-08-28 00:16:00',30,3,1,0,11,1,'group-overnight-starwatch','Group',3,0,0,0,0,'Recommended','Recommended','2018-08-28 00:18:18.896200','2018-08-28 00:18:18.896200','d74943de54eef49108523c16ac493e86',NULL,1,'Professor',0,NULL,'Points','File Submission',0),
	(5,'The Night Sky Quiz','Astronomy is the oldest science, and its history shows a growing realization of our insignificant status in a vast and ancient universe.\n\nComplete the quiz and submit for grading, 10 points per question.','2018-09-04 06:59:00','2018-08-28 00:18:00',30,3,1,0,13,0,'the-night-sky-quiz','Individual',2,0,0,0,0,'Recommended','Recommended','2018-08-28 00:19:01.029000','2018-08-28 00:19:01.029000','ud7c1186e1a44432a963cdacd4368e4d',NULL,1,'Professor',0,NULL,'Percentage','No Submission',0),
	(6,'Intro to Astronomy Exam','A continuing revolution in telescope design and construction is giving astronomers an unprecedented set of tools for exploring the universe.\n\nThis exam will be graded before spring break, please ask if any questions!','2018-09-04 06:59:00','2018-08-28 00:19:00',40,3,1,0,12,0,'intro-to-astronomy-exam','Individual',2,0,0,0,0,'Recommended','Recommended','2018-08-28 00:19:55.745200','2018-08-28 00:19:55.745200','c40d8a7ce79894a879ee92d410052626',NULL,1,'Professor',0,NULL,'Letter Grade','No Submission',0),
	(7,'Mission to Mars','Review the SpaceX Mission to Mars and write up a one-page paper with your opinions on the pros and cons of this mission. And your thoughts on when it is possible.','2018-09-04 06:59:00','2018-08-28 00:20:00',50,3,1,0,14,1,'mission-to-mars','Individual',2,0,0,0,0,'Recommended','Recommended','2018-08-28 00:20:29.855900','2018-08-28 00:20:29.855900','lf1f97d5feb6746769401727a7d7988e',NULL,1,'Professor',0,NULL,'Points','File Submission',0);

/*!40000 ALTER TABLE `assignments` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table attachment_previews
# ------------------------------------------------------------

DROP TABLE IF EXISTS `attachment_previews`;

CREATE TABLE `attachment_previews` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `attachment_id` int(10) unsigned NOT NULL,
  `page_number` int(11) DEFAULT NULL,
  `valid_data` mediumtext NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `type` varchar(190) NOT NULL DEFAULT 'image/png',
  PRIMARY KEY (`id`),
  UNIQUE KEY `attachment_previews_attachment_id_page_number_type_unique` (`attachment_id`,`page_number`,`type`),
  KEY `attachment_id` (`attachment_id`),
  KEY `attachment_previews_attachment_id_index` (`attachment_id`),
  KEY `attachment_previews_page_number_index` (`page_number`),
  KEY `attachment_previews_deleted_at_index` (`deleted_at`),
  KEY `attachment_previews_type_index` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table attachments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `attachments`;

CREATE TABLE `attachments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `attachment_name` varchar(190) NOT NULL,
  `file_name` varchar(190) DEFAULT NULL,
  `location` varchar(190) DEFAULT NULL,
  `status` varchar(190) DEFAULT NULL,
  `owner_id` int(10) unsigned NOT NULL,
  `parent_id` int(11) NOT NULL,
  `parent_type` varchar(190) NOT NULL DEFAULT '',
  `available_date` datetime DEFAULT NULL,
  `view_scheme` varchar(190) DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `resource_key` varchar(32) NOT NULL,
  `attachment_scheme` varchar(190) NOT NULL,
  `size` bigint(20) DEFAULT '0',
  `type` varchar(190) DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `attachments_resource_key_unique` (`resource_key`),
  KEY `attachable` (`parent_id`,`parent_type`),
  KEY `attachments_parent_id_index` (`parent_id`),
  KEY `attachments_parent_type_index` (`parent_type`),
  KEY `attachments_available_date_index` (`available_date`),
  KEY `attachments_deleted_at_index` (`deleted_at`),
  KEY `attachments_parent_id_parent_type_index` (`parent_id`,`parent_type`),
  KEY `attachments_parent_id_parent_type_deleted_at_index` (`parent_id`,`parent_type`,`deleted_at`),
  KEY `eager_loading` (`parent_id`,`parent_type`,`available_date`,`deleted_at`),
  KEY `attachments_attachment_name_index` (`attachment_name`),
  KEY `attachments_file_name_index` (`file_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `attachments` WRITE;
/*!40000 ALTER TABLE `attachments` DISABLE KEYS */;

INSERT INTO `attachments` (`id`, `attachment_name`, `file_name`, `location`, `status`, `owner_id`, `parent_id`, `parent_type`, `available_date`, `view_scheme`, `created_at`, `updated_at`, `resource_key`, `attachment_scheme`, `size`, `type`, `deleted_at`)
VALUES
	(1,'Explorations: Introduction to Astronomy',NULL,'9780077345099','completed',1,3,'App\\Models\\Course','2018-08-28 00:05:16',NULL,'2018-08-28 00:05:20.787900','2018-08-28 00:05:20.787900','vfc60395a035d41069bf6f8263557350','Book',0,NULL,NULL);

/*!40000 ALTER TABLE `attachments` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table categories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `categories`;

CREATE TABLE `categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(190) NOT NULL,
  `parent_id` int(10) unsigned NOT NULL,
  `weight` double NOT NULL DEFAULT '0',
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `is_extra_credit` tinyint(1) NOT NULL DEFAULT '0',
  `resource_key` varchar(32) NOT NULL,
  `drop_lowest` int(10) unsigned NOT NULL DEFAULT '0',
  `parent_type` varchar(190) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `assignment_categories_resource_key_unique` (`resource_key`),
  KEY `assignment_categories_course_id_deleted_at_index` (`parent_id`,`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;

INSERT INTO `categories` (`id`, `title`, `parent_id`, `weight`, `created_at`, `updated_at`, `deleted_at`, `is_extra_credit`, `resource_key`, `drop_lowest`, `parent_type`)
VALUES
	(1,'Homework',1,0,'2016-05-13 01:59:34.372871','2017-02-16 06:45:25.030200',NULL,0,'IAhx3EZbQ3TVtxx2Wz2rVBk2a6n98mzk',0,'App\\Models\\Course'),
	(2,'Test',1,0,'2016-05-13 01:59:34.381449','2018-04-19 04:12:51.558000',NULL,0,'rfb67c458083e4b83bc45ec430ca4089',0,'App\\Models\\Course'),
	(3,'Quiz',1,0,'2016-05-13 01:59:34.388809','2017-02-16 06:45:25.030200',NULL,0,'j3PrnbgCcibTNPoRFdkPyXcOoDzG4PnG',0,'App\\Models\\Course'),
	(4,'Project',1,0,'2016-05-13 01:59:34.393880','2018-04-19 04:12:51.548900',NULL,0,'bcaf3accf235949f6a4b434fc2ddc4e5',0,'App\\Models\\Course'),
	(5,'Homework',2,0,'2016-05-13 01:59:41.309061','2017-02-16 06:45:25.030200',NULL,0,'zy6DCR3BlE8E9gpoHEvJ4HwXipuRItqa',0,'App\\Models\\Course'),
	(6,'Test',2,0,'2016-05-13 01:59:41.314150','2017-02-16 06:45:25.030200',NULL,0,'qCf737TC9MWj1AKQ7wGuR3ehcMacj0SW',0,'App\\Models\\Course'),
	(7,'Quiz',2,0,'2016-05-13 01:59:41.318971','2017-02-16 06:45:25.030200',NULL,0,'lNg6cYYn3AVW5uddU0sThzstBvuMrYlR',0,'App\\Models\\Course'),
	(8,'Project',2,0,'2016-05-13 01:59:41.324380','2017-02-16 06:45:25.030200',NULL,0,'wKai1Ccja7izDE8Bu8ceK6gwMhZoJ9tj',0,'App\\Models\\Course'),
	(9,'Survey',1,0,'2018-01-10 18:54:16.381800','2018-01-10 18:54:16.381800',NULL,0,'ejoiTEukcBybR3fxjQESE2NaRqCt9cDw',0,'App\\Models\\Group'),
	(10,'Survey',2,0,'2018-01-10 18:54:16.499900','2018-01-10 18:54:16.499900',NULL,0,'lGqePt4kZllalZUiWOQOjFFsT6F9iRIW',0,'App\\Models\\Group'),
	(11,'Homework',3,0,'2018-08-28 00:04:20.385800','2018-08-28 00:04:20.385800',NULL,0,'v46402c7b431a4aea80ae220eec5263f',0,'App\\Models\\Course'),
	(12,'Exam',3,0,'2018-08-28 00:04:20.407300','2018-08-28 00:04:20.407300',NULL,0,'ebaa086f7065d4c3c86781403b3aab5f',0,'App\\Models\\Course'),
	(13,'Quiz',3,0,'2018-08-28 00:04:20.416300','2018-08-28 00:04:20.416300',NULL,0,'m9fb083f87d3941f987253b40638c738',0,'App\\Models\\Course'),
	(14,'Project',3,0,'2018-08-28 00:04:20.423700','2018-08-28 00:04:20.423700',NULL,0,'xc97a04a91e4e461c8bdaf1ee57397a9',0,'App\\Models\\Course'),
	(15,'Homework',4,0,'2018-08-28 00:31:37.050100','2018-08-28 00:31:37.050100',NULL,0,'h9dd69f4d0f374a988c721ce9b7b4427',0,'App\\Models\\Course'),
	(16,'Exam',4,0,'2018-08-28 00:31:37.063297','2018-08-28 00:31:37.063297',NULL,0,'t0b78731421654b3fa51ad176e3595e4',0,'App\\Models\\Course'),
	(17,'Quiz',4,0,'2018-08-28 00:31:37.067900','2018-08-28 00:31:37.067900',NULL,0,'p9c0b53a782d14343a0f8b807b750310',0,'App\\Models\\Course'),
	(18,'Project',4,0,'2018-08-28 00:31:37.073100','2018-08-28 00:31:37.073100',NULL,0,'ba577b1d62d4c4c0aac86e3bea5572e6',0,'App\\Models\\Course'),
	(19,'Homework',5,0,'2018-08-28 00:32:17.777800','2018-08-28 00:32:17.777800',NULL,0,'k6070cceae4dd487c8ccbf97ac266c4a',0,'App\\Models\\Course'),
	(20,'Exam',5,0,'2018-08-28 00:32:17.797900','2018-08-28 00:32:17.797900',NULL,0,'x1e7bb8906106448f8c310cd19a05aa4',0,'App\\Models\\Course'),
	(21,'Quiz',5,0,'2018-08-28 00:32:17.802000','2018-08-28 00:32:17.802000',NULL,0,'s0b455be6df484204ba56cfc9ad68cca',0,'App\\Models\\Course'),
	(22,'Project',5,0,'2018-08-28 00:32:17.806300','2018-08-28 00:32:17.806300',NULL,0,'idc8a7cbf118a41d8af1ca4af4fda1cb',0,'App\\Models\\Course'),
	(23,'Homework',6,0,'2018-08-28 00:33:06.276200','2018-08-28 00:33:06.276200',NULL,0,'f1e675f1084df446f8f7a1344c6fbf30',0,'App\\Models\\Course'),
	(24,'Exam',6,0,'2018-08-28 00:33:06.294000','2018-08-28 00:33:06.294000',NULL,0,'e50df2b1949cf40af859f69b12352c47',0,'App\\Models\\Course'),
	(25,'Quiz',6,0,'2018-08-28 00:33:06.298800','2018-08-28 00:33:06.298800',NULL,0,'w20b91ea07ab04205b22718aae7aab2c',0,'App\\Models\\Course'),
	(26,'Project',6,0,'2018-08-28 00:33:06.305200','2018-08-28 00:33:06.305200',NULL,0,'x6b36728ae84d480b88f5b23de0684e2',0,'App\\Models\\Course');

/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table comments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `comments`;

CREATE TABLE `comments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `post_id` int(10) unsigned NOT NULL,
  `text` mediumtext,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `resource_key` varchar(32) NOT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `edited_at` timestamp(6) NULL DEFAULT NULL,
  `anonymous` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `comments_resource_key_unique` (`resource_key`),
  KEY `comments_post_id_deleted_at_index` (`post_id`,`deleted_at`),
  KEY `comments_post_id_index` (`post_id`),
  KEY `comments_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;

INSERT INTO `comments` (`id`, `user_id`, `post_id`, `text`, `created_at`, `updated_at`, `resource_key`, `deleted_at`, `edited_at`, `anonymous`)
VALUES
	(1,14,1,'Thanks for sharing! This is nuts!','2018-08-28 00:23:09.125596','2018-08-28 00:23:09.125596','jf1833e8545654e0abdbd81b7a422d4b',NULL,NULL,0),
	(2,10,2,'I will be at the library after school going over the radiation chapter. Let\'s team up!','2018-08-28 00:23:50.942000','2018-08-28 00:23:50.942000','ff9c7c33fcb5d4d49b66cc8d2f9cdff6',NULL,NULL,0),
	(3,11,2,'I will be as well!','2018-08-28 00:24:25.483000','2018-08-28 00:24:25.483000','aece9a9845f6b47d481c171b95cba06e',NULL,NULL,0),
	(4,2,3,'I\'ll send them to you now!','2018-08-28 00:25:35.906600','2018-08-28 00:25:35.906600','sf822f7043fd3412cb1c32b818ac8258',NULL,NULL,0),
	(5,14,4,'In a Newtonian black hole, infinite energy is released in the collapse that forms the black hole. For general relativistic black holes, finite energy is released in the collapse that forms the black hole.','2018-08-28 00:26:12.729800','2018-08-28 00:26:12.729800','k65fbc2e78d884ff8bed9cd133115b8c',NULL,NULL,0),
	(6,14,2,'Thanks guys, let\'s do it!','2018-08-28 00:26:30.262700','2018-08-28 00:26:30.262700','t937f86900159428eb470f6b13be8d09',NULL,NULL,0),
	(7,3,4,'Also, the Newtonian black hole involves no disturbance to space and time. Compared to general relativistic black holes where there are causally isolated regions of space and time.','2018-08-28 00:27:35.711900','2018-08-28 00:27:35.711900','zb0f9f713f87c4daf995245fbe004f92',NULL,NULL,0),
	(8,10,4,'This link will help you determine the difference between the two black holes formations!\nhttp://www.pitt.edu/~jdnorton/teaching/HPS_0410/chapters/black_holes/#Newtonian1','2018-08-28 00:29:04.204100','2018-08-28 00:29:11.033200','hc16cc4a29bdf4ed79838367aa4b5aec',NULL,'2018-08-28 00:29:11.018700',0);

/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table courses
# ------------------------------------------------------------

DROP TABLE IF EXISTS `courses`;

CREATE TABLE `courses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `university_id` int(10) unsigned NOT NULL,
  `term_id` int(10) unsigned NOT NULL,
  `name` varchar(190) NOT NULL,
  `subject` varchar(190) NOT NULL,
  `number` varchar(190) NOT NULL,
  `permalink` varchar(190) NOT NULL,
  `available_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `enrollment_close_date` datetime DEFAULT NULL,
  `archive_date` datetime DEFAULT NULL,
  `units` double DEFAULT '0',
  `use_weighted_grades` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `resource_key` varchar(32) NOT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `use_drop_lowest` tinyint(1) NOT NULL DEFAULT '0',
  `type` varchar(190) DEFAULT NULL,
  `location` varchar(190) DEFAULT NULL,
  `description` mediumtext,
  `invite_group_id` int(10) unsigned DEFAULT NULL,
  `price` double(6,2) DEFAULT NULL,
  `download_restrict_assessments` tinyint(1) DEFAULT '1',
  `download_restrict_assignments` tinyint(1) DEFAULT '1',
  `download_restrict_bulletin` tinyint(1) DEFAULT '1',
  `download_restrict_documents` tinyint(1) DEFAULT '1',
  `download_restrict_submissions` tinyint(1) DEFAULT '0',
  `download_restrict_extensions` varchar(255) DEFAULT '',
  `course_tab_enabled_about` tinyint(1) NOT NULL DEFAULT '1',
  `course_tab_enabled_about_t_a` tinyint(1) NOT NULL DEFAULT '1',
  `course_tab_enabled_about_student` tinyint(1) NOT NULL DEFAULT '1',
  `course_tab_enabled_assignments` tinyint(1) NOT NULL DEFAULT '1',
  `course_tab_enabled_assignments_t_a` tinyint(1) NOT NULL DEFAULT '1',
  `course_tab_enabled_assignments_student` tinyint(1) NOT NULL DEFAULT '1',
  `course_tab_enabled_documents` tinyint(1) NOT NULL DEFAULT '1',
  `course_tab_enabled_documents_t_a` tinyint(1) NOT NULL DEFAULT '1',
  `course_tab_enabled_documents_student` tinyint(1) NOT NULL DEFAULT '1',
  `course_tab_enabled_grades` tinyint(1) NOT NULL DEFAULT '1',
  `course_tab_enabled_grades_t_a` tinyint(1) NOT NULL DEFAULT '0',
  `course_tab_enabled_grades_student` tinyint(1) NOT NULL DEFAULT '1',
  `course_tab_enabled_roster` tinyint(1) NOT NULL DEFAULT '1',
  `course_tab_enabled_roster_t_a` tinyint(1) NOT NULL DEFAULT '1',
  `course_tab_enabled_roster_student` tinyint(1) NOT NULL DEFAULT '1',
  `course_tab_name_about` varchar(255) NOT NULL DEFAULT 'About',
  `course_tab_name_assignments` varchar(255) NOT NULL DEFAULT 'Assignments',
  `course_tab_name_documents` varchar(255) NOT NULL DEFAULT 'Documents',
  `course_tab_name_grades` varchar(255) NOT NULL DEFAULT 'Grades',
  `course_tab_name_roster` varchar(255) NOT NULL DEFAULT 'Roster',
  `course_tab_name_bulletin` varchar(255) NOT NULL DEFAULT 'Bulletin',
  `points_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `enable_student_average_grade_letter` tinyint(1) NOT NULL DEFAULT '1',
  `enable_student_average_grade_letter_t_a` tinyint(1) NOT NULL DEFAULT '1',
  `enable_student_average_grade_letter_student` tinyint(1) NOT NULL DEFAULT '1',
  `enable_student_average_grade_percentage` tinyint(1) NOT NULL DEFAULT '1',
  `enable_student_average_grade_percentage_t_a` tinyint(1) NOT NULL DEFAULT '1',
  `enable_student_average_grade_percentage_student` tinyint(1) NOT NULL DEFAULT '1',
  `enable_student_average_grade_points` tinyint(1) NOT NULL DEFAULT '0',
  `enable_student_average_grade_points_t_a` tinyint(1) NOT NULL DEFAULT '0',
  `enable_student_average_grade_points_student` tinyint(1) NOT NULL DEFAULT '0',
  `enable_letter_grade_override` tinyint(1) NOT NULL DEFAULT '0',
  `grade_scale_custom` tinyint(1) NOT NULL DEFAULT '0',
  `grade_scheme` varchar(255) NOT NULL DEFAULT 'round',
  `grade_base` varchar(255) NOT NULL DEFAULT 'percent',
  `grade_precision` int(11) NOT NULL DEFAULT '1',
  `grade_curve_amount` double NOT NULL DEFAULT '0',
  `grade_scale_medians` varchar(255) DEFAULT NULL,
  `grade_scale_titles` varchar(255) DEFAULT NULL,
  `grade_scale_values` varchar(255) DEFAULT NULL,
  `paywall` tinyint(1) NOT NULL DEFAULT '0',
  `published` tinyint(1) NOT NULL DEFAULT '0',
  `profile_picture` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `courses_resource_key_unique` (`resource_key`),
  UNIQUE KEY `courses_permalink_unique` (`permalink`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;

INSERT INTO `courses` (`id`, `university_id`, `term_id`, `name`, `subject`, `number`, `permalink`, `available_date`, `end_date`, `enrollment_close_date`, `archive_date`, `units`, `use_weighted_grades`, `created_at`, `updated_at`, `resource_key`, `deleted_at`, `use_drop_lowest`, `type`, `location`, `description`, `invite_group_id`, `price`, `download_restrict_assessments`, `download_restrict_assignments`, `download_restrict_bulletin`, `download_restrict_documents`, `download_restrict_submissions`, `download_restrict_extensions`, `course_tab_enabled_about`, `course_tab_enabled_about_t_a`, `course_tab_enabled_about_student`, `course_tab_enabled_assignments`, `course_tab_enabled_assignments_t_a`, `course_tab_enabled_assignments_student`, `course_tab_enabled_documents`, `course_tab_enabled_documents_t_a`, `course_tab_enabled_documents_student`, `course_tab_enabled_grades`, `course_tab_enabled_grades_t_a`, `course_tab_enabled_grades_student`, `course_tab_enabled_roster`, `course_tab_enabled_roster_t_a`, `course_tab_enabled_roster_student`, `course_tab_name_about`, `course_tab_name_assignments`, `course_tab_name_documents`, `course_tab_name_grades`, `course_tab_name_roster`, `course_tab_name_bulletin`, `points_enabled`, `enable_student_average_grade_letter`, `enable_student_average_grade_letter_t_a`, `enable_student_average_grade_letter_student`, `enable_student_average_grade_percentage`, `enable_student_average_grade_percentage_t_a`, `enable_student_average_grade_percentage_student`, `enable_student_average_grade_points`, `enable_student_average_grade_points_t_a`, `enable_student_average_grade_points_student`, `enable_letter_grade_override`, `grade_scale_custom`, `grade_scheme`, `grade_base`, `grade_precision`, `grade_curve_amount`, `grade_scale_medians`, `grade_scale_titles`, `grade_scale_values`, `paywall`, `published`, `profile_picture`)
VALUES
	(1,1,1,'Electro Magnetic Physics','PHYS','241','phys-241',NULL,'2050-01-01 00:00:00','2030-01-01 00:00:00',NULL,4,0,'2016-05-13 01:59:34.340111','2018-03-26 20:21:51.519200','bOVgMXqceI7050G5oNQI8G7TgALRy5gz',NULL,0,NULL,'Harville 220','In addition to the basic concepts of Electromagnetism, a vast variety of interesting topics are covered in this course: Lightning, Pacemakers, Electric Shock Treatment, Electrocardiograms, Metal Detectors, Musical Instruments, Magnetic Levitation, Bullet Trains, Electric Motors, Radios, TV, Car Coils, Superconductivity, Aurora Borealis, Rainbows, Radio Telescopes, Interferometers, Particle Accelerators (a.k.a. Atom Smashers or Colliders), Mass Spectrometers, Red Sunsets, Blue Skies, Haloes around Sun and Moon, Color Perception, Doppler Effect, Big-Bang Cosmology.',NULL,NULL,1,1,1,1,0,'',1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,'About','Assignments','Documents','Grades','Roster','Bulletin',1,1,1,1,1,1,1,0,0,0,0,0,'round','percent',1,0,NULL,NULL,NULL,1,1,NULL),
	(2,1,1,'Honors English','ENG','109','eng-109h',NULL,'2050-01-01 00:00:00','2030-01-01 00:00:00',NULL,3,0,'2016-05-13 01:59:41.304750','2018-03-26 20:21:51.519200','oP8ByiAzFX6MQ8eSlsoNzPoYBQgXWrci',NULL,0,NULL,NULL,NULL,NULL,NULL,1,1,1,1,0,'',1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,'About','Assignments','Documents','Grades','Roster','Bulletin',1,1,1,1,1,1,1,0,0,0,0,0,'round','percent',1,0,NULL,NULL,NULL,1,1,NULL),
	(3,1,1,'Astronomy: Exploring Time and Space','ASTR','108','astronomy--exploring-time','2014-01-01 00:00:00','2050-01-01 00:00:00',NULL,NULL,3,0,'2018-08-28 00:04:20.354200','2018-08-28 00:13:24.738000','lc70cff6d40844d52b9927fa9a406a13',NULL,0,NULL,'Suite 200','This course is designed for anyone who is interested in learning more about modern astronomy. We will help you get up to date on the most recent astronomical discoveries while also providing support at an introductory level for those who have no background in science.',NULL,0.00,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,'About','Assignments','Documents','Grades','Roster','Bulletin',1,1,1,1,1,1,1,0,0,0,0,0,'round','percent',1,0,'30;65;75;85;95','F;D;C;B;A','0;60;70;80;90',0,1,'https://notebowl.s3.amazonaws.com/courses/lc70cff6d40844d52b9927fa9a406a13/profile-picture/IXXZpb4j9Va4pgvjb0cg7XbrQXwFyFe7'),
	(4,1,1,'American History: The Role of Politics and Government','AMH','400','american-history--the-rol','2014-01-01 00:00:00','2050-01-01 00:00:00',NULL,NULL,0,0,'2018-08-28 00:31:37.039100','2018-08-28 00:35:19.588900','le4acf50aaacc4d86a8ad041040cfa3d',NULL,0,NULL,NULL,NULL,NULL,0.00,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,'About','Assignments','Documents','Grades','Roster','Bulletin',1,1,1,1,1,1,1,0,0,0,0,0,'round','percent',1,0,'30;65;75;85;95','F;D;C;B;A','0;60;70;80;90',0,1,NULL),
	(5,1,1,'Google Leadership Development Program','GOOG','007','google-leadership-develop','2014-01-01 00:00:00','2050-01-01 00:00:00',NULL,NULL,0,0,'2018-08-28 00:32:17.769300','2018-08-28 00:35:28.552600','s5802ee9570f642b28342df283d297af',NULL,0,NULL,'','This course is designed to hone business expertise and develop skills for a leadership position. \r\n\r\nProgram Objectives:\r\n1. Discover how experiences, beliefs and values effect our leadership style.\r\n2. Develop human potential and build relationships of mutual trust and respect.\r\n3. Create and maintain processes and procedures that drive innovation.\r\n4. Develop leadership by demonstrating effective questioning and listening skills.',NULL,0.00,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,'About','Assignments','Documents','Grades','Roster','Bulletin',1,1,1,1,1,1,1,0,0,0,0,0,'round','percent',1,0,'30;65;75;85;95','F;D;C;B;A','0;60;70;80;90',0,1,NULL),
	(6,1,1,'Mission to Mars','SPACE','100','mission-to-mars','2014-01-01 00:00:00','2050-01-01 00:00:00',NULL,NULL,0,0,'2018-08-28 00:33:06.264900','2018-08-28 00:35:38.262000','d4f7a84149dff4e92a9180d8d97bdd1c',NULL,0,NULL,NULL,NULL,NULL,0.00,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,'About','Assignments','Documents','Grades','Roster','Bulletin',1,1,1,1,1,1,1,0,0,0,0,0,'round','percent',1,0,'30;65;75;85;95','F;D;C;B;A','0;60;70;80;90',0,1,NULL);

/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table date_logs
# ------------------------------------------------------------

DROP TABLE IF EXISTS `date_logs`;

CREATE TABLE `date_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `table` varchar(190) NOT NULL,
  `column` varchar(255) NOT NULL DEFAULT 'available_date',
  `primary_id` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table devices
# ------------------------------------------------------------

DROP TABLE IF EXISTS `devices`;

CREATE TABLE `devices` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `os` varchar(190) NOT NULL,
  `uuid` varchar(190) NOT NULL,
  `name` varchar(190) NOT NULL,
  `type` varchar(190) NOT NULL,
  `model` varchar(190) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `resource_key` varchar(32) NOT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `token` varchar(255) DEFAULT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `devices_resource_key_unique` (`resource_key`),
  UNIQUE KEY `mobile_devices_uuid_deleted_at_unique` (`uuid`,`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table email_reports
# ------------------------------------------------------------

DROP TABLE IF EXISTS `email_reports`;

CREATE TABLE `email_reports` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `account` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `arn` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `external_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `feedback_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `resource_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `error` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_reports_resource_key_unique` (`resource_key`),
  KEY `email_reports_email_id_index` (`email_id`),
  KEY `email_reports_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



# Dump of table emails
# ------------------------------------------------------------

DROP TABLE IF EXISTS `emails`;

CREATE TABLE `emails` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(190) NOT NULL,
  `sender_id` int(11) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `subject` varchar(190) NOT NULL,
  `body` mediumtext NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `emails_recipient_id_index` (`recipient_id`),
  KEY `emails_sender_id_index` (`sender_id`),
  KEY `emails_deleted_at_index` (`deleted_at`),
  KEY `emails_identifier_index` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table enrollments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `enrollments`;

CREATE TABLE `enrollments` (
  `parent_id` int(10) DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `resource_key` varchar(32) NOT NULL,
  `origin` enum('native','remote') NOT NULL DEFAULT 'native',
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `role` varchar(190) NOT NULL,
  `status` enum('Pending','Accepted') NOT NULL DEFAULT 'Pending',
  `parent_type` varchar(190) NOT NULL,
  `payment_required` tinyint(1) NOT NULL DEFAULT '1',
  `last_access_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `course_users_resource_key_unique` (`resource_key`),
  KEY `course_users_course_id_deleted_at_index` (`parent_id`,`deleted_at`),
  KEY `course_users_course_id_user_id_deleted_at_index` (`parent_id`,`user_id`,`deleted_at`),
  KEY `course_users_user_id_deleted_at_index` (`user_id`,`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `enrollments` WRITE;
/*!40000 ALTER TABLE `enrollments` DISABLE KEYS */;

INSERT INTO `enrollments` (`parent_id`, `user_id`, `id`, `resource_key`, `origin`, `created_at`, `updated_at`, `deleted_at`, `role`, `status`, `parent_type`, `payment_required`, `last_access_at`)
VALUES
	(1,1,1,'e3299ca780a4943429cf2406a32e8f44','native',NULL,'2018-04-19 04:12:51.598000',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(2,1,2,'lM8sGHB9d0yFvTxDhe1q935Fk3QAiFBg','native',NULL,NULL,NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(2,2,3,'QUTDx6ls4PDHnj96d9nmig5XYxF7puJL','native',NULL,NULL,NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(2,16,4,'VvRgrT831R1YtXz7T3lu8QSO2sgPevD1','native',NULL,NULL,NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(2,3,5,'CTYj90xHVSYMuB1UW05SbstexZQVaSgZ','native',NULL,NULL,NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(1,2,6,'m5M9BD1S5HVPpNnZ61hFeboe8HEfXrWR','native',NULL,NULL,NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(1,16,7,'OXEZBqLnrLCpl2S71NMY3lT9EsAsGxlH','native',NULL,NULL,NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(1,3,8,'Pc8jxtrWFEAQXNfI1l5aMJJIqnxTX7IY','native',NULL,NULL,NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(1,4,9,'w727f11df92414233842d2f448753acc','native',NULL,'2018-04-19 04:12:51.583600',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(1,5,10,'s1182db63eaf24707ba5640d0b2ca339','native',NULL,'2018-04-19 04:12:51.576600',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(1,6,11,'cKeG7JwcE4vfhdvKvsP2v6z0haOg9dfm','native',NULL,NULL,NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(1,7,12,'HjxiEGmoK0drMzsUPJknU6gAMvnAIXMk','native',NULL,NULL,NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(1,8,13,'i1PtfbckebEZDLaI0airxxsIl4sZKJWi','native',NULL,NULL,NULL,'Professor','Accepted','App\\Models\\Course',1,NULL),
	(2,9,14,'kTL1B7sR2biwCISTzRMQIrGnDUG2ZB3l','native',NULL,NULL,NULL,'Professor','Accepted','App\\Models\\Course',1,NULL),
	(2,10,15,'q6d73854180724f598e304942c07f1be','native',NULL,'2018-04-19 04:12:51.590900',NULL,'Professor','Accepted','App\\Models\\Course',1,NULL),
	(1,8,19,'j5ea050b6cb6541bd89ceef393023418','native',NULL,'2018-04-19 04:12:51.568100',NULL,'Admin','Accepted','App\\Models\\Group',1,NULL),
	(1,2,20,'hU0A8Y63a24A8LArx7CQurZSxbcADJ8R','native',NULL,NULL,NULL,'Member','Accepted','App\\Models\\Group',1,NULL),
	(1,16,21,'c4b19870b05444e52af11c1e696496d7','native',NULL,'2018-04-19 04:12:51.605800',NULL,'Member','Accepted','App\\Models\\Group',1,NULL),
	(2,9,22,'aYe85WKUhhkxUGug4G5nEDHi4bCx9rBY','native',NULL,NULL,NULL,'Admin','Accepted','App\\Models\\Group',1,NULL),
	(1,3,23,'My2p86pTeWrq0ytq5qghphwuSWKLRj3w','native',NULL,NULL,NULL,'Member','Accepted','App\\Models\\Group',1,NULL),
	(3,3,26,'v10654dbd44574da4a7fc36cbda7f976','native','2018-08-28 00:05:35.134800','2018-08-28 00:05:35.134800',NULL,'Professor','Accepted','App\\Models\\Course',1,NULL),
	(3,1,27,'y2dfd06aceeb94d648c36ee201dbad72','native','2018-08-28 00:06:01.514300','2018-08-28 00:20:50.735300',NULL,'Professor','Accepted','App\\Models\\Course',1,'2018-08-28 00:20:50.000000'),
	(3,10,28,'k4ee0d0024c6f408fbebb772b4ebf9b5','native','2018-08-28 00:14:02.983500','2018-08-28 00:14:02.983500',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(3,2,29,'b4f4c2a8e695f4ecca11e7aca71b0a4d','native','2018-08-28 00:14:10.944200','2018-08-28 00:14:10.944200',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(3,14,30,'g6a3da4f992d74e63bf73335a3d7f9b7','native','2018-08-28 00:14:32.414800','2018-08-28 00:14:32.414800',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(3,11,31,'sba6718e290774e3f98feb07a51bd332','native','2018-08-28 00:14:38.435400','2018-08-28 00:14:38.435400',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(4,3,32,'j521e4337397c4b2484eabf265e314cd','native','2018-08-28 00:31:51.672400','2018-08-28 00:35:46.394000',NULL,'Professor','Accepted','App\\Models\\Course',1,'2018-08-28 00:35:46.000000'),
	(5,3,33,'obd58aaaf121440c8afa9b47d25522af','native','2018-08-28 00:32:38.218400','2018-08-28 00:35:29.227700',NULL,'Professor','Accepted','App\\Models\\Course',1,'2018-08-28 00:35:29.000000'),
	(6,3,34,'yb1f56e05de0b4d0fa9947708cafb791','native','2018-08-28 00:33:18.675000','2018-08-28 00:35:44.707700',NULL,'Professor','Accepted','App\\Models\\Course',1,'2018-08-28 00:35:44.000000'),
	(4,10,35,'h8c1d469106224e308f0704c03ab98ac','native','2018-08-28 00:34:24.713100','2018-08-28 00:34:24.713100',NULL,'Student','Accepted','App\\Models\\Course',1,NULL);

/*!40000 ALTER TABLE `enrollments` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table event_types
# ------------------------------------------------------------

DROP TABLE IF EXISTS `event_types`;

CREATE TABLE `event_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `event_types` WRITE;
/*!40000 ALTER TABLE `event_types` DISABLE KEYS */;

INSERT INTO `event_types` (`id`, `title`, `deleted_at`)
VALUES
	(1,'Homework',NULL),
	(2,'Exam',NULL),
	(3,'Quiz',NULL),
	(4,'Project',NULL),
	(5,'Meeting',NULL),
	(6,'General',NULL),
	(7,'Presentation',NULL),
	(8,'Other',NULL);

/*!40000 ALTER TABLE `event_types` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table events
# ------------------------------------------------------------

DROP TABLE IF EXISTS `events`;

CREATE TABLE `events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(190) NOT NULL,
  `desc` mediumtext,
  `location` varchar(190) DEFAULT NULL,
  `start` datetime NOT NULL,
  `end` datetime NOT NULL,
  `all_day` tinyint(1) NOT NULL DEFAULT '0',
  `type_id` int(11) DEFAULT NULL,
  `creator_id` int(11) NOT NULL,
  `resource_key` varchar(32) NOT NULL,
  `color` varchar(7) DEFAULT NULL,
  `priority` enum('1','2','3','4','5') DEFAULT NULL,
  `google_id` mediumtext,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `parent_id` int(11) NOT NULL,
  `parent_type` varchar(190) NOT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `events_resource_key_unique` (`resource_key`),
  KEY `events_owner_id_owner_type_deleted_at_index` (`parent_id`,`parent_type`,`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table failed_queue
# ------------------------------------------------------------

DROP TABLE IF EXISTS `failed_queue`;

CREATE TABLE `failed_queue` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `connection` mediumtext NOT NULL,
  `queue` mediumtext NOT NULL,
  `payload` mediumtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table folders
# ------------------------------------------------------------

DROP TABLE IF EXISTS `folders`;

CREATE TABLE `folders` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `owner_id` int(10) unsigned NOT NULL,
  `owner_type` varchar(190) NOT NULL,
  `resource_key` varchar(32) NOT NULL,
  `name` varchar(190) NOT NULL,
  `parent_id` int(10) unsigned NOT NULL,
  `parent_type` varchar(190) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `available_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `directories_resource_key_unique` (`resource_key`),
  KEY `directories_attachable_id_attachable_type_deleted_at_index` (`parent_id`,`parent_type`,`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table grades
# ------------------------------------------------------------

DROP TABLE IF EXISTS `grades`;

CREATE TABLE `grades` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `grade` decimal(12,6) DEFAULT NULL,
  `related_id` int(10) unsigned NOT NULL,
  `related_type` varchar(255) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `resource_key` varchar(32) NOT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `parent_id` int(10) unsigned NOT NULL,
  `parent_type` varchar(190) NOT NULL,
  `available_date` datetime DEFAULT NULL,
  `owner_type` varchar(190) NOT NULL,
  `owner_id` int(10) NOT NULL,
  `creator_id` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `grades_resource_key_unique` (`resource_key`),
  UNIQUE KEY `grade_unique` (`related_id`,`related_type`,`parent_id`,`parent_type`,`deleted_at`),
  KEY `user_id` (`related_id`),
  KEY `grades_gradeable_id_gradeable_type_index` (`parent_id`,`parent_type`),
  KEY `grades_course_id_deleted_at_index` (`deleted_at`),
  KEY `grades_creator_id_index` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table groups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `groups`;

CREATE TABLE `groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) DEFAULT NULL,
  `name` varchar(190) NOT NULL,
  `resource_key` varchar(32) NOT NULL,
  `permalink` varchar(190) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `type` enum('club','private','secret') NOT NULL DEFAULT 'private',
  `description` mediumtext,
  `locked` tinyint(1) NOT NULL DEFAULT '0',
  `status` enum('approved','denied','pending','archived') NOT NULL DEFAULT 'pending',
  `location` varchar(190) DEFAULT NULL,
  `parent_type` varchar(190) NOT NULL,
  `university_id` int(10) unsigned DEFAULT NULL,
  `available_date` datetime DEFAULT NULL,
  `archive_date` datetime DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `org_contact` varchar(255) DEFAULT NULL,
  `meeting` varchar(255) DEFAULT NULL,
  `listed` tinyint(1) NOT NULL DEFAULT '1',
  `profile_picture` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `groups_resource_key_unique` (`resource_key`),
  UNIQUE KEY `groups_permalink_university_id_deleted_at_unique` (`permalink`,`parent_id`,`deleted_at`),
  KEY `groups_deleted_at_index` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;

INSERT INTO `groups` (`id`, `parent_id`, `name`, `resource_key`, `permalink`, `created_at`, `updated_at`, `deleted_at`, `type`, `description`, `locked`, `status`, `location`, `parent_type`, `university_id`, `available_date`, `archive_date`, `category`, `website`, `org_contact`, `meeting`, `listed`, `profile_picture`)
VALUES
	(1,1,'Honors English','c7cb10ddba81d417d894d119b31d954f','eng-109h','2016-05-13 01:59:41.335066','2018-04-19 04:12:51.641700',NULL,'private',NULL,0,'pending',NULL,'App\\Models\\University',1,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL),
	(2,1,'Fuck English','u2706bd84ab654840ad5767f78f420ed','fuck-109d','2016-05-13 01:59:41.341334','2018-04-19 04:12:51.630200',NULL,'private',NULL,0,'pending',NULL,'App\\Models\\University',1,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL);

/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table invite_groups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `invite_groups`;

CREATE TABLE `invite_groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(190) DEFAULT NULL,
  `code` varchar(190) NOT NULL,
  `help` mediumtext,
  `university_id` int(10) unsigned NOT NULL,
  `resource_key` varchar(32) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invite_groups_code_unique` (`code`),
  UNIQUE KEY `invite_groups_resource_key_unique` (`resource_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table jobs
# ------------------------------------------------------------

DROP TABLE IF EXISTS `jobs`;

CREATE TABLE `jobs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(190) NOT NULL,
  `payload` longtext NOT NULL,
  `result` longtext,
  `percent` double(5,2) NOT NULL DEFAULT '0.00',
  `status` varchar(190) DEFAULT NULL,
  `message` varchar(190) DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  `resource_key` varchar(32) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `outlet` enum('monitor','tether') NOT NULL DEFAULT 'monitor',
  PRIMARY KEY (`id`),
  UNIQUE KEY `jobs_resource_key_unique` (`resource_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table likes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `likes`;

CREATE TABLE `likes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `resource_key` varchar(32) NOT NULL,
  `parent_type` varchar(190) NOT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `likes_resource_key_unique` (`resource_key`),
  KEY `likes_owner_id_owner_type_deleted_at_index` (`parent_id`,`parent_type`,`deleted_at`),
  KEY `likes_parent_id_index` (`parent_id`),
  KEY `likes_parent_type_index` (`parent_type`),
  KEY `likes_deleted_at_index` (`deleted_at`),
  KEY `likes_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `likes` WRITE;
/*!40000 ALTER TABLE `likes` DISABLE KEYS */;

INSERT INTO `likes` (`id`, `parent_id`, `user_id`, `created_at`, `updated_at`, `resource_key`, `parent_type`, `deleted_at`)
VALUES
	(1,1,14,'2018-08-28 00:22:56.088500','2018-08-28 00:22:56.088500','we313ecb37dba45f599960437c86c59a','App\\Models\\Post',NULL),
	(2,2,10,'2018-08-28 00:23:43.965900','2018-08-28 00:23:43.965900','w8f15d0da416e44018a06451e4f2d64a','App\\Models\\Post',NULL),
	(3,2,11,'2018-08-28 00:24:28.206800','2018-08-28 00:24:28.206800','v4248ce55a97f46918d4e9a338b7d336','App\\Models\\Comment',NULL),
	(4,2,11,'2018-08-28 00:24:29.826900','2018-08-28 00:24:29.826900','fb3acf4cd02b44e23b0f931dd2547e72','App\\Models\\Post',NULL),
	(5,1,11,'2018-08-28 00:24:32.285200','2018-08-28 00:24:32.285200','m6811f0cfd7294d6bbe57d7eb74eac50','App\\Models\\Post',NULL),
	(6,3,2,'2018-08-28 00:25:23.503399','2018-08-28 00:25:23.503399','s16f0d5641c1749e38f2530f246d9589','App\\Models\\Post',NULL),
	(7,1,2,'2018-08-28 00:25:26.572900','2018-08-28 00:25:26.572900','d12c3122259d746978548c90418301df','App\\Models\\Post',NULL),
	(8,2,14,'2018-08-28 00:26:19.087200','2018-08-28 00:26:19.087200','ve75e4fd429ff4f0e89b77edbca60f74','App\\Models\\Comment',NULL),
	(9,3,14,'2018-08-28 00:26:20.095500','2018-08-28 00:26:20.095500','u305eee9ec87e47c596b5da8bff38131','App\\Models\\Comment',NULL),
	(10,7,10,'2018-08-28 00:29:15.785700','2018-08-28 00:37:04.750100','e89718922b5da4afb894199de6f90968','App\\Models\\Comment','2018-08-28 00:37:04.750100'),
	(11,5,10,'2018-08-28 00:29:17.234200','2018-08-28 00:37:00.389800','lb3091d6f103d46e4bdd565a6f530e7a','App\\Models\\Comment','2018-08-28 00:37:00.389800'),
	(12,5,10,'2018-08-28 00:29:29.999000','2018-08-28 00:35:09.161100','p760b01cadbab4b61a9355b58b0299e4','App\\Models\\Post','2018-08-28 00:35:09.161100'),
	(13,6,3,'2018-08-28 00:36:31.029000','2018-08-28 00:36:31.029000','df07e6e27dceb4b04b2071840ab5d00d','App\\Models\\Post',NULL),
	(14,6,10,'2018-08-28 00:36:49.808600','2018-08-28 00:36:49.808600','o620f30c116314db088f1fb59e8a5f87','App\\Models\\Post',NULL),
	(15,4,10,'2018-08-28 00:36:52.694100','2018-08-28 00:36:52.694100','a54c46e4cef0b4183ac9a2fc6bece1ac','App\\Models\\Post',NULL),
	(16,5,10,'2018-08-28 00:37:01.933800','2018-08-28 00:37:01.933800','l8d32c7e41a3d450b89caeb30f9746e0','App\\Models\\Comment',NULL),
	(17,7,10,'2018-08-28 00:37:05.643100','2018-08-28 00:37:05.643100','o5478dbd4913645fd894f8077beb5821','App\\Models\\Comment',NULL),
	(18,4,14,'2018-08-28 00:39:53.513800','2018-08-28 00:39:53.513800','g8a90658e9e004ef2844fd02c01e6a57','App\\Models\\Post',NULL),
	(19,7,14,'2018-08-28 00:39:55.911200','2018-08-28 00:39:55.911200','r8930f48279a541b1a09b3da22a6dbf3','App\\Models\\Comment',NULL),
	(20,5,14,'2018-08-28 00:39:57.917600','2018-08-28 00:39:57.917600','z4f38a1260ec441da86d3fa5c4ab219f','App\\Models\\Comment',NULL);

/*!40000 ALTER TABLE `likes` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table machines
# ------------------------------------------------------------

DROP TABLE IF EXISTS `machines`;

CREATE TABLE `machines` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(190) NOT NULL,
  `expires_at` timestamp(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `machines` WRITE;
/*!40000 ALTER TABLE `machines` DISABLE KEYS */;

INSERT INTO `machines` (`id`, `name`, `expires_at`, `created_at`, `updated_at`, `deleted_at`)
VALUES
	(1,'nb-local','2017-06-26 07:16:47.000000','2017-01-24 01:01:30.155000','2017-10-03 09:52:26.326500','2017-10-03 09:52:26.326400'),
	(2,'b7b6565f80db','2017-10-03 09:53:26.000000','2017-10-03 09:52:26.320100','2017-10-25 21:54:12.556500','2017-10-25 21:54:12.556400'),
	(3,'296263dd2821','2017-10-25 21:55:12.000000','2017-10-25 21:54:12.550000','2018-03-26 20:21:51.009600','2018-03-26 20:21:51.009500'),
	(4,'a55ea4d7425f','2018-03-26 20:22:53.000000','2018-03-26 20:21:50.939100','2018-04-05 22:27:36.676900','2018-04-05 22:27:36.676800'),
	(5,'6705ae5b9a18','2018-04-05 22:29:36.000000','2018-04-05 22:27:36.615900','2018-04-12 06:27:46.647900','2018-04-12 06:27:46.647800'),
	(6,'052d8d1bca7a','2018-04-19 04:14:50.000000','2018-04-12 06:27:46.570300','2018-04-23 03:56:21.677200','2018-04-23 03:56:21.677000'),
	(7,'e19f8d20c7f4','2018-04-23 03:58:21.000000','2018-04-23 03:56:21.560900','2018-04-23 23:20:31.888600','2018-04-23 23:20:31.888400'),
	(8,'1e021f6fa963','2018-04-26 23:31:48.000000','2018-04-23 23:20:31.773200','2018-04-30 02:34:16.405200','2018-04-30 02:34:16.405000'),
	(9,'3912ea3d6bf0','2018-04-30 02:36:16.000000','2018-04-30 02:34:16.265900','2018-05-08 23:08:50.502299','2018-05-08 23:08:50.502200'),
	(10,'044fefbd18b6','2018-05-08 23:10:50.000000','2018-05-08 23:08:50.193100','2018-05-31 20:47:44.619700','2018-05-31 20:47:44.619500'),
	(11,'fc5bfae16182','2018-05-31 20:49:44.000000','2018-05-31 20:47:44.484600','2018-06-30 23:04:48.029100','2018-06-30 23:04:48.028900'),
	(12,'a8b15126d54e','2018-06-30 23:09:47.000000','2018-06-30 23:04:47.945700','2018-07-12 22:50:54.325900','2018-07-12 22:50:54.325700'),
	(13,'a7c426e166cf','2018-07-16 22:09:58.000000','2018-07-12 22:50:54.191800','2018-08-05 22:58:27.302700','2018-08-05 22:58:27.302700'),
	(14,'9255c9379982','2018-08-05 23:03:27.000000','2018-08-05 22:58:27.242100','2018-08-21 17:58:59.486400','2018-08-21 17:58:59.486400'),
	(15,'363b8c85dc28','2018-08-21 18:03:59.000000','2018-08-21 17:58:59.412800','2018-08-28 00:02:43.421600','2018-08-28 00:02:43.421600'),
	(16,'da62253136e2','2018-08-28 00:44:27.000000','2018-08-28 00:02:43.376200','2018-08-28 00:39:27.805500',NULL);

/*!40000 ALTER TABLE `machines` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table migrations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `migrations`;

CREATE TABLE `migrations` (
  `migration` varchar(190) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;

INSERT INTO `migrations` (`migration`, `batch`)
VALUES
	('2014_08_18_200200_initial_table_structure',1),
	('2014_08_18_214600_fix_table_structure',1),
	('2014_08_19_001700_remove_submission_columns',1),
	('2014_08_19_002859_add_primary_id_meta',1),
	('2014_08_19_002900_add-expires-to-meta',1),
	('2014_08_22_115100_fix_course_terms',1),
	('2014_09_01_033803_add_remote_origin_refactor_grade_owner',1),
	('2014_09_04_231306_add_assessments_table',1),
	('2014_09_21_092526_add_column_to_hangout',1),
	('2014_09_22_014749_convert_timestamps_to_micro',1),
	('2014_10_06_000055_add_creator_id_assessments_assignments',1),
	('2014_10_06_000057_add_creator_id_assessments',1),
	('2014_10_08_000000_add_questions_table',1),
	('2014_10_08_000947_assessments_default_type',1),
	('2014_10_08_211036_add_question_answers',1),
	('2014_10_10_124623_assessments_default_points',1),
	('2014_11_04_003743_expand_service_and_terms_tables',1),
	('2014_11_04_192955_add_response_score',1),
	('2014_11_21_205301_hangout_url_to_text_field',1),
	('2014_12_03_024328_fix_unique_columns_on_courses',1),
	('2014_12_04_113212_settings_polymorphic',1),
	('2014_12_10_173955_university_to_standard',1),
	('2014_12_12_090048_add_users_unique_constraints',1),
	('2014_12_25_065953_support_course_registration',1),
	('2015_01_07_211230_add_no_response_answer',1),
	('2015_01_19_221934_add_submission_closed_field',1),
	('2015_01_21_205258_add_user_origin_column',1),
	('2015_01_23_214220_add_assessment_cron_field',1),
	('2015_02_06_075526_add_indexes',1),
	('2015_03_12_193146_add_assignment_group_table',1),
	('2015_03_30_063525_add-link-tracker',1),
	('2015_04_14_134911_add_drop_lowest',1),
	('2015_04_16_100711_fix_deleted_submissions',1),
	('2015_04_18_073954_create_user_login_table',1),
	('2015_04_29_073156_update_yt_thumbnails',1),
	('2015_07_14_215221_add_assignment_dicussion_properties',1),
	('2015_08_12_160405_translate_service_ids',1),
	('2015_08_30_191945_addTypeToUsersColumn',1),
	('2015_09_05_203833_addCourseMetaResourceKey',1),
	('2015_09_20_230423_all_tables_softdelete',1),
	('2015_09_24_203239_add_self_grading_assignments',1),
	('2015_10_14_152739_create_jobs_table',1),
	('2015_10_20_122059_fix-tables',1),
	('2015_10_20_132544_createActivityTable',1),
	('2015_10_24_182716_addUniversityAdmin',1),
	('2015_10_26_231451_fix_response_duplicates',1),
	('2015_11_03_181610_AddAssessmentSubmissionScoreVerifiedField',1),
	('2015_11_05_221412_signupMigration',1),
	('2015_11_23_133421_dropMediaTable',1),
	('2015_12_03_145218_removeMediaTable',1),
	('2015_12_07_174434_addQuesitonIdToAssessmentResponse',1),
	('2015_12_09_163326_dropGoogleDriveTable',1),
	('2015_12_09_183133_dropRememberColumn',1),
	('2015_12_14_232953_fixAttachmentMetaName',1),
	('2016_01_05_080731_gradeToPolly',1),
	('2016_01_06_205732_add_submission_column_to_grades',1),
	('2016_01_06_231218_dropUsernameColumn',1),
	('2016_01_15_035301_fixUniqueServiceItems',1),
	('2016_01_18_231914_addPerformanceIndexes',1),
	('2016_01_26_182101_migrateDeletedGrades',1),
	('2016_01_27_155145_addLogoColumnsToUniversity',1),
	('2016_02_01_221808_addUniversityIdToSessions',1),
	('2016_02_04_175556_dropDuplicateSubmissions',1),
	('2016_02_08_154915_addFirstLastNameSupport',1),
	('2016_02_09_212723_initPermissionsTable',1),
	('2016_02_15_163545_fixDiscussionBoardPendingUserSubmissions',1),
	('2016_03_08_225909_fixMetaTypes',1),
	('2016_03_22_183426_fixNullables',1),
	('2016_04_03_210815_updateDeviceTable',1),
	('2016_04_04_032918_changeToDoubles',1),
	('2016_04_08_022853_addResourceKeySetting',1),
	('2016_04_09_212319_mobileSessions',1),
	('2016_04_13_001718_addResourceKeytoAttachmentMeta',1),
	('2016_04_19_225711_nullablePassword',1),
	('2016_04_20_101854_fixMobileUniqueConstraint',1),
	('2016_04_21_141511_computedProperties',1),
	('2016_04_23_000425_settingsFlatten',1),
	('2016_04_25_154859_cleanupNullableItems',1),
	('2016_04_26_190751_cleanAttachments',1),
	('2016_04_29_164149_migrateBooks',1),
	('2016_04_30_094440_migrateCourseMetas',1),
	('2016_05_02_183031_computedValueToText',1),
	('2016_05_06_054402_createSubDir',1),
	('2016_05_09_185927_updateSettingNames',1),
	('2016_05_16_150155_supportExpiredSessions',2),
	('2016_05_16_200003_dropTask',2),
	('2016_05_12_122217_courseGroups',3),
	('2016_05_18_020120_addResourceColumn',3),
	('2016_05_24_172107_patchNullDate',4),
	('2016_05_25_073146_removeImageWidth',5),
	('2016_01_09_005537_gradeNullable',6),
	('2016_06_08_172946_removeNullResponses',6),
	('2016_06_10_023001_removeIsScored',6),
	('2016_06_10_025505_categoryFloat',6),
	('2016_06_16_103200_renameAttachmentColumn',6),
	('2016_06_17_175942_addFillInTheBlank',6),
	('2016_07_01_104100_renameLikeColumn',6),
	('2016_07_02_134700_renamePostColumn',6),
	('2016_07_19_101400_removeAssignmentGroupGrade',6),
	('2016_07_27_175800_removeViewSettings',6),
	('2016_07_28_234226_convertAttachmentMetas',6),
	('2016_07_31_204038_universityServicesNullable',6),
	('2016_08_01_235430_removeYoutubeSubscriptions',6),
	('2016_08_03_214511_createSignupsTable',6),
	('2016_08_16_173547_removeCourseMeta',6),
	('2016_08_21_131000_updateNotificationLikes',6),
	('2016_08_26_183941_addTextToNotificationUsers',6),
	('2016_08_30_194300_renameDirectories',6),
	('2016_08_30_210900_documentsMigration',6),
	('2016_09_08_214616_changeAssignmentType',6),
	('2016_09_08_225930_courseUnitsNullable',6),
	('2016_09_13_002947_googleHangoutMigration2',6),
	('2016_09_16_144354_removeGoogleHangoutNotifications',6),
	('2016_09_21_034800_fixAttachmentMeta',6),
	('2016_09_22_181213_introduceAbuseReports',6),
	('2016_09_22_210321_addIndexes',6),
	('2016_09_28_211843_fixGradeValueResolution',6),
	('2016_09_30_014140_removeIsCorrectAssessmentResponse',6),
	('2016_09_30_035121_fixNotificationsDefaults',6),
	('2016_09_30_123400_addEditedAt',6),
	('2016_10_01_083131_upgradeLinkClicksToAnalyitcs',6),
	('2016_10_03_221923_universityGroupSetting',6),
	('2016_10_04_134554_fixAttachmentMetas',6),
	('2016_10_06_162351_universityAcceptedDomain',6),
	('2016_10_14_213045_addUniversityTimezone',6),
	('2016_10_17_141126_introduce_email_logs',6),
	('2016_10_20_191242_fix_calendar_datetime',6),
	('2016_10_26_184156_changeAssessmentAnswerWeight',6),
	('2016_10_31_234838_removeBadNotification',6),
	('2016_11_01_234504_addUserPermissions',6),
	('2016_11_06_214721_updateJobsTable',6),
	('2016_11_08_001100_fixGroupType',6),
	('2016_10_28_201950_changeAssessmentQuestionPoints',7),
	('2016_11_09_225757_realignJobs',7),
	('2016_11_12_212500_eventOwnerToParent',7),
	('2016_11_13_061308_fuckGoogleCalendar',7),
	('2016_11_22_191511_universityPermalinkUnique',7),
	('2016_11_23_234737_machinesTable',7),
	('2016_12_13_035337_fixIsAssignment',7),
	('2016_12_13_084104_removeComputedProperties',7),
	('2016_12_15_065535_renameJobProperty',7),
	('2017_01_01_234536_enableAllBookLinks',7),
	('2017_01_09_033934_usersPrimaryEmailUnique',7),
	('2017_01_09_215233_courseAvailableDate',7),
	('2017_01_10_104118_resetTimezone',7),
	('2017_01_12_073050_fix_permalink',7),
	('2017_01_13_161841_fixTosDefault',7),
	('2017_01_17_154119_addIndexesToSessions',7),
	('2017_01_26_074033_autoEnroll',8),
	('2017_01_26_105809_burnReminders',9),
	('2017_01_02_073029_assignmentsGradePublish',10),
	('2017_01_31_213738_cleanupGrades',10),
	('2017_02_03_092341_updateIndexes',10),
	('2017_02_08_083913_jobPayloadLongText',10),
	('2017_02_09_174616_indexCommentsTable',10),
	('2017_02_09_232714_removeNotificationWatchers',10),
	('2017_02_15_221533_flattenCourseCategories',10),
	('2017_02_02_201441_commentTextNullable',11),
	('2017_02_20_224155_eventsChangeAllDay',12),
	('2017_02_23_093308_addOriginToGroups',12),
	('2017_03_02_213053_updateGroupProperties',12),
	('2017_02_28_093801_attachmentParentRequired',13),
	('2017_03_08_224416_fixDiscussionBoardPermissions',13),
	('2017_03_09_060111_convertSubmissions',13),
	('2017_03_09_195231_updateActivityTable',14),
	('2017_03_10_204001_cleanupGradesTable',15),
	('2017_03_13_075544_fixNotifications',15),
	('2017_03_15_181804_migrateAttachments',16),
	('2017_03_16_165728_moveStudentGradeToEnum',17),
	('2017_03_17_065436_supportParentLogins',17),
	('2017_03_23_042356_removeReservation',17),
	('2017_03_03_000742_postPinned',18),
	('2017_03_22_194649_eventUserUniqueConstraint',18),
	('2017_04_06_200306_convertUnitsToFloat',18),
	('2017_04_08_002039_fixShit',18),
	('2017_04_11_183414_notificationParent',18),
	('2017_04_11_203813_changeGroupMaxDefault',18),
	('2017_04_12_050421_attachmentMetasTextLong',18),
	('2017_04_12_052005_updateServices',18),
	('2017_04_13_223406_sessionTrackUserEmailLogins',18),
	('2017_04_24_162900_removeHelpText',19),
	('2017_04_25_120300_removeDeadQuestionFields',19),
	('2017_05_02_064014_deleteBadNotifications',19),
	('2017_05_09_194110_addRestrictionsToAssessmentResponses',19),
	('2017_05_12_042104_notificationParentMerge',19),
	('2017_05_16_000955_fixUniqueConstraint',19),
	('2017_05_18_204749_createStarredGroupSetting',19),
	('2017_05_26_121900_clubFields',20),
	('2017_05_29_225203_add-location',20),
	('2017_06_06_191322_dropCategories',21),
	('2017_06_18_100358_addMoreIndexes',21),
	('2017_06_18_102101_addMoreIndexes2',21),
	('2017_06_19_082216_enableDomainSSO',21),
	('2017_06_22_012411_convertAssignmentParent',21),
	('2017_07_03_170100_courseUserRoleStatus',22),
	('2017_07_03_232000_groupUserRole',23),
	('2017_07_04_121800_courseUserMorphable',24),
	('2017_07_04_150200_courseUserEnrollment',25),
	('2017_07_04_194400_groupUserMorphable',26),
	('2017_07_05_111400_groupUserEnrollment',27),
	('2017_07_05_220100_groupMorphable',28),
	('2017_07_06_115700_assignmentGroupAlignment',29),
	('2017_07_06_183300_assignmentGroupUserAlignment',30),
	('2017_07_07_105300_eventUserMorphable',31),
	('2017_07_07_184600_eventUserEnrollment',32),
	('2017_07_07_065638_updateServiceItems',33),
	('2017_07_12_130454_addUniversityIdToGroup',33),
	('2017_07_14_140515_updateEventName',33),
	('2017_07_14_033351_notificationFlag',34),
	('2017_07_17_215524_gradeAvailableDate',34),
	('2017_07_19_150527_fixCourseUserReferences',34),
	('2017_07_20_211900_unusedGradeColumns',34),
	('2017_07_21_131800_alignGradeColumns',35),
	('2017_07_21_184500_assessmentResponseScore',36),
	('2017_07_22_193800_assessmentSubmissionScore',37),
	('2017_07_25_205300_assessmentSubmissionAutogen',38),
	('2017_07_20_213425_profilePictures',39),
	('2017_07_28_173204_convertAvailableDates',39),
	('2017_07_27_134100_anonymousComment',40),
	('2017_07_30_155105_sendDomainEmails',40),
	('2017_07_29_145100_postAvailableDate',41),
	('2017_07_30_224451_payments',41),
	('2017_07_31_205200_assessmentOrderColumns',41),
	('2017_08_02_084542_enableGoogleSubmissions',41),
	('2017_08_04_025249_removeModels',41),
	('2017_08_07_013634_addApiTokenUser',41),
	('2017_08_10_165956_removeResourceKey',41),
	('2017_08_11_132900_fixDeletedSubmissionGrades',41),
	('2017_08_14_202112_exemptPastStudents',41),
	('2017_08_16_163752_fixIntercom',42),
	('2017_08_17_102727_fixActivityTable',42),
	('2017_08_17_191154_fixBrokenFolders',42),
	('2017_08_21_174720_fix-jobs',42),
	('2017_08_21_192941_addGroupColumns',42),
	('2017_08_22_071536_nullableFirstNameLastName',43),
	('2017_08_24_150418_speedUp',43),
	('2017_08_25_221452_disableTAGradesPerUniversity',43),
	('2017_08_27_215112_renamePermission',43),
	('2017_08_27_230814_addEvenMoreIndexes',43),
	('2017_08_28_152553_fixAssignmentAvailableDate',43),
	('2017_08_28_175810_fixNullNames',44),
	('2017_08_29_214347_assignmentDueDate',44),
	('2017_09_01_141400_submissionTextColumn',44),
	('2017_09_01_221438_abusesAlignment',44),
	('2017_09_03_082019_convertAssessmentToPolly',44),
	('2017_09_06_033439_assessmentQuestionDescription',44),
	('2017_09_12_212947_fixMobileTable',44),
	('2017_09_20_155724_assignmentRestrictUploads',44),
	('2017_09_27_205958_gradesCreatorFix',44),
	('2017_09_29_160000_postsOwner',44),
	('2017_10_03_074720_assessmentSubmissionIndex',44),
	('2017_10_08_233838_addEmailNotifyToService',45),
	('2017_10_09_090407_addUniversityIdIndexToUsers',45),
	('2017_10_21_045459_convertToUTF8MB4',45),
	('2017_10_22_042351_permissionsMod',45),
	('2017_08_31_213555_assignmentDefaultValues',46),
	('2017_10_27_104148_lockedAssessments',47),
	('2017_10_27_200559_modelProperties',47),
	('2017_11_01_155630_removeIdentifier',47),
	('2017_09_20_152523_downloadSettingsToProperty',48),
	('2017_11_05_122130_addTokenToService',48),
	('2017_11_06_200638_assessmentEnumConversion',48),
	('2017_11_06_232541_abuseEnumConversion',48),
	('2017_11_07_200128_analyticEnumConversion',48),
	('2017_11_08_201720_groupEnumConversion',48),
	('2017_11_10_195119_courseTabEnabledSetting',48),
	('2017_11_15_201720_assessmentQuestionFileSupport',49),
	('2017_11_06_161359_addActionTypeToAssessment',50),
	('2017_11_14_065251_queueMigration',50),
	('2017_11_15_201720_groupEnumSupport',50),
	('2017_11_20_101600_assignmentGradeType',50),
	('2017_11_21_082429_addClubsContact',50),
	('2017_11_22_155205_addCategoriesToGroups',50),
	('2017_11_30_073600_addPointsEnabled',50),
	('2017_11_30_132800_assessmentGradeType',50),
	('2017_12_07_083000_removeWeightColumn',50),
	('2017_12_11_153701_expandDefaultSupportType',50),
	('2017_12_13_175236_addProeprties',50),
	('2017_12_14_093100_gradeMatrixSettings',50),
	('2017_12_14_184451_cleanupMetas',50),
	('2017_12_14_201647_renameModelUserProperties',50),
	('2017_12_14_220606_dropNotificationUserStatus',50),
	('2017_12_16_124200_letterGradeAsPercentage',50),
	('2017_12_16_212504_addGradebookDefaults',50),
	('2017_12_16_223035_migrateGradebookSettings',50),
	('2017_12_21_221632_removeNotificationPublished',50),
	('2018_01_03_213908_gradesUserIdUnique',50),
	('2018_01_05_174321_cleanupCourseScale',50),
	('2018_01_05_182242_removeAssessmentSettings',50),
	('2018_01_05_210702_moveGroupStarred',50),
	('2018_01_10_061919_stripeCustomer',50),
	('2018_01_12_152839_fixModelUserProperties',51),
	('2018_01_12_152900_folderAttachmentSortValuesSettings',51),
	('2018_01_12_212857_userProfilePictureResetDefault',51),
	('2018_01_17_222150_retryGradesMigration',51),
	('2018_01_19_082000_dropDocumentSortSettings',51),
	('2018_01_19_083033_deleteDeadCourse',51),
	('2018_01_19_184956_fixGradeOnlyAssignmentAvailableDate',51),
	('2018_01_22_182119_makeNotifciationTextComaptibleWithPosts',51),
	('2018_01_18_201307_notificationConvertContext',52),
	('2018_01_22_164200_dropUnusedSettingColumns',52),
	('2018_01_25_003826_logSocketNotifications',52),
	('2018_01_25_210752_notificationUsersDropText',52),
	('2018_01_27_220745_fixMobileTable',52),
	('2018_01_29_183556_cleanupS3Paths',52),
	('2018_01_30_195147_convertSocketsTable',52),
	('2018_02_05_160801_stripeCleanup',52),
	('2018_02_09_074452_anotherFix',52),
	('2018_02_13_175539_addActivityIndexes',53),
	('2018_02_14_193427_preventDuplicateCaches',53),
	('2018_02_15_051209_fixUserAdminDefault',53),
	('2018_02_16_043555_fixActionLogsVerb',53),
	('2018_02_19_215216_gradYear',53),
	('2018_02_22_223646_addEmailIndex',53),
	('2018_02_23_052303_AttachmentExtensionCleanup',53),
	('2018_03_01_002429_addSocketIndexes',53),
	('2018_02_20_195437_addCourseEndDate',54),
	('2018_02_27_215239_addUserLastLogin',54),
	('2018_03_02_053328_addClubRestrictions',54),
	('2018_03_05_164826_removeQueueTable',54),
	('2018_03_06_222829_analyticsSupport',54),
	('2018_03_07_072303_AttachmentExtensionCleanupPt2',54),
	('2018_02_01_194521_assignmentGroupsLocked',55),
	('2018_03_06_210550_convertExtensionRestrictions',56),
	('2018_03_08_071303_convertToDateTime',56),
	('2018_03_08_233428_prodFixRestoreGrades',56),
	('2018_03_12_204906_restoreDeletedEnrollment',56),
	('2018_03_13_200755_addFlags',56),
	('2018_03_23_012825_paywall_confirm',56),
	('2018_03_20_214014_add_grades_published_assessments',57),
	('2018_03_27_172900_gradeScaleSeparator',57),
	('2018_03_27_191350_addIntercomKey',57),
	('2018_03_30_170300_submissionTypeEnum',58),
	('2018_03_30_225638_remove_bad_attachments',58),
	('2018_04_01_022910_addSocketsIndex',58),
	('2018_04_06_231923_renameorgcontract',59),
	('2018_04_07_000550_global_resource_keys',59),
	('2018_04_10_175532_enableCourses',59),
	('2018_04_04_222915_grades_related',60),
	('2018_04_10_175532_publishCourses',60),
	('2018_04_12_224506_remove_broken_posts',60),
	('2018_04_13_033716_resolveCourseRoundingIssue',60),
	('2018_04_14_234408_fixGradesTable',60),
	('2018_04_16_171428_supportEmailBouncing',60),
	('2018_04_16_210337_convertResourceKeysToJSCompat',60),
	('2018_04_18_225217_grades_admin_creator_id',60),
	('2018_04_19_185129_fixAnalyticProperty',61),
	('2018_04_20_211833_verifyEmail',61),
	('2018_04_22_235405_convertUniversityClassName',61),
	('2018_04_16_203808_posts_add_related',62),
	('2018_04_24_172133_updateActivityLog',63),
	('2018_04_25_223755_posts_swap_parent',63),
	('2018_04_27_215614_updateDateLog',64),
	('2018_05_01_030916_fixDevices',65),
	('2018_05_09_194912_addJobOutlet',66),
	('2018_05_10_171127_fixEmailReportsTableNullable',66),
	('2018_05_28_022335_switchDB',66),
	('2018_05_31_200128_convertLastAccessAt',66),
	('2018_05_31_055038_cleanupServiceItemTable',67),
	('2018_06_01_041057_changePublishedDefault',67),
	('2018_06_01_215848_removeBadEnrollmentNotifications',67),
	('2018_06_05_231557_removeRRule',67),
	('2018_06_06_215403_convertUsersLastLoginDate',67),
	('2018_06_07_011556_updateWebauthService',67),
	('2018_06_25_133100_settingParentToCreator',67),
	('2018_07_12_201129_convert_assessment_type',68),
	('2018_07_15_223242_convert_assignments_type',69),
	('2018_07_16_012049_convert_other_type',69),
	('2018_07_16_054316_morph_class_type',69),
	('2018_07_23_180100_remove_invalid_grade_scheme',70),
	('2018_07_24_191020_addPicturesToCoursesGroups',70),
	('2018_07_27_133000_group_max_required',70),
	('2018_07_27_203135_fixProfilePictureDefaults',70),
	('2018_08_01_173543_addIndexes',70),
	('2018_08_05_225607_removeLocationField',70),
	('2018_08_06_042416_convertEnrollmentStatusEnum',71),
	('2018_08_06_210307_add_question_extra_credit',71),
	('2018_08_13_230720_anonymousDiscussionBoard',71),
	('2018_08_22_213625_introduceConferenceAttachments',72);

/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table model_properties
# ------------------------------------------------------------

DROP TABLE IF EXISTS `model_properties`;

CREATE TABLE `model_properties` (
  `parent_id` int(10) unsigned NOT NULL,
  `parent_type` varchar(255) NOT NULL,
  `key` varchar(190) NOT NULL,
  `value` longtext,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `expires_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `attachment_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `model_properties` WRITE;
/*!40000 ALTER TABLE `model_properties` DISABLE KEYS */;

INSERT INTO `model_properties` (`parent_id`, `parent_type`, `key`, `value`, `deleted_at`, `created_at`, `updated_at`, `id`, `expires_at`)
VALUES
	(1,'App\\Models\\Attachment','sort_value','N;',NULL,'2018-08-28 00:05:20.848100','2018-08-28 00:05:20.848100',1,NULL),
	(1,'App\\Models\\Attachment','is_required','b:1;',NULL,'2018-08-28 00:05:20.857400','2018-08-28 00:05:20.857400',2,NULL),
	(1,'App\\Models\\Attachment','recommend_amazon','b:1;',NULL,'2018-08-28 00:05:20.862500','2018-08-28 00:05:20.862500',3,NULL),
	(1,'App\\Models\\Attachment','recommend_apple','b:1;',NULL,'2018-08-28 00:05:20.866700','2018-08-28 00:05:20.866700',4,NULL),
	(1,'App\\Models\\Attachment','description','s:405:\"Arny: Explorations-An Introduction to Astronomy, 6th edition, is built on the foundation of its well known writing style, accuracy, and emphasis on current information. This new edition continues to offer the most complete technology/new media support package available. That technology/new media package includes: Interactives, Animations, and introducing Connect - online homework and course management.\";',NULL,'2018-08-28 00:05:20.876800','2018-08-28 00:05:20.876800',5,NULL),
	(1,'App\\Models\\Attachment','authors','s:29:\"Thomas Arny:Stephen Schneider\";',NULL,'2018-08-28 00:05:20.883700','2018-08-28 00:05:20.883700',6,NULL),
	(1,'App\\Models\\Attachment','page_count','i:571;',NULL,'2018-08-28 00:05:20.889000','2018-08-28 00:05:20.889000',7,NULL),
	(1,'App\\Models\\Attachment','thumbnail','s:124:\"https://notebowl.s3.amazonaws.com/books/vfc60395a035d41069bf6f8263557350/cache/jVC4atf0GLdVGXj0YxInE9OGj7CAFQJdEX4P010M.jpeg\";',NULL,'2018-08-28 00:05:20.894500','2018-08-28 00:05:20.894500',8,NULL),
	(1,'App\\Models\\Attachment','recommend_amazon_link','s:201:\"https://www.amazon.com/Explorations-Introduction-Astronomy-Thomas-Arny/dp/0077345096?SubscriptionId=AKIAIBUZHF7H3AOYGP3A&tag=notebowl01-20&linkCode=xm2&camp=2025&creative=165953&creativeASIN=0077345096\";',NULL,'2018-08-28 00:05:20.897300','2018-08-28 00:05:20.897300',9,NULL),
	(1,'App\\Models\\Attachment','recommend_apple_link','N;',NULL,'2018-08-28 00:05:20.901500','2018-08-28 00:05:20.901500',10,NULL);

/*!40000 ALTER TABLE `model_properties` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table model_user_properties
# ------------------------------------------------------------

DROP TABLE IF EXISTS `model_user_properties`;

CREATE TABLE `model_user_properties` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `parent_id` int(10) unsigned NOT NULL,
  `parent_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_model_properties_parent_id_parent_type_index` (`parent_id`,`parent_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `model_user_properties` WRITE;
/*!40000 ALTER TABLE `model_user_properties` DISABLE KEYS */;

INSERT INTO `model_user_properties` (`id`, `user_id`, `parent_id`, `parent_type`, `key`, `value`, `created_at`, `updated_at`, `deleted_at`)
VALUES
	(1,1,1,'App\\Models\\Post','collapsed','N;','2018-08-28 00:21:09','2018-08-28 00:21:09',NULL),
	(2,14,2,'App\\Models\\Post','collapsed','N;','2018-08-28 00:22:53','2018-08-28 00:22:53',NULL),
	(3,11,3,'App\\Models\\Post','collapsed','N;','2018-08-28 00:24:44','2018-08-28 00:24:44',NULL),
	(4,2,4,'App\\Models\\Post','collapsed','N;','2018-08-28 00:25:20','2018-08-28 00:25:20',NULL),
	(5,3,5,'App\\Models\\Post','collapsed','N;','2018-08-28 00:27:58','2018-08-28 00:27:58',NULL),
	(6,3,6,'App\\Models\\Post','collapsed','N;','2018-08-28 00:35:54','2018-08-28 00:35:54',NULL);

/*!40000 ALTER TABLE `model_user_properties` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table notification_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `notification_users`;

CREATE TABLE `notification_users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `notification_id` int(11) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `notification_id` (`notification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table notifications
# ------------------------------------------------------------

DROP TABLE IF EXISTS `notifications`;

CREATE TABLE `notifications` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `resource_key` varchar(32) NOT NULL,
  `type` varchar(190) NOT NULL,
  `parent_type` varchar(190) NOT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `parent_id` int(11) NOT NULL,
  `owner_id` int(10) unsigned NOT NULL,
  `owner_type` varchar(255) NOT NULL,
  `creator_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `notifications_resource_key_unique` (`resource_key`),
  KEY `notifications_owner_id_owner_type_index` (`owner_id`,`owner_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table payments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `payments`;

CREATE TABLE `payments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned NOT NULL,
  `parent_type` varchar(190) NOT NULL,
  `paid` double(6,2) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `stripe_id` varchar(190) NOT NULL,
  `resource_key` varchar(255) NOT NULL,
  `refunded` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payments_resource_key_unique` (`resource_key`),
  KEY `payments_parent_id_parent_type_index` (`parent_id`,`parent_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table permission_user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `permission_user`;

CREATE TABLE `permission_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `permission_id` int(10) unsigned NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `scope` varchar(255) DEFAULT 'global',
  PRIMARY KEY (`id`),
  UNIQUE KEY `permission_user_permission_id_user_id_unique` (`permission_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table permissions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `permissions`;

CREATE TABLE `permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `model_type` varchar(190) NOT NULL,
  `model_id` int(10) unsigned DEFAULT NULL,
  `action` enum('get','create','edit','delete','admin') NOT NULL,
  `grant` enum('allow','deny') NOT NULL DEFAULT 'allow',
  `resource_key` varchar(32) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_resource_key_unique` (`resource_key`),
  KEY `permissions_model_type_model_id_action_grant_deleted_at_index` (`model_type`,`model_id`,`action`,`grant`,`deleted_at`),
  KEY `permissions_model_type_model_id_deleted_at_index` (`model_type`,`model_id`,`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table posts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `posts`;

CREATE TABLE `posts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `text` mediumtext,
  `user_id` int(10) unsigned NOT NULL,
  `parent_id` int(10) unsigned NOT NULL,
  `parent_type` varchar(190) NOT NULL,
  `anonymous` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `resource_key` varchar(32) NOT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `edited_at` timestamp(6) NULL DEFAULT NULL,
  `pinned` tinyint(1) NOT NULL DEFAULT '0',
  `available_date` datetime DEFAULT NULL,
  `owner_id` int(10) unsigned NOT NULL,
  `owner_type` varchar(190) NOT NULL,
  `related_id` int(10) unsigned NOT NULL,
  `related_type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `posts_resource_key_unique` (`resource_key`),
  KEY `attachable` (`parent_id`,`parent_type`),
  KEY `posts_parent_id_index` (`parent_id`),
  KEY `posts_parent_type_index` (`parent_type`),
  KEY `posts_deleted_at_index` (`deleted_at`),
  KEY `posts_available_date_index` (`available_date`),
  KEY `searchable` (`parent_id`,`parent_type`,`available_date`),
  KEY `posts_owner_id_owner_type_index` (`owner_id`,`owner_type`),
  KEY `posts_related_id_related_type_index` (`related_id`,`related_type`),
  KEY `posts_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;

INSERT INTO `posts` (`id`, `text`, `user_id`, `parent_id`, `parent_type`, `anonymous`, `created_at`, `updated_at`, `resource_key`, `deleted_at`, `edited_at`, `pinned`, `available_date`, `owner_id`, `owner_type`, `related_id`, `related_type`)
VALUES
	(1,'Elon Musk knows how to market space technology with sending a rocket with a \"Starman\" on a Tesla Roadster. A must see!',1,3,'App\\Models\\Course',0,'2018-08-28 00:21:09.203400','2018-08-28 00:21:13.836300','a94879b1c3b8e482babd7d8141d0d269',NULL,NULL,1,'2018-08-28 00:21:07',3,'App\\Models\\Course',3,'App\\Models\\Course'),
	(2,'I\'m having trouble understanding the different types of radiation. Can we go over that Monday?',14,3,'App\\Models\\Course',0,'2018-08-28 00:22:52.530000','2018-08-28 00:22:52.530000','jf4547db62c1e4a309a85db18fbaf4a8',NULL,NULL,0,'2018-08-28 00:22:50',3,'App\\Models\\Course',3,'App\\Models\\Course'),
	(3,'I need help with yesterday\'s lecture. Can someone please share their notes?',11,3,'App\\Models\\Course',0,'2018-08-28 00:24:44.315100','2018-08-28 00:24:44.315100','oba9021da33144e3aa35ea346c95a083',NULL,NULL,0,'2018-08-28 00:24:42',3,'App\\Models\\Course',3,'App\\Models\\Course'),
	(4,'Hey class - I am having trouble digesting the content in chapter 3 on what black hole formation looks like in Newtonian gravitation theory and how that differs from the relativistic case, can anyone help explain what this means?',2,3,'App\\Models\\Course',0,'2018-08-28 00:25:20.376000','2018-08-28 00:25:20.376000','re1ac9f174d0c4febb2d48e4075ce4cf',NULL,NULL,0,'2018-08-28 00:25:18',3,'App\\Models\\Course',3,'App\\Models\\Course'),
	(5,'Remember: make sure to check the assignment for tomorrow and ask questions below here.',3,3,'App\\Models\\Course',0,'2018-08-28 00:27:57.996600','2018-08-28 00:35:09.211300','c0c0908f08fb24edaa443172b7d8ff10','2018-08-28 00:35:09.211300','2018-08-28 00:28:25.367000',0,'2018-08-28 00:27:55',3,'App\\Models\\Course',3,'App\\Models\\Course'),
	(6,'Hi Class! Let\'s expand on our lecture from earlier today, how does social media impact politics and the news? What\'s a great example of this?',3,4,'App\\Models\\Course',0,'2018-08-28 00:35:54.170800','2018-08-28 00:35:54.170800','tcc103f3018c9471caae122e1b4630c0',NULL,NULL,0,'2018-08-28 00:35:52',4,'App\\Models\\Course',4,'App\\Models\\Course');

/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table resource_aliases
# ------------------------------------------------------------

DROP TABLE IF EXISTS `resource_aliases`;

CREATE TABLE `resource_aliases` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `resource_id` int(10) unsigned NOT NULL,
  `resource_type` varchar(190) NOT NULL,
  `resource_key` varchar(32) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `resource_aliases_resource_key_unique` (`resource_key`),
  KEY `resource_aliases_resource_id_resource_type_index` (`resource_id`,`resource_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table resource_keys
# ------------------------------------------------------------

DROP TABLE IF EXISTS `resource_keys`;

CREATE TABLE `resource_keys` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned NOT NULL,
  `parent_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `resource_key` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `resource_keys_parent_id_parent_type_index` (`parent_id`,`parent_type`),
  KEY `resource_keys_resource_key_index` (`resource_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `resource_keys` WRITE;
/*!40000 ALTER TABLE `resource_keys` DISABLE KEYS */;

INSERT INTO `resource_keys` (`id`, `parent_id`, `parent_type`, `resource_key`, `created_at`, `updated_at`)
VALUES
	(1,4,'App\\Models\\Category','bcaf3accf235949f6a4b434fc2ddc4e5','2018-04-12 06:27:47','2018-04-19 04:12:51'),
	(2,2,'App\\Models\\Category','rfb67c458083e4b83bc45ec430ca4089','2018-04-12 06:27:47','2018-04-19 04:12:51'),
	(3,9,'App\\Models\\Category','ejoiTEukcBybR3fxjQESE2NaRqCt9cDw','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(4,1,'App\\Models\\Category','IAhx3EZbQ3TVtxx2Wz2rVBk2a6n98mzk','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(5,3,'App\\Models\\Category','j3PrnbgCcibTNPoRFdkPyXcOoDzG4PnG','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(6,10,'App\\Models\\Category','lGqePt4kZllalZUiWOQOjFFsT6F9iRIW','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(7,7,'App\\Models\\Category','lNg6cYYn3AVW5uddU0sThzstBvuMrYlR','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(8,6,'App\\Models\\Category','qCf737TC9MWj1AKQ7wGuR3ehcMacj0SW','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(9,8,'App\\Models\\Category','wKai1Ccja7izDE8Bu8ceK6gwMhZoJ9tj','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(10,5,'App\\Models\\Category','zy6DCR3BlE8E9gpoHEvJ4HwXipuRItqa','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(16,1,'App\\Models\\Course','bOVgMXqceI7050G5oNQI8G7TgALRy5gz','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(17,2,'App\\Models\\Course','oP8ByiAzFX6MQ8eSlsoNzPoYBQgXWrci','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(19,19,'App\\Models\\Enrollment','j5ea050b6cb6541bd89ceef393023418','2018-04-12 06:27:47','2018-04-19 04:12:51'),
	(20,10,'App\\Models\\Enrollment','s1182db63eaf24707ba5640d0b2ca339','2018-04-12 06:27:47','2018-04-19 04:12:51'),
	(21,9,'App\\Models\\Enrollment','w727f11df92414233842d2f448753acc','2018-04-12 06:27:47','2018-04-19 04:12:51'),
	(22,15,'App\\Models\\Enrollment','q6d73854180724f598e304942c07f1be','2018-04-12 06:27:47','2018-04-19 04:12:51'),
	(23,1,'App\\Models\\Enrollment','e3299ca780a4943429cf2406a32e8f44','2018-04-12 06:27:47','2018-04-19 04:12:51'),
	(24,21,'App\\Models\\Enrollment','c4b19870b05444e52af11c1e696496d7','2018-04-12 06:27:47','2018-04-19 04:12:51'),
	(25,22,'App\\Models\\Enrollment','aYe85WKUhhkxUGug4G5nEDHi4bCx9rBY','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(26,11,'App\\Models\\Enrollment','cKeG7JwcE4vfhdvKvsP2v6z0haOg9dfm','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(27,5,'App\\Models\\Enrollment','CTYj90xHVSYMuB1UW05SbstexZQVaSgZ','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(28,12,'App\\Models\\Enrollment','HjxiEGmoK0drMzsUPJknU6gAMvnAIXMk','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(29,20,'App\\Models\\Enrollment','hU0A8Y63a24A8LArx7CQurZSxbcADJ8R','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(30,13,'App\\Models\\Enrollment','i1PtfbckebEZDLaI0airxxsIl4sZKJWi','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(31,14,'App\\Models\\Enrollment','kTL1B7sR2biwCISTzRMQIrGnDUG2ZB3l','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(32,2,'App\\Models\\Enrollment','lM8sGHB9d0yFvTxDhe1q935Fk3QAiFBg','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(33,6,'App\\Models\\Enrollment','m5M9BD1S5HVPpNnZ61hFeboe8HEfXrWR','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(34,23,'App\\Models\\Enrollment','My2p86pTeWrq0ytq5qghphwuSWKLRj3w','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(35,7,'App\\Models\\Enrollment','OXEZBqLnrLCpl2S71NMY3lT9EsAsGxlH','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(36,8,'App\\Models\\Enrollment','Pc8jxtrWFEAQXNfI1l5aMJJIqnxTX7IY','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(37,3,'App\\Models\\Enrollment','QUTDx6ls4PDHnj96d9nmig5XYxF7puJL','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(38,4,'App\\Models\\Enrollment','VvRgrT831R1YtXz7T3lu8QSO2sgPevD1','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(50,2,'App\\Models\\Group','u2706bd84ab654840ad5767f78f420ed','2018-04-12 06:27:47','2018-04-19 04:12:51'),
	(51,1,'App\\Models\\Group','c7cb10ddba81d417d894d119b31d954f','2018-04-12 06:27:47','2018-04-19 04:12:51'),
	(53,1,'App\\Models\\Service','eYI02uEocDt472hsCm69biX4EgUiJxHM','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(54,1,'App\\Models\\University','i5bb990b3969342e5b815d64ac4d3893','2018-04-12 06:27:47','2018-04-19 04:12:51'),
	(55,1,'App\\Models\\Term','JwQlgcfCVRWjDkPiwonbMgGPIaF5WJ1S','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(56,5,'App\\Models\\User','BipyPUZK2b1otMJOkVh21CUlA3GvO9Oh','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(57,3,'App\\Models\\User','d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(58,18,'App\\Models\\User','Eq0uKBoESBjPxuTMDtG6FsAi8CdbPEK1','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(59,9,'App\\Models\\User','eSpvwhe9b3dsBkHZz1Xxgx0TE9cYaF9Q','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(60,8,'App\\Models\\User','EYVoid6eBnSNUcyhN6J67EybnjOQNRhW','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(61,14,'App\\Models\\User','HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(62,2,'App\\Models\\User','JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(63,16,'App\\Models\\User','k3SJ7WctkCFNcFAj7KumfWebx7doIieh','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(64,15,'App\\Models\\User','kKGeYrjclHb0s4iDeDSQISx0nKKx3S84','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(65,4,'App\\Models\\User','mZBS7dLUiNdBEfDVjUh6krB54jlRaCPt','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(66,12,'App\\Models\\User','nzrHeALihLTymfkwJBsslhg0DadMFlxW','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(67,17,'App\\Models\\User','OJSU0SlF4aFknh4Six8kgbxrlTDXLFPe','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(68,6,'App\\Models\\User','q5ja2Qw5IP8RETJq43vGGahB9L91oXjn','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(69,7,'App\\Models\\User','SKXNr8e8eOSTgelgcL4W4HHizteF9zmc','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(70,1,'App\\Models\\User','U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(71,11,'App\\Models\\User','Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(72,13,'App\\Models\\User','XdnqLaL8eoMFFzLazUJT0yl9zoT2dx1E','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(73,10,'App\\Models\\User','zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','2018-04-12 06:27:47','2018-04-12 06:27:47'),
	(87,1,'App\\Models\\UserSession','babb8d085c6f34914afd8e9f11b35f80','2018-08-28 00:02:53','2018-08-28 00:02:53'),
	(88,3,'App\\Models\\Course','lc70cff6d40844d52b9927fa9a406a13','2018-08-28 00:04:20','2018-08-28 00:04:20'),
	(89,11,'App\\Models\\Category','v46402c7b431a4aea80ae220eec5263f','2018-08-28 00:04:20','2018-08-28 00:04:20'),
	(90,12,'App\\Models\\Category','ebaa086f7065d4c3c86781403b3aab5f','2018-08-28 00:04:20','2018-08-28 00:04:20'),
	(91,13,'App\\Models\\Category','m9fb083f87d3941f987253b40638c738','2018-08-28 00:04:20','2018-08-28 00:04:20'),
	(92,14,'App\\Models\\Category','xc97a04a91e4e461c8bdaf1ee57397a9','2018-08-28 00:04:20','2018-08-28 00:04:20'),
	(93,1,'App\\Models\\ActivityLog','g839dfb3a46f6414390d880311dc369b','2018-08-28 00:04:20','2018-08-28 00:04:20'),
	(94,2,'App\\Models\\ActivityLog','yb85e7ef954fc4e27bbff4813f89d99f','2018-08-28 00:04:39','2018-08-28 00:04:39'),
	(95,1,'App\\Models\\Attachment','vfc60395a035d41069bf6f8263557350','2018-08-28 00:05:21','2018-08-28 00:05:21'),
	(96,3,'App\\Models\\ActivityLog','ud79e9fdc315846ffa1ba61d59332c78','2018-08-28 00:05:21','2018-08-28 00:05:21'),
	(97,26,'App\\Models\\Enrollment','v10654dbd44574da4a7fc36cbda7f976','2018-08-28 00:05:35','2018-08-28 00:05:35'),
	(98,4,'App\\Models\\ActivityLog','tef1169d0201a43b5828a6fd1ae337eb','2018-08-28 00:05:35','2018-08-28 00:05:35'),
	(99,27,'App\\Models\\Enrollment','y2dfd06aceeb94d648c36ee201dbad72','2018-08-28 00:06:02','2018-08-28 00:06:02'),
	(100,5,'App\\Models\\ActivityLog','xe1cb0488af5049d4a1a54584a5155fe','2018-08-28 00:06:02','2018-08-28 00:06:02'),
	(101,2,'App\\Models\\UserSession','v1f43a7a2bb7845bbb34ff5f099ac062','2018-08-28 00:06:27','2018-08-28 00:06:27'),
	(102,1,'App\\Models\\Analytic','ye9b1e1b5218940e189e6b296a717832','2018-08-28 00:06:32','2018-08-28 00:06:32'),
	(103,6,'App\\Models\\ActivityLog','b068a4026376c4f6abcb297359a642f0','2018-08-28 00:06:32','2018-08-28 00:06:32'),
	(104,2,'App\\Models\\Analytic','y65717da12fe8412db3a0008f689db1b','2018-08-28 00:06:33','2018-08-28 00:06:33'),
	(105,7,'App\\Models\\ActivityLog','r414babffe4a44d32a5efe03a312851f','2018-08-28 00:06:33','2018-08-28 00:06:33'),
	(106,3,'App\\Models\\Analytic','g7fab02ef0be843068f20193d54e49e8','2018-08-28 00:06:37','2018-08-28 00:06:37'),
	(107,8,'App\\Models\\ActivityLog','ad89ae2d8c1a648de9b62bd04dd8ebce','2018-08-28 00:06:37','2018-08-28 00:06:37'),
	(108,4,'App\\Models\\Analytic','v2ba4867a07044aca828e46445a91ebc','2018-08-28 00:06:40','2018-08-28 00:06:40'),
	(109,9,'App\\Models\\ActivityLog','a5052822c08a94fa28adea64eee287f9','2018-08-28 00:06:40','2018-08-28 00:06:40'),
	(110,5,'App\\Models\\Analytic','j6bc40034726a4ddf848974a3759d6b9','2018-08-28 00:06:42','2018-08-28 00:06:42'),
	(111,10,'App\\Models\\ActivityLog','a0c318b4a86314fe3841d35eb42468c2','2018-08-28 00:06:42','2018-08-28 00:06:42'),
	(112,6,'App\\Models\\Analytic','v243377b596054307b5a1db98eb04b20','2018-08-28 00:06:43','2018-08-28 00:06:43'),
	(113,11,'App\\Models\\ActivityLog','f1c094a4baaf6452cbb2dc31f0078981','2018-08-28 00:06:43','2018-08-28 00:06:43'),
	(114,7,'App\\Models\\Analytic','g7df80727e2524e67b7ca10ffdaacd81','2018-08-28 00:06:44','2018-08-28 00:06:44'),
	(115,12,'App\\Models\\ActivityLog','tc753476d25ab4c5bb78244715f5520b','2018-08-28 00:06:44','2018-08-28 00:06:44'),
	(116,13,'App\\Models\\ActivityLog','b0bccf3435d1746028c006991f267955','2018-08-28 00:06:45','2018-08-28 00:06:45'),
	(117,8,'App\\Models\\Analytic','k3ac392be8c9f4c9dbb304b944320ba6','2018-08-28 00:06:46','2018-08-28 00:06:46'),
	(118,14,'App\\Models\\ActivityLog','xcb32b4dc43f7446dbb139eea5616f70','2018-08-28 00:06:46','2018-08-28 00:06:46'),
	(119,9,'App\\Models\\Analytic','p0da9ac5b6a2d470398462d8adfa9137','2018-08-28 00:06:49','2018-08-28 00:06:49'),
	(120,15,'App\\Models\\ActivityLog','z39ddd092d47d4e719f1c5ffdeda0f51','2018-08-28 00:06:49','2018-08-28 00:06:49'),
	(121,10,'App\\Models\\Analytic','l0701dd44a9a341058f93ae2209ba30e','2018-08-28 00:07:43','2018-08-28 00:07:43'),
	(122,16,'App\\Models\\ActivityLog','r0c284bcf7e7843748dbc63b3d47ff91','2018-08-28 00:07:43','2018-08-28 00:07:43'),
	(123,11,'App\\Models\\Analytic','r3eb7be0d0b944397a10bdb498c5964f','2018-08-28 00:07:47','2018-08-28 00:07:47'),
	(124,17,'App\\Models\\ActivityLog','z739c8a1b43b146cd90530e7d2b85cd7','2018-08-28 00:07:47','2018-08-28 00:07:47'),
	(125,18,'App\\Models\\ActivityLog','pb49af79ac5ab4bdcb1010c1268cf07c','2018-08-28 00:13:25','2018-08-28 00:13:25'),
	(126,12,'App\\Models\\Analytic','t403687ad811d4a169717a1024211d38','2018-08-28 00:13:50','2018-08-28 00:13:50'),
	(127,19,'App\\Models\\ActivityLog','z84eadb93772c40febd46407f02c29cd','2018-08-28 00:13:50','2018-08-28 00:13:50'),
	(128,28,'App\\Models\\Enrollment','k4ee0d0024c6f408fbebb772b4ebf9b5','2018-08-28 00:14:03','2018-08-28 00:14:03'),
	(129,20,'App\\Models\\ActivityLog','y5e8bbef6140a415b9eff2a77fbf4274','2018-08-28 00:14:03','2018-08-28 00:14:03'),
	(130,29,'App\\Models\\Enrollment','b4f4c2a8e695f4ecca11e7aca71b0a4d','2018-08-28 00:14:11','2018-08-28 00:14:11'),
	(131,21,'App\\Models\\ActivityLog','e1ab496cbab084d7488eabc6c44efed2','2018-08-28 00:14:11','2018-08-28 00:14:11'),
	(132,30,'App\\Models\\Enrollment','g6a3da4f992d74e63bf73335a3d7f9b7','2018-08-28 00:14:32','2018-08-28 00:14:32'),
	(133,22,'App\\Models\\ActivityLog','f2368441c4f6543b6b9e46254dc615e3','2018-08-28 00:14:32','2018-08-28 00:14:32'),
	(134,31,'App\\Models\\Enrollment','sba6718e290774e3f98feb07a51bd332','2018-08-28 00:14:38','2018-08-28 00:14:38'),
	(135,23,'App\\Models\\ActivityLog','a38c6e777c11f477dbfec8188fa37f6f','2018-08-28 00:14:38','2018-08-28 00:14:38'),
	(136,13,'App\\Models\\Analytic','q5bf7f68c5bcd4937a19f029d39037b9','2018-08-28 00:14:43','2018-08-28 00:14:43'),
	(137,24,'App\\Models\\ActivityLog','g431063dbb9934b1ab634a138e8f2a6a','2018-08-28 00:14:43','2018-08-28 00:14:43'),
	(138,14,'App\\Models\\Analytic','rf3e9e1b9642d4a3f98d0a2ab4e30002','2018-08-28 00:14:46','2018-08-28 00:14:46'),
	(139,25,'App\\Models\\ActivityLog','ocbd658f2b1c441b1b29a56fc00ede6f','2018-08-28 00:14:46','2018-08-28 00:14:46'),
	(140,2,'App\\Models\\Assignment','zcda01b14200644a79a16126992f807a','2018-08-28 00:15:59','2018-08-28 00:15:59'),
	(141,26,'App\\Models\\ActivityLog','c4c0c17d02bf04637abe3a8df2765698','2018-08-28 00:16:00','2018-08-28 00:16:00'),
	(142,15,'App\\Models\\Analytic','s7b46d3383459454ea6c2732a72dc2af','2018-08-28 00:16:00','2018-08-28 00:16:00'),
	(143,27,'App\\Models\\ActivityLog','d0972755efc3d4247b03b9a9de052a47','2018-08-28 00:16:01','2018-08-28 00:16:01'),
	(144,16,'App\\Models\\Analytic','s0bfad5a6600a4045abd74f4c8834054','2018-08-28 00:16:01','2018-08-28 00:16:01'),
	(145,17,'App\\Models\\Analytic','b092e95d5e21f4e47ab5e803489b0932','2018-08-28 00:16:10','2018-08-28 00:16:10'),
	(146,28,'App\\Models\\ActivityLog','bf117ed5d55ac4c9585127dc694a19cb','2018-08-28 00:16:10','2018-08-28 00:16:10'),
	(147,3,'App\\Models\\Assignment','h1e210e3ce3aa43a5b3fde8547648cce','2018-08-28 00:16:47','2018-08-28 00:16:47'),
	(148,29,'App\\Models\\ActivityLog','f59aa3919bf3a476182dacb50ac874c6','2018-08-28 00:16:47','2018-08-28 00:16:47'),
	(149,18,'App\\Models\\Analytic','sdb31a1106f96455c9b96919a626950a','2018-08-28 00:16:48','2018-08-28 00:16:48'),
	(150,30,'App\\Models\\ActivityLog','t23c7656adcc64d0b885aaf948085d25','2018-08-28 00:16:48','2018-08-28 00:16:48'),
	(151,19,'App\\Models\\Analytic','w24a8c52a869f45c28e2233b49e4314e','2018-08-28 00:16:49','2018-08-28 00:16:49'),
	(152,20,'App\\Models\\Analytic','ja6f2413acddc472f8646fee9366682d','2018-08-28 00:16:54','2018-08-28 00:16:54'),
	(153,31,'App\\Models\\ActivityLog','g02de07eb6cf444faac9ad549226b177','2018-08-28 00:16:54','2018-08-28 00:16:54'),
	(154,4,'App\\Models\\Assignment','d74943de54eef49108523c16ac493e86','2018-08-28 00:18:19','2018-08-28 00:18:19'),
	(155,1,'App\\Models\\AssignmentGroup','u7129256ba9ac406bab45cb471a1ec48','2018-08-28 00:18:19','2018-08-28 00:18:19'),
	(156,2,'App\\Models\\AssignmentGroup','xe4f2cc7ff1024db0b94ba891fa0319d','2018-08-28 00:18:19','2018-08-28 00:18:19'),
	(157,32,'App\\Models\\ActivityLog','wf5e94430464641cca9e5739cdcad8a4','2018-08-28 00:18:19','2018-08-28 00:18:19'),
	(158,21,'App\\Models\\Analytic','h049433a491d8474c922bffbf2d767a4','2018-08-28 00:18:20','2018-08-28 00:18:20'),
	(159,33,'App\\Models\\ActivityLog','h963c95f4fbf5449daa9c855e706e1cb','2018-08-28 00:18:20','2018-08-28 00:18:20'),
	(160,22,'App\\Models\\Analytic','p9942d3a1081c42799dd54fa6255ab7b','2018-08-28 00:18:22','2018-08-28 00:18:22'),
	(161,23,'App\\Models\\Analytic','baca96d607d78466d84c071a4aed14a1','2018-08-28 00:18:27','2018-08-28 00:18:27'),
	(162,34,'App\\Models\\ActivityLog','a15f9a57fb2174a0ba053f6f8481b9ce','2018-08-28 00:18:27','2018-08-28 00:18:27'),
	(163,5,'App\\Models\\Assignment','ud7c1186e1a44432a963cdacd4368e4d','2018-08-28 00:19:01','2018-08-28 00:19:01'),
	(164,35,'App\\Models\\ActivityLog','af207f7a3e6194978bedd85a2e58ee5c','2018-08-28 00:19:01','2018-08-28 00:19:01'),
	(165,24,'App\\Models\\Analytic','cd6d516f11de4463dab6f26baa8e983e','2018-08-28 00:19:02','2018-08-28 00:19:02'),
	(166,36,'App\\Models\\ActivityLog','kf7145ff2482747769dea01ab35d9baa','2018-08-28 00:19:02','2018-08-28 00:19:02'),
	(167,25,'App\\Models\\Analytic','d693a7a39421e41e08ea33f6221ca618','2018-08-28 00:19:03','2018-08-28 00:19:03'),
	(168,26,'App\\Models\\Analytic','e4111bcadd2b94e5e931f7c7269ca8ae','2018-08-28 00:19:13','2018-08-28 00:19:13'),
	(169,37,'App\\Models\\ActivityLog','z624ec193059c4c4e85e529fd064ab0e','2018-08-28 00:19:13','2018-08-28 00:19:13'),
	(170,6,'App\\Models\\Assignment','c40d8a7ce79894a879ee92d410052626','2018-08-28 00:19:56','2018-08-28 00:19:56'),
	(171,38,'App\\Models\\ActivityLog','r1d4812cd52de4c1bb9ab9491dfb7a5f','2018-08-28 00:19:56','2018-08-28 00:19:56'),
	(172,27,'App\\Models\\Analytic','j0601c2fa0c304f378d65eb019e4c692','2018-08-28 00:19:56','2018-08-28 00:19:56'),
	(173,39,'App\\Models\\ActivityLog','zf2e0bfa8f1e34029b3cd76a535521b9','2018-08-28 00:19:56','2018-08-28 00:19:56'),
	(174,28,'App\\Models\\Analytic','tb00ee7a3f8f34358ac8182959437f06','2018-08-28 00:19:57','2018-08-28 00:19:57'),
	(175,29,'App\\Models\\Analytic','w3e79986aa029421b867f63b2ce7fca1','2018-08-28 00:19:59','2018-08-28 00:19:59'),
	(176,40,'App\\Models\\ActivityLog','aad2e2347d7044663a9a517ff4289961','2018-08-28 00:19:59','2018-08-28 00:19:59'),
	(177,7,'App\\Models\\Assignment','lf1f97d5feb6746769401727a7d7988e','2018-08-28 00:20:30','2018-08-28 00:20:30'),
	(178,41,'App\\Models\\ActivityLog','xe1cc0c0926ac49f8926b8d0b98bd9ec','2018-08-28 00:20:30','2018-08-28 00:20:30'),
	(179,30,'App\\Models\\Analytic','b4e003bf99ca74b1db22c46e48495e04','2018-08-28 00:20:31','2018-08-28 00:20:31'),
	(180,42,'App\\Models\\ActivityLog','ab887b210f3724424b0d08d57a48b793','2018-08-28 00:20:31','2018-08-28 00:20:31'),
	(181,31,'App\\Models\\Analytic','ob8835ac01cac4ed3ab354d2af8a06a0','2018-08-28 00:20:32','2018-08-28 00:20:32'),
	(182,32,'App\\Models\\Analytic','b70c99e6f30ce43ceb6e03c15e0a4cbf','2018-08-28 00:20:38','2018-08-28 00:20:38'),
	(183,43,'App\\Models\\ActivityLog','maa85675579c14924ae68e22bbe3ff9b','2018-08-28 00:20:38','2018-08-28 00:20:38'),
	(184,33,'App\\Models\\Analytic','m5d5b4981940e4941994be2905225be9','2018-08-28 00:20:41','2018-08-28 00:20:41'),
	(185,44,'App\\Models\\ActivityLog','i9a3b3274cbfa401eb5c0129c94aaa0d','2018-08-28 00:20:41','2018-08-28 00:20:41'),
	(186,34,'App\\Models\\Analytic','rb2f190c77733413b83dae301476a267','2018-08-28 00:20:44','2018-08-28 00:20:44'),
	(187,45,'App\\Models\\ActivityLog','fcc291eec31fe44ed9151ebcc2065fba','2018-08-28 00:20:44','2018-08-28 00:20:44'),
	(188,35,'App\\Models\\Analytic','f124573e631ec4af9b42db18b99d6aac','2018-08-28 00:20:51','2018-08-28 00:20:51'),
	(189,46,'App\\Models\\ActivityLog','d617d6feabcfe4a86bbe8a9cb3894742','2018-08-28 00:20:51','2018-08-28 00:20:51'),
	(190,1,'App\\Models\\Post','a94879b1c3b8e482babd7d8141d0d269','2018-08-28 00:21:09','2018-08-28 00:21:09'),
	(191,47,'App\\Models\\ActivityLog','m6d1c172ce76e40f0b01f87e1cad55df','2018-08-28 00:21:09','2018-08-28 00:21:09'),
	(192,48,'App\\Models\\ActivityLog','x2f4da9d8e05d4676a0f0957e4eeceda','2018-08-28 00:21:14','2018-08-28 00:21:14'),
	(193,3,'App\\Models\\UserSession','vb047bce55f0e4b92b9390e1b3ccfbaa','2018-08-28 00:22:41','2018-08-28 00:22:41'),
	(194,2,'App\\Models\\Post','jf4547db62c1e4a309a85db18fbaf4a8','2018-08-28 00:22:53','2018-08-28 00:22:53'),
	(195,49,'App\\Models\\ActivityLog','v010f257daf5a4a219dcfda88b131c34','2018-08-28 00:22:53','2018-08-28 00:22:53'),
	(196,1,'App\\Models\\Like','we313ecb37dba45f599960437c86c59a','2018-08-28 00:22:56','2018-08-28 00:22:56'),
	(197,1,'App\\Models\\Comment','jf1833e8545654e0abdbd81b7a422d4b','2018-08-28 00:23:09','2018-08-28 00:23:09'),
	(198,50,'App\\Models\\ActivityLog','oe0ed6f8251d34def828f33553ab7722','2018-08-28 00:23:09','2018-08-28 00:23:09'),
	(199,4,'App\\Models\\UserSession','x72c2da85036045a68913acfe35b2164','2018-08-28 00:23:28','2018-08-28 00:23:28'),
	(200,2,'App\\Models\\Like','w8f15d0da416e44018a06451e4f2d64a','2018-08-28 00:23:44','2018-08-28 00:23:44'),
	(201,2,'App\\Models\\Comment','ff9c7c33fcb5d4d49b66cc8d2f9cdff6','2018-08-28 00:23:51','2018-08-28 00:23:51'),
	(202,51,'App\\Models\\ActivityLog','u1ee185dc3ae24558a001b4c79d932a7','2018-08-28 00:23:51','2018-08-28 00:23:51'),
	(203,5,'App\\Models\\UserSession','pc8535dd8fc1047539163361186a7154','2018-08-28 00:24:14','2018-08-28 00:24:14'),
	(204,3,'App\\Models\\Comment','aece9a9845f6b47d481c171b95cba06e','2018-08-28 00:24:25','2018-08-28 00:24:25'),
	(205,52,'App\\Models\\ActivityLog','wcfd20fdfd2b4413a9b9cfde3016175a','2018-08-28 00:24:26','2018-08-28 00:24:26'),
	(206,3,'App\\Models\\Like','v4248ce55a97f46918d4e9a338b7d336','2018-08-28 00:24:28','2018-08-28 00:24:28'),
	(207,4,'App\\Models\\Like','fb3acf4cd02b44e23b0f931dd2547e72','2018-08-28 00:24:30','2018-08-28 00:24:30'),
	(208,5,'App\\Models\\Like','m6811f0cfd7294d6bbe57d7eb74eac50','2018-08-28 00:24:32','2018-08-28 00:24:32'),
	(209,3,'App\\Models\\Post','oba9021da33144e3aa35ea346c95a083','2018-08-28 00:24:44','2018-08-28 00:24:44'),
	(210,53,'App\\Models\\ActivityLog','eb69d2d1c12164023b3f4058970ea2d2','2018-08-28 00:24:44','2018-08-28 00:24:44'),
	(211,6,'App\\Models\\UserSession','ua83b5533bf274b8d937e09f1582426e','2018-08-28 00:25:09','2018-08-28 00:25:09'),
	(212,4,'App\\Models\\Post','re1ac9f174d0c4febb2d48e4075ce4cf','2018-08-28 00:25:20','2018-08-28 00:25:20'),
	(213,54,'App\\Models\\ActivityLog','b5cd8fa7d37574172a55be6ade071e63','2018-08-28 00:25:20','2018-08-28 00:25:20'),
	(214,6,'App\\Models\\Like','s16f0d5641c1749e38f2530f246d9589','2018-08-28 00:25:24','2018-08-28 00:25:24'),
	(215,7,'App\\Models\\Like','d12c3122259d746978548c90418301df','2018-08-28 00:25:27','2018-08-28 00:25:27'),
	(216,4,'App\\Models\\Comment','sf822f7043fd3412cb1c32b818ac8258','2018-08-28 00:25:36','2018-08-28 00:25:36'),
	(217,55,'App\\Models\\ActivityLog','na2ff7994a08c4b6b906a098b927e8d4','2018-08-28 00:25:36','2018-08-28 00:25:36'),
	(218,7,'App\\Models\\UserSession','ba05df9cbf7db4aba8aeebc749ca4d33','2018-08-28 00:25:53','2018-08-28 00:25:53'),
	(219,5,'App\\Models\\Comment','k65fbc2e78d884ff8bed9cd133115b8c','2018-08-28 00:26:13','2018-08-28 00:26:13'),
	(220,56,'App\\Models\\ActivityLog','g086133502f0a45a1a8766441b85efea','2018-08-28 00:26:13','2018-08-28 00:26:13'),
	(221,8,'App\\Models\\Like','ve75e4fd429ff4f0e89b77edbca60f74','2018-08-28 00:26:19','2018-08-28 00:26:19'),
	(222,9,'App\\Models\\Like','u305eee9ec87e47c596b5da8bff38131','2018-08-28 00:26:20','2018-08-28 00:26:20'),
	(223,6,'App\\Models\\Comment','t937f86900159428eb470f6b13be8d09','2018-08-28 00:26:30','2018-08-28 00:26:30'),
	(224,57,'App\\Models\\ActivityLog','icaa200f3694d46fa800d25e1e515db4','2018-08-28 00:26:30','2018-08-28 00:26:30'),
	(225,8,'App\\Models\\UserSession','mf9eefb38024a430983aaf0413e79c88','2018-08-28 00:27:17','2018-08-28 00:27:17'),
	(226,7,'App\\Models\\Comment','zb0f9f713f87c4daf995245fbe004f92','2018-08-28 00:27:36','2018-08-28 00:27:36'),
	(227,58,'App\\Models\\ActivityLog','pf67389fb63344ec696d48cf7e6418dd','2018-08-28 00:27:36','2018-08-28 00:27:36'),
	(228,5,'App\\Models\\Post','c0c0908f08fb24edaa443172b7d8ff10','2018-08-28 00:27:58','2018-08-28 00:27:58'),
	(229,59,'App\\Models\\ActivityLog','d652116083a3647c78fbd5882fa54e7b','2018-08-28 00:27:58','2018-08-28 00:27:58'),
	(230,60,'App\\Models\\ActivityLog','b30f3d69f6d1540068c3a7cbdab275c7','2018-08-28 00:28:25','2018-08-28 00:28:25'),
	(231,9,'App\\Models\\UserSession','e6f9601ebeee44b3a862d3995af927ab','2018-08-28 00:28:46','2018-08-28 00:28:46'),
	(232,8,'App\\Models\\Comment','hc16cc4a29bdf4ed79838367aa4b5aec','2018-08-28 00:29:04','2018-08-28 00:29:04'),
	(233,61,'App\\Models\\ActivityLog','n0197aa68c9a448cea4f175a00169301','2018-08-28 00:29:04','2018-08-28 00:29:04'),
	(234,62,'App\\Models\\ActivityLog','pb0049a5b18ec4eebb6e7fbd80ee205e','2018-08-28 00:29:11','2018-08-28 00:29:11'),
	(235,10,'App\\Models\\Like','e89718922b5da4afb894199de6f90968','2018-08-28 00:29:16','2018-08-28 00:29:16'),
	(236,11,'App\\Models\\Like','lb3091d6f103d46e4bdd565a6f530e7a','2018-08-28 00:29:17','2018-08-28 00:29:17'),
	(237,12,'App\\Models\\Like','p760b01cadbab4b61a9355b58b0299e4','2018-08-28 00:29:30','2018-08-28 00:29:30'),
	(238,10,'App\\Models\\UserSession','a50d9c9063a864431b401d5f6d5338e6','2018-08-28 00:29:58','2018-08-28 00:29:58'),
	(239,4,'App\\Models\\Course','le4acf50aaacc4d86a8ad041040cfa3d','2018-08-28 00:31:37','2018-08-28 00:31:37'),
	(240,15,'App\\Models\\Category','h9dd69f4d0f374a988c721ce9b7b4427','2018-08-28 00:31:37','2018-08-28 00:31:37'),
	(241,16,'App\\Models\\Category','t0b78731421654b3fa51ad176e3595e4','2018-08-28 00:31:37','2018-08-28 00:31:37'),
	(242,17,'App\\Models\\Category','p9c0b53a782d14343a0f8b807b750310','2018-08-28 00:31:37','2018-08-28 00:31:37'),
	(243,18,'App\\Models\\Category','ba577b1d62d4c4c0aac86e3bea5572e6','2018-08-28 00:31:37','2018-08-28 00:31:37'),
	(244,63,'App\\Models\\ActivityLog','u4c0406fbed5a42f0a40b18f27f1d26e','2018-08-28 00:31:37','2018-08-28 00:31:37'),
	(245,32,'App\\Models\\Enrollment','j521e4337397c4b2484eabf265e314cd','2018-08-28 00:31:52','2018-08-28 00:31:52'),
	(246,64,'App\\Models\\ActivityLog','n50b1b3be96aa492fb03e3528e587fb9','2018-08-28 00:31:52','2018-08-28 00:31:52'),
	(247,5,'App\\Models\\Course','s5802ee9570f642b28342df283d297af','2018-08-28 00:32:18','2018-08-28 00:32:18'),
	(248,19,'App\\Models\\Category','k6070cceae4dd487c8ccbf97ac266c4a','2018-08-28 00:32:18','2018-08-28 00:32:18'),
	(249,20,'App\\Models\\Category','x1e7bb8906106448f8c310cd19a05aa4','2018-08-28 00:32:18','2018-08-28 00:32:18'),
	(250,21,'App\\Models\\Category','s0b455be6df484204ba56cfc9ad68cca','2018-08-28 00:32:18','2018-08-28 00:32:18'),
	(251,22,'App\\Models\\Category','idc8a7cbf118a41d8af1ca4af4fda1cb','2018-08-28 00:32:18','2018-08-28 00:32:18'),
	(252,65,'App\\Models\\ActivityLog','ib0a042815e9e46aa97cb6d4681117a4','2018-08-28 00:32:18','2018-08-28 00:32:18'),
	(253,66,'App\\Models\\ActivityLog','g261b4091935e455d9ec59f027c16573','2018-08-28 00:32:29','2018-08-28 00:32:29'),
	(254,33,'App\\Models\\Enrollment','obd58aaaf121440c8afa9b47d25522af','2018-08-28 00:32:38','2018-08-28 00:32:38'),
	(255,67,'App\\Models\\ActivityLog','m4e21ea3537f6494191a671cdd56abb6','2018-08-28 00:32:38','2018-08-28 00:32:38'),
	(256,6,'App\\Models\\Course','d4f7a84149dff4e92a9180d8d97bdd1c','2018-08-28 00:33:06','2018-08-28 00:33:06'),
	(257,23,'App\\Models\\Category','f1e675f1084df446f8f7a1344c6fbf30','2018-08-28 00:33:06','2018-08-28 00:33:06'),
	(258,24,'App\\Models\\Category','e50df2b1949cf40af859f69b12352c47','2018-08-28 00:33:06','2018-08-28 00:33:06'),
	(259,25,'App\\Models\\Category','w20b91ea07ab04205b22718aae7aab2c','2018-08-28 00:33:06','2018-08-28 00:33:06'),
	(260,26,'App\\Models\\Category','x6b36728ae84d480b88f5b23de0684e2','2018-08-28 00:33:06','2018-08-28 00:33:06'),
	(261,68,'App\\Models\\ActivityLog','r3aea361a9577426ca5e7065913b5639','2018-08-28 00:33:06','2018-08-28 00:33:06'),
	(262,34,'App\\Models\\Enrollment','yb1f56e05de0b4d0fa9947708cafb791','2018-08-28 00:33:19','2018-08-28 00:33:19'),
	(263,69,'App\\Models\\ActivityLog','dc8c5c80a1b344ad0b5b9ead920e85b2','2018-08-28 00:33:19','2018-08-28 00:33:19'),
	(264,35,'App\\Models\\Enrollment','h8c1d469106224e308f0704c03ab98ac','2018-08-28 00:34:25','2018-08-28 00:34:25'),
	(265,70,'App\\Models\\ActivityLog','s1f3bb24892794a95a6fe38d94fb6846','2018-08-28 00:34:25','2018-08-28 00:34:25'),
	(266,11,'App\\Models\\UserSession','nea3fbfd64de1450c9bf286930435039','2018-08-28 00:34:32','2018-08-28 00:34:32'),
	(267,12,'App\\Models\\UserSession','q13b69087e5de420b8a017afe79dbb84','2018-08-28 00:34:55','2018-08-28 00:34:55'),
	(268,71,'App\\Models\\ActivityLog','cb3a43dd1566f4f6fa4399da9a62d5f7','2018-08-28 00:35:09','2018-08-28 00:35:09'),
	(269,36,'App\\Models\\Analytic','j094edaead00f452680c11ec746813f1','2018-08-28 00:35:12','2018-08-28 00:35:12'),
	(270,72,'App\\Models\\ActivityLog','xdfe01be095e644738960cba7ab1ad7c','2018-08-28 00:35:12','2018-08-28 00:35:12'),
	(271,37,'App\\Models\\Analytic','xad49cab4cb6d4e6b9d03ace03461e56','2018-08-28 00:35:13','2018-08-28 00:35:13'),
	(272,73,'App\\Models\\ActivityLog','baaaa3a012c124506a41ef69601bc9e2','2018-08-28 00:35:13','2018-08-28 00:35:13'),
	(273,38,'App\\Models\\Analytic','nff36a883f9904906bfabb9c93b4040d','2018-08-28 00:35:14','2018-08-28 00:35:14'),
	(274,74,'App\\Models\\ActivityLog','nd6c1c29258394028b662472c4c34eeb','2018-08-28 00:35:14','2018-08-28 00:35:14'),
	(275,39,'App\\Models\\Analytic','d3ef8cc2cfb67418db58d4c84fc61200','2018-08-28 00:35:16','2018-08-28 00:35:16'),
	(276,75,'App\\Models\\ActivityLog','jb0253f65d64e41809a5da191cca8f01','2018-08-28 00:35:16','2018-08-28 00:35:16'),
	(277,40,'App\\Models\\Analytic','c92f106be4e754026a72fba85c1ad4cd','2018-08-28 00:35:17','2018-08-28 00:35:17'),
	(278,76,'App\\Models\\ActivityLog','kf57ddc71fcba475a85620d34ab90dd7','2018-08-28 00:35:17','2018-08-28 00:35:17'),
	(279,41,'App\\Models\\Analytic','j6fdc806a0d6a4f179c07609e39f6396','2018-08-28 00:35:18','2018-08-28 00:35:18'),
	(280,77,'App\\Models\\ActivityLog','zd247cc4f58a74155a70b18de31b5cda','2018-08-28 00:35:18','2018-08-28 00:35:18'),
	(281,42,'App\\Models\\Analytic','je7f336d2f96944b19892a0646e0c7ac','2018-08-28 00:35:19','2018-08-28 00:35:19'),
	(282,78,'App\\Models\\ActivityLog','oec807026fb894c6fa812ef201d750d9','2018-08-28 00:35:19','2018-08-28 00:35:19'),
	(283,79,'App\\Models\\ActivityLog','k925d9279c08a4e0d86588cceb05f50f','2018-08-28 00:35:20','2018-08-28 00:35:20'),
	(284,43,'App\\Models\\Analytic','jd9acf6ab2bfd4646a768ca03f889a94','2018-08-28 00:35:20','2018-08-28 00:35:20'),
	(285,80,'App\\Models\\ActivityLog','c6ed6929f09c543b0bdf0386d899cafc','2018-08-28 00:35:20','2018-08-28 00:35:20'),
	(286,44,'App\\Models\\Analytic','o143ed9b40257483dbbd5608424612d7','2018-08-28 00:35:22','2018-08-28 00:35:22'),
	(287,81,'App\\Models\\ActivityLog','qfb2681d8fa7747f78bc231788c776d8','2018-08-28 00:35:22','2018-08-28 00:35:22'),
	(288,45,'App\\Models\\Analytic','z9bdf6b898a244ad9a66638ab9156231','2018-08-28 00:35:23','2018-08-28 00:35:23'),
	(289,82,'App\\Models\\ActivityLog','c4640bea0c5df4cd7a9d1d1e19cdff1e','2018-08-28 00:35:23','2018-08-28 00:35:23'),
	(290,46,'App\\Models\\Analytic','zfb4fee01454f4e5c874529cddb012d3','2018-08-28 00:35:24','2018-08-28 00:35:24'),
	(291,83,'App\\Models\\ActivityLog','l7e5f98927ec64f708f4b2255856093f','2018-08-28 00:35:24','2018-08-28 00:35:24'),
	(292,47,'App\\Models\\Analytic','pd89339924b3d4127a26c47333228c3d','2018-08-28 00:35:25','2018-08-28 00:35:25'),
	(293,84,'App\\Models\\ActivityLog','g817738b0feae4842b83686ef77aa3cf','2018-08-28 00:35:25','2018-08-28 00:35:25'),
	(294,48,'App\\Models\\Analytic','j34ef05ee860a4dbb9d0c0c9cd488a74','2018-08-28 00:35:26','2018-08-28 00:35:26'),
	(295,85,'App\\Models\\ActivityLog','ea6c48cfbce9d48289c6b72f8b487f0f','2018-08-28 00:35:26','2018-08-28 00:35:26'),
	(296,49,'App\\Models\\Analytic','h755d0f657a9b4b148f2862020b0f713','2018-08-28 00:35:27','2018-08-28 00:35:27'),
	(297,50,'App\\Models\\Analytic','sfb08dca4b2864df8aceb7d6f0e1126d','2018-08-28 00:35:28','2018-08-28 00:35:28'),
	(298,86,'App\\Models\\ActivityLog','nf7e0c00fae2849698d97e624966dbe5','2018-08-28 00:35:28','2018-08-28 00:35:28'),
	(299,87,'App\\Models\\ActivityLog','l17140f19953245f78d54174caf8e1fc','2018-08-28 00:35:29','2018-08-28 00:35:29'),
	(300,51,'App\\Models\\Analytic','i0232537fe9074c52806d7108e1c2e4d','2018-08-28 00:35:29','2018-08-28 00:35:29'),
	(301,88,'App\\Models\\ActivityLog','ycc694abf11544b26b1decc0ad432f24','2018-08-28 00:35:29','2018-08-28 00:35:29'),
	(302,52,'App\\Models\\Analytic','r0922d88d8f0c4695a817f717a950f41','2018-08-28 00:35:30','2018-08-28 00:35:30'),
	(303,89,'App\\Models\\ActivityLog','s383062f75f9c403abc452c34111165c','2018-08-28 00:35:30','2018-08-28 00:35:30'),
	(304,53,'App\\Models\\Analytic','jdaa64eefe88f42fdbcb753cf51bd367','2018-08-28 00:35:32','2018-08-28 00:35:32'),
	(305,90,'App\\Models\\ActivityLog','h2023fc5b72664ca686f9b6fe8865a99','2018-08-28 00:35:32','2018-08-28 00:35:32'),
	(306,54,'App\\Models\\Analytic','jc8e0ee815ebf463487de2d3182df009','2018-08-28 00:35:33','2018-08-28 00:35:33'),
	(307,91,'App\\Models\\ActivityLog','f0cff185fc4f84c0cae428dd4ef0bab9','2018-08-28 00:35:33','2018-08-28 00:35:33'),
	(308,55,'App\\Models\\Analytic','jb3b5ca7fd39e402caa02cf45c5fa1cd','2018-08-28 00:35:34','2018-08-28 00:35:34'),
	(309,92,'App\\Models\\ActivityLog','decc9651cb1ff404b95ba33b072669f5','2018-08-28 00:35:34','2018-08-28 00:35:34'),
	(310,56,'App\\Models\\Analytic','p403874b221164863be0da08a49a6f90','2018-08-28 00:35:35','2018-08-28 00:35:35'),
	(311,93,'App\\Models\\ActivityLog','ud3f58cba734143b1a7152bf6afa60f9','2018-08-28 00:35:35','2018-08-28 00:35:35'),
	(312,57,'App\\Models\\Analytic','zdc9645e2bc354ccbb37bc8df3dfc3f1','2018-08-28 00:35:36','2018-08-28 00:35:36'),
	(313,94,'App\\Models\\ActivityLog','a832de6921ac54877b4bf2f9a1796457','2018-08-28 00:35:36','2018-08-28 00:35:36'),
	(314,58,'App\\Models\\Analytic','b1e98dbc8414844388a05581a1a99cd6','2018-08-28 00:35:37','2018-08-28 00:35:37'),
	(315,95,'App\\Models\\ActivityLog','i9e61d4697ad04ba6bccd25083cd136c','2018-08-28 00:35:37','2018-08-28 00:35:37'),
	(316,96,'App\\Models\\ActivityLog','f2f624cadbcb940c2b65edcfd8dda4f4','2018-08-28 00:35:38','2018-08-28 00:35:38'),
	(317,59,'App\\Models\\Analytic','bd34b979494cc49d280acc0164c6a598','2018-08-28 00:35:39','2018-08-28 00:35:39'),
	(318,97,'App\\Models\\ActivityLog','u589e8b287f5b4400bb84f52963f4949','2018-08-28 00:35:39','2018-08-28 00:35:39'),
	(319,60,'App\\Models\\Analytic','aa6f6e930f0c4487ca3ba99bb8319017','2018-08-28 00:35:42','2018-08-28 00:35:42'),
	(320,98,'App\\Models\\ActivityLog','pd92e520b1e48425aba3d17f398f152c','2018-08-28 00:35:42','2018-08-28 00:35:42'),
	(321,61,'App\\Models\\Analytic','vdf5733800cda4023aef2381a5fcb916','2018-08-28 00:35:45','2018-08-28 00:35:45'),
	(322,99,'App\\Models\\ActivityLog','s8287f6b38eba47c49bfaae061131e3b','2018-08-28 00:35:45','2018-08-28 00:35:45'),
	(323,62,'App\\Models\\Analytic','hd30626d647d846c1afe6bc328320b00','2018-08-28 00:35:46','2018-08-28 00:35:46'),
	(324,100,'App\\Models\\ActivityLog','o3b60c354d1984153b4476c287e35626','2018-08-28 00:35:46','2018-08-28 00:35:46'),
	(325,6,'App\\Models\\Post','tcc103f3018c9471caae122e1b4630c0','2018-08-28 00:35:54','2018-08-28 00:35:54'),
	(326,101,'App\\Models\\ActivityLog','gca369096257d40b1a59911dfa5b26d9','2018-08-28 00:35:54','2018-08-28 00:35:54'),
	(327,13,'App\\Models\\Like','df07e6e27dceb4b04b2071840ab5d00d','2018-08-28 00:36:31','2018-08-28 00:36:31'),
	(328,13,'App\\Models\\UserSession','o8bca508cac244d0fbfb60d41041eb15','2018-08-28 00:36:42','2018-08-28 00:36:42'),
	(329,14,'App\\Models\\Like','o620f30c116314db088f1fb59e8a5f87','2018-08-28 00:36:50','2018-08-28 00:36:50'),
	(330,15,'App\\Models\\Like','a54c46e4cef0b4183ac9a2fc6bece1ac','2018-08-28 00:36:53','2018-08-28 00:36:53'),
	(331,16,'App\\Models\\Like','l8d32c7e41a3d450b89caeb30f9746e0','2018-08-28 00:37:02','2018-08-28 00:37:02'),
	(332,17,'App\\Models\\Like','o5478dbd4913645fd894f8077beb5821','2018-08-28 00:37:06','2018-08-28 00:37:06'),
	(333,14,'App\\Models\\UserSession','t0a0dcef7776a4e9e956de3e4df0200f','2018-08-28 00:37:51','2018-08-28 00:37:51'),
	(334,15,'App\\Models\\UserSession','b39697d0f28f54ad890fc3e54435439e','2018-08-28 00:39:43','2018-08-28 00:39:43'),
	(335,18,'App\\Models\\Like','g8a90658e9e004ef2844fd02c01e6a57','2018-08-28 00:39:54','2018-08-28 00:39:54'),
	(336,19,'App\\Models\\Like','r8930f48279a541b1a09b3da22a6dbf3','2018-08-28 00:39:56','2018-08-28 00:39:56'),
	(337,20,'App\\Models\\Like','z4f38a1260ec441da86d3fa5c4ab219f','2018-08-28 00:39:58','2018-08-28 00:39:58'),
	(338,16,'App\\Models\\UserSession','c3959b97f7f4947f6ad3531ab3ee815d','2018-08-28 00:40:18','2018-08-28 00:40:18'),
	(339,17,'App\\Models\\UserSession','sf21666e1202141b9aa79a47a19e2442','2018-08-28 00:42:06','2018-08-28 00:42:06'),
	(340,18,'App\\Models\\UserSession','q5e9bfa516c2641918105df8a1781176','2018-08-28 00:42:07','2018-08-28 00:42:07');

/*!40000 ALTER TABLE `resource_keys` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table role_permission
# ------------------------------------------------------------

DROP TABLE IF EXISTS `role_permission`;

CREATE TABLE `role_permission` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(10) unsigned NOT NULL,
  `permission_id` int(10) unsigned NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_permission_role_id_permission_id_unique` (`role_id`,`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table roles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `roles`;

CREATE TABLE `roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(190) NOT NULL,
  `parent_id` int(10) unsigned NOT NULL,
  `parent_type` varchar(190) NOT NULL,
  `locked` tinyint(1) NOT NULL DEFAULT '0',
  `resource_key` varchar(32) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_resource_key_unique` (`resource_key`),
  KEY `roles_parent_id_parent_type_index` (`parent_id`,`parent_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table service_checks
# ------------------------------------------------------------

DROP TABLE IF EXISTS `service_checks`;

CREATE TABLE `service_checks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `service_id` int(10) unsigned NOT NULL,
  `email` varchar(190) NOT NULL,
  `type` varchar(190) NOT NULL,
  `status` varchar(190) NOT NULL,
  `result` mediumtext,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `service_checks` WRITE;
/*!40000 ALTER TABLE `service_checks` DISABLE KEYS */;

INSERT INTO `service_checks` (`id`, `service_id`, `email`, `type`, `status`, `result`, `created_at`, `updated_at`, `deleted_at`)
VALUES
	(1,4,'notebowl-notifications-group@denison.edu','dns','ok','140.141.2.193','2017-04-24 06:04:48','2017-04-24 06:04:48',NULL),
	(2,4,'notebowl-notifications-group@denison.edu','url','ok',NULL,'2017-04-24 06:04:48','2017-04-24 06:04:48',NULL);

/*!40000 ALTER TABLE `service_checks` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table service_items
# ------------------------------------------------------------

DROP TABLE IF EXISTS `service_items`;

CREATE TABLE `service_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `syncable_id` int(10) unsigned NOT NULL,
  `syncable_type` varchar(190) NOT NULL,
  `service_id` int(10) unsigned NOT NULL,
  `remote_id` varchar(190) NOT NULL DEFAULT '',
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `scopeable_id` int(10) unsigned DEFAULT NULL,
  `scopeable_type` varchar(190) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `syncable_university_remote_origin_unique` (`syncable_type`,`syncable_id`,`service_id`,`remote_id`),
  KEY `scopeable` (`scopeable_id`,`scopeable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table services
# ------------------------------------------------------------

DROP TABLE IF EXISTS `services`;

CREATE TABLE `services` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(190) NOT NULL,
  `desc` varchar(190) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `username` varchar(190) DEFAULT NULL,
  `password` varchar(190) DEFAULT NULL,
  `token1` varchar(190) DEFAULT NULL,
  `token2` varchar(190) DEFAULT NULL,
  `token3` varchar(255) DEFAULT NULL,
  `token4` varchar(255) DEFAULT NULL,
  `token5` varchar(255) DEFAULT NULL,
  `token6` varchar(255) DEFAULT NULL,
  `token7` varchar(255) DEFAULT NULL,
  `token8` varchar(255) DEFAULT NULL,
  `type` varchar(190) NOT NULL,
  `class` varchar(190) NOT NULL,
  `university_id` int(10) unsigned NOT NULL,
  `resource_key` varchar(32) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `email` varchar(190) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `university_services_resource_key_unique` (`resource_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;

INSERT INTO `services` (`id`, `name`, `desc`, `url`, `username`, `password`, `token1`, `token2`, `token3`, `token4`, `token5`, `token6`, `token7`, `token8`, `type`, `class`, `university_id`, `resource_key`, `created_at`, `updated_at`, `deleted_at`, `email`)
VALUES
	(1,'canvas',NULL,NULL,'admin@notebowl.com',NULL,'2fV3z57oFFHWxhAueR5ZzimksqcJxM','Ji18pocVkp','Administrator','0','14','1','500','5','lti','canvas',1,'eYI02uEocDt472hsCm69biX4EgUiJxHM','2020-11-16 18:57:41.942500','2020-11-16 18:57:42.389600',NULL,NULL);

/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table settings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `settings`;

CREATE TABLE `settings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(190) NOT NULL,
  `value` mediumtext NOT NULL,
  `resource_key` varchar(32) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `creator_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `settings_resource_key_unique` (`resource_key`),
  UNIQUE KEY `unique_rule` (`key`,`creator_id`,`deleted_at`),
  KEY `settings_owner_id_owner_type_deleted_at_index` (`deleted_at`),
  KEY `settings_parent_id_parent_type_index` (`creator_id`),
  KEY `searchable` (`creator_id`),
  KEY `settings_parent_id_index` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table signups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `signups`;

CREATE TABLE `signups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `org_name` varchar(190) NOT NULL,
  `org_scheme` varchar(190) NOT NULL,
  `first_name` varchar(190) NOT NULL,
  `last_name` varchar(190) NOT NULL,
  `email` varchar(190) NOT NULL,
  `role` varchar(190) NOT NULL,
  `course_name` varchar(190) NOT NULL,
  `course_number` varchar(190) DEFAULT NULL,
  `resource_key` varchar(32) NOT NULL,
  `domain` varchar(190) DEFAULT NULL,
  `approved` tinyint(1) DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `signups_resource_key_unique` (`resource_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table sockets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sockets`;

CREATE TABLE `sockets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `channel` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sockets_user_id_index` (`user_id`),
  KEY `sockets_created_at_index` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `sockets` WRITE;
/*!40000 ALTER TABLE `sockets` DISABLE KEYS */;

INSERT INTO `sockets` (`id`, `user_id`, `channel`, `payload`, `created_at`, `updated_at`, `deleted_at`)
VALUES
	(1,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/lc70cff6d40844d52b9927fa9a406a13\",\"updatedAt\":\"2018-08-28T00:13:24.738000+00:00\"}','2018-08-28 00:39:28.602000','2018-08-28 00:39:28.602000',NULL),
	(2,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/lc70cff6d40844d52b9927fa9a406a13\",\"updatedAt\":\"2018-08-28T00:13:24.738000+00:00\"}','2018-08-28 00:39:28.617000','2018-08-28 00:39:28.617000',NULL),
	(3,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/lc70cff6d40844d52b9927fa9a406a13\",\"updatedAt\":\"2018-08-28T00:13:24.738000+00:00\"}','2018-08-28 00:39:28.625900','2018-08-28 00:39:28.625900',NULL),
	(4,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/lc70cff6d40844d52b9927fa9a406a13\",\"updatedAt\":\"2018-08-28T00:13:24.738000+00:00\"}','2018-08-28 00:39:28.637800','2018-08-28 00:39:28.637800',NULL),
	(5,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/lc70cff6d40844d52b9927fa9a406a13\",\"updatedAt\":\"2018-08-28T00:13:24.738000+00:00\"}','2018-08-28 00:39:28.645900','2018-08-28 00:39:28.645900',NULL),
	(6,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/lc70cff6d40844d52b9927fa9a406a13\",\"updatedAt\":\"2018-08-28T00:13:24.738000+00:00\"}','2018-08-28 00:39:28.655300','2018-08-28 00:39:28.655300',NULL),
	(7,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/v46402c7b431a4aea80ae220eec5263f\",\"updatedAt\":\"2018-08-28T00:04:20.385800+00:00\"}','2018-08-28 00:39:28.738600','2018-08-28 00:39:28.738600',NULL),
	(8,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/v46402c7b431a4aea80ae220eec5263f\",\"updatedAt\":\"2018-08-28T00:04:20.385800+00:00\"}','2018-08-28 00:39:28.752800','2018-08-28 00:39:28.752800',NULL),
	(9,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/v46402c7b431a4aea80ae220eec5263f\",\"updatedAt\":\"2018-08-28T00:04:20.385800+00:00\"}','2018-08-28 00:39:28.763700','2018-08-28 00:39:28.763700',NULL),
	(10,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/v46402c7b431a4aea80ae220eec5263f\",\"updatedAt\":\"2018-08-28T00:04:20.385800+00:00\"}','2018-08-28 00:39:28.774800','2018-08-28 00:39:28.774800',NULL),
	(11,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/v46402c7b431a4aea80ae220eec5263f\",\"updatedAt\":\"2018-08-28T00:04:20.385800+00:00\"}','2018-08-28 00:39:28.785900','2018-08-28 00:39:28.785900',NULL),
	(12,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/v46402c7b431a4aea80ae220eec5263f\",\"updatedAt\":\"2018-08-28T00:04:20.385800+00:00\"}','2018-08-28 00:39:28.800100','2018-08-28 00:39:28.800100',NULL),
	(13,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/ebaa086f7065d4c3c86781403b3aab5f\",\"updatedAt\":\"2018-08-28T00:04:20.407300+00:00\"}','2018-08-28 00:39:28.863300','2018-08-28 00:39:28.863300',NULL),
	(14,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/ebaa086f7065d4c3c86781403b3aab5f\",\"updatedAt\":\"2018-08-28T00:04:20.407300+00:00\"}','2018-08-28 00:39:28.878100','2018-08-28 00:39:28.878100',NULL),
	(15,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/ebaa086f7065d4c3c86781403b3aab5f\",\"updatedAt\":\"2018-08-28T00:04:20.407300+00:00\"}','2018-08-28 00:39:28.891300','2018-08-28 00:39:28.891300',NULL),
	(16,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/ebaa086f7065d4c3c86781403b3aab5f\",\"updatedAt\":\"2018-08-28T00:04:20.407300+00:00\"}','2018-08-28 00:39:28.901600','2018-08-28 00:39:28.901600',NULL),
	(17,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/ebaa086f7065d4c3c86781403b3aab5f\",\"updatedAt\":\"2018-08-28T00:04:20.407300+00:00\"}','2018-08-28 00:39:28.950900','2018-08-28 00:39:28.950900',NULL),
	(18,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/ebaa086f7065d4c3c86781403b3aab5f\",\"updatedAt\":\"2018-08-28T00:04:20.407300+00:00\"}','2018-08-28 00:39:28.959300','2018-08-28 00:39:28.959300',NULL),
	(19,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/m9fb083f87d3941f987253b40638c738\",\"updatedAt\":\"2018-08-28T00:04:20.416300+00:00\"}','2018-08-28 00:39:29.027600','2018-08-28 00:39:29.027600',NULL),
	(20,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/m9fb083f87d3941f987253b40638c738\",\"updatedAt\":\"2018-08-28T00:04:20.416300+00:00\"}','2018-08-28 00:39:29.047700','2018-08-28 00:39:29.047700',NULL),
	(21,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/m9fb083f87d3941f987253b40638c738\",\"updatedAt\":\"2018-08-28T00:04:20.416300+00:00\"}','2018-08-28 00:39:29.074100','2018-08-28 00:39:29.074100',NULL),
	(22,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/m9fb083f87d3941f987253b40638c738\",\"updatedAt\":\"2018-08-28T00:04:20.416300+00:00\"}','2018-08-28 00:39:29.103600','2018-08-28 00:39:29.103600',NULL),
	(23,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/m9fb083f87d3941f987253b40638c738\",\"updatedAt\":\"2018-08-28T00:04:20.416300+00:00\"}','2018-08-28 00:39:29.124500','2018-08-28 00:39:29.124500',NULL),
	(24,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/m9fb083f87d3941f987253b40638c738\",\"updatedAt\":\"2018-08-28T00:04:20.416300+00:00\"}','2018-08-28 00:39:29.134700','2018-08-28 00:39:29.134700',NULL),
	(25,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/xc97a04a91e4e461c8bdaf1ee57397a9\",\"updatedAt\":\"2018-08-28T00:04:20.423700+00:00\"}','2018-08-28 00:39:29.192500','2018-08-28 00:39:29.192500',NULL),
	(26,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/xc97a04a91e4e461c8bdaf1ee57397a9\",\"updatedAt\":\"2018-08-28T00:04:20.423700+00:00\"}','2018-08-28 00:39:29.203800','2018-08-28 00:39:29.203800',NULL),
	(27,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/xc97a04a91e4e461c8bdaf1ee57397a9\",\"updatedAt\":\"2018-08-28T00:04:20.423700+00:00\"}','2018-08-28 00:39:29.213300','2018-08-28 00:39:29.213300',NULL),
	(28,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/xc97a04a91e4e461c8bdaf1ee57397a9\",\"updatedAt\":\"2018-08-28T00:04:20.423700+00:00\"}','2018-08-28 00:39:29.221400','2018-08-28 00:39:29.221400',NULL),
	(29,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/xc97a04a91e4e461c8bdaf1ee57397a9\",\"updatedAt\":\"2018-08-28T00:04:20.423700+00:00\"}','2018-08-28 00:39:29.227600','2018-08-28 00:39:29.227600',NULL),
	(30,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/xc97a04a91e4e461c8bdaf1ee57397a9\",\"updatedAt\":\"2018-08-28T00:04:20.423700+00:00\"}','2018-08-28 00:39:29.233700','2018-08-28 00:39:29.233700',NULL),
	(31,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/lc70cff6d40844d52b9927fa9a406a13\",\"updatedAt\":\"2018-08-28T00:13:24.738000+00:00\"}','2018-08-28 00:39:29.301200','2018-08-28 00:39:29.301200',NULL),
	(32,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/lc70cff6d40844d52b9927fa9a406a13\",\"updatedAt\":\"2018-08-28T00:13:24.738000+00:00\"}','2018-08-28 00:39:29.311000','2018-08-28 00:39:29.311000',NULL),
	(33,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/lc70cff6d40844d52b9927fa9a406a13\",\"updatedAt\":\"2018-08-28T00:13:24.738000+00:00\"}','2018-08-28 00:39:29.318700','2018-08-28 00:39:29.318700',NULL),
	(34,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/lc70cff6d40844d52b9927fa9a406a13\",\"updatedAt\":\"2018-08-28T00:13:24.738000+00:00\"}','2018-08-28 00:39:29.328000','2018-08-28 00:39:29.328000',NULL),
	(35,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/lc70cff6d40844d52b9927fa9a406a13\",\"updatedAt\":\"2018-08-28T00:13:24.738000+00:00\"}','2018-08-28 00:39:29.335400','2018-08-28 00:39:29.335400',NULL),
	(36,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/lc70cff6d40844d52b9927fa9a406a13\",\"updatedAt\":\"2018-08-28T00:13:24.738000+00:00\"}','2018-08-28 00:39:29.346900','2018-08-28 00:39:29.346900',NULL),
	(37,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/attachments\\/vfc60395a035d41069bf6f8263557350\",\"updatedAt\":\"2018-08-28T00:05:20.787900+00:00\"}','2018-08-28 00:39:29.406800','2018-08-28 00:39:29.406800',NULL),
	(38,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/attachments\\/vfc60395a035d41069bf6f8263557350\",\"updatedAt\":\"2018-08-28T00:05:20.787900+00:00\"}','2018-08-28 00:39:29.417900','2018-08-28 00:39:29.417900',NULL),
	(39,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/attachments\\/vfc60395a035d41069bf6f8263557350\",\"updatedAt\":\"2018-08-28T00:05:20.787900+00:00\"}','2018-08-28 00:39:29.432600','2018-08-28 00:39:29.432600',NULL),
	(40,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/attachments\\/vfc60395a035d41069bf6f8263557350\",\"updatedAt\":\"2018-08-28T00:05:20.787900+00:00\"}','2018-08-28 00:39:29.446400','2018-08-28 00:39:29.446400',NULL),
	(41,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/attachments\\/vfc60395a035d41069bf6f8263557350\",\"updatedAt\":\"2018-08-28T00:05:20.787900+00:00\"}','2018-08-28 00:39:29.459000','2018-08-28 00:39:29.459000',NULL),
	(42,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/attachments\\/vfc60395a035d41069bf6f8263557350\",\"updatedAt\":\"2018-08-28T00:05:20.787900+00:00\"}','2018-08-28 00:39:29.469900','2018-08-28 00:39:29.469900',NULL),
	(43,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/v10654dbd44574da4a7fc36cbda7f976\",\"updatedAt\":\"2018-08-28T00:05:35.134800+00:00\"}','2018-08-28 00:39:29.524900','2018-08-28 00:39:29.524900',NULL),
	(44,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/v10654dbd44574da4a7fc36cbda7f976\",\"updatedAt\":\"2018-08-28T00:05:35.134800+00:00\"}','2018-08-28 00:39:29.543800','2018-08-28 00:39:29.543800',NULL),
	(45,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/v10654dbd44574da4a7fc36cbda7f976\",\"updatedAt\":\"2018-08-28T00:05:35.134800+00:00\"}','2018-08-28 00:39:29.554900','2018-08-28 00:39:29.554900',NULL),
	(46,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/v10654dbd44574da4a7fc36cbda7f976\",\"updatedAt\":\"2018-08-28T00:05:35.134800+00:00\"}','2018-08-28 00:39:29.568100','2018-08-28 00:39:29.568100',NULL),
	(47,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/v10654dbd44574da4a7fc36cbda7f976\",\"updatedAt\":\"2018-08-28T00:05:35.134800+00:00\"}','2018-08-28 00:39:29.582400','2018-08-28 00:39:29.582400',NULL),
	(48,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/v10654dbd44574da4a7fc36cbda7f976\",\"updatedAt\":\"2018-08-28T00:05:35.134800+00:00\"}','2018-08-28 00:39:29.596500','2018-08-28 00:39:29.596500',NULL),
	(49,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.657000','2018-08-28 00:39:29.657000',NULL),
	(50,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.667000','2018-08-28 00:39:29.667000',NULL),
	(51,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.680000','2018-08-28 00:39:29.680000',NULL),
	(52,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.690000','2018-08-28 00:39:29.690000',NULL),
	(53,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.700800','2018-08-28 00:39:29.700800',NULL),
	(54,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.720200','2018-08-28 00:39:29.720200',NULL),
	(55,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.781400','2018-08-28 00:39:29.781400',NULL),
	(56,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.789100','2018-08-28 00:39:29.789100',NULL),
	(57,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.797100','2018-08-28 00:39:29.797100',NULL),
	(58,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.804400','2018-08-28 00:39:29.804400',NULL),
	(59,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.817500','2018-08-28 00:39:29.817500',NULL),
	(60,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.826900','2018-08-28 00:39:29.826900',NULL),
	(61,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.887100','2018-08-28 00:39:29.887100',NULL),
	(62,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.902600','2018-08-28 00:39:29.902600',NULL),
	(63,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.912000','2018-08-28 00:39:29.912000',NULL),
	(64,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.927400','2018-08-28 00:39:29.927400',NULL),
	(65,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.938500','2018-08-28 00:39:29.938500',NULL),
	(66,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.949900','2018-08-28 00:39:29.949900',NULL),
	(67,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.981900','2018-08-28 00:39:29.981900',NULL),
	(68,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.990000','2018-08-28 00:39:29.990000',NULL),
	(69,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:29.996900','2018-08-28 00:39:29.996900',NULL),
	(70,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.014700','2018-08-28 00:39:30.014700',NULL),
	(71,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.027200','2018-08-28 00:39:30.027200',NULL),
	(72,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.037300','2018-08-28 00:39:30.037300',NULL),
	(73,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.072900','2018-08-28 00:39:30.072900',NULL),
	(74,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.081800','2018-08-28 00:39:30.081800',NULL),
	(75,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.093000','2018-08-28 00:39:30.093000',NULL),
	(76,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.102700','2018-08-28 00:39:30.102700',NULL),
	(77,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.115700','2018-08-28 00:39:30.115700',NULL),
	(78,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.127300','2018-08-28 00:39:30.127300',NULL),
	(79,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.173200','2018-08-28 00:39:30.173200',NULL),
	(80,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.182700','2018-08-28 00:39:30.182700',NULL),
	(81,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.195300','2018-08-28 00:39:30.195300',NULL),
	(82,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.203200','2018-08-28 00:39:30.203200',NULL),
	(83,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.216300','2018-08-28 00:39:30.216300',NULL),
	(84,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.235500','2018-08-28 00:39:30.235500',NULL),
	(85,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.298900','2018-08-28 00:39:30.298900',NULL),
	(86,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.317800','2018-08-28 00:39:30.317800',NULL),
	(87,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.336200','2018-08-28 00:39:30.336200',NULL),
	(88,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.344400','2018-08-28 00:39:30.344400',NULL),
	(89,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.355600','2018-08-28 00:39:30.355600',NULL),
	(90,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.372300','2018-08-28 00:39:30.372300',NULL),
	(91,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.416300','2018-08-28 00:39:30.416300',NULL),
	(92,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.427700','2018-08-28 00:39:30.427700',NULL),
	(93,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.438500','2018-08-28 00:39:30.438500',NULL),
	(94,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.451600','2018-08-28 00:39:30.451600',NULL),
	(95,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.463700','2018-08-28 00:39:30.463700',NULL),
	(96,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.472700','2018-08-28 00:39:30.472700',NULL),
	(97,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/lc70cff6d40844d52b9927fa9a406a13\",\"updatedAt\":\"2018-08-28T00:13:24.738000+00:00\"}','2018-08-28 00:39:30.505499','2018-08-28 00:39:30.505499',NULL),
	(98,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/lc70cff6d40844d52b9927fa9a406a13\",\"updatedAt\":\"2018-08-28T00:13:24.738000+00:00\"}','2018-08-28 00:39:30.515399','2018-08-28 00:39:30.515399',NULL),
	(99,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/lc70cff6d40844d52b9927fa9a406a13\",\"updatedAt\":\"2018-08-28T00:13:24.738000+00:00\"}','2018-08-28 00:39:30.528700','2018-08-28 00:39:30.528700',NULL),
	(100,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/lc70cff6d40844d52b9927fa9a406a13\",\"updatedAt\":\"2018-08-28T00:13:24.738000+00:00\"}','2018-08-28 00:39:30.537700','2018-08-28 00:39:30.537700',NULL),
	(101,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/lc70cff6d40844d52b9927fa9a406a13\",\"updatedAt\":\"2018-08-28T00:13:24.738000+00:00\"}','2018-08-28 00:39:30.546300','2018-08-28 00:39:30.546300',NULL),
	(102,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/lc70cff6d40844d52b9927fa9a406a13\",\"updatedAt\":\"2018-08-28T00:13:24.738000+00:00\"}','2018-08-28 00:39:30.556300','2018-08-28 00:39:30.556300',NULL),
	(103,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.604600','2018-08-28 00:39:30.604600',NULL),
	(104,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.613100','2018-08-28 00:39:30.613100',NULL),
	(105,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.624000','2018-08-28 00:39:30.624000',NULL),
	(106,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.633900','2018-08-28 00:39:30.633900',NULL),
	(107,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.644200','2018-08-28 00:39:30.644200',NULL),
	(108,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.654400','2018-08-28 00:39:30.654400',NULL),
	(109,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.697900','2018-08-28 00:39:30.697900',NULL),
	(110,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.705000','2018-08-28 00:39:30.705000',NULL),
	(111,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.713500','2018-08-28 00:39:30.713500',NULL),
	(112,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.725600','2018-08-28 00:39:30.725600',NULL),
	(113,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.737300','2018-08-28 00:39:30.737300',NULL),
	(114,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.748500','2018-08-28 00:39:30.748500',NULL),
	(115,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.820700','2018-08-28 00:39:30.820700',NULL),
	(116,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.833700','2018-08-28 00:39:30.833700',NULL),
	(117,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.847100','2018-08-28 00:39:30.847100',NULL),
	(118,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.863100','2018-08-28 00:39:30.863100',NULL),
	(119,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.873300','2018-08-28 00:39:30.873300',NULL),
	(120,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.881500','2018-08-28 00:39:30.881500',NULL),
	(121,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.923700','2018-08-28 00:39:30.923700',NULL),
	(122,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.934300','2018-08-28 00:39:30.934300',NULL),
	(123,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.949300','2018-08-28 00:39:30.949300',NULL),
	(124,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.967000','2018-08-28 00:39:30.967000',NULL),
	(125,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.982200','2018-08-28 00:39:30.982200',NULL),
	(126,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:30.997900','2018-08-28 00:39:30.997900',NULL),
	(127,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.043100','2018-08-28 00:39:31.043100',NULL),
	(128,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.057500','2018-08-28 00:39:31.057500',NULL),
	(129,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.067000','2018-08-28 00:39:31.067000',NULL),
	(130,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.077700','2018-08-28 00:39:31.077700',NULL),
	(131,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.105000','2018-08-28 00:39:31.105000',NULL),
	(132,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.113000','2018-08-28 00:39:31.113000',NULL),
	(133,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/k4ee0d0024c6f408fbebb772b4ebf9b5\",\"updatedAt\":\"2018-08-28T00:14:02.983500+00:00\"}','2018-08-28 00:39:31.185600','2018-08-28 00:39:31.185600',NULL),
	(134,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/k4ee0d0024c6f408fbebb772b4ebf9b5\",\"updatedAt\":\"2018-08-28T00:14:02.983500+00:00\"}','2018-08-28 00:39:31.196800','2018-08-28 00:39:31.196800',NULL),
	(135,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/k4ee0d0024c6f408fbebb772b4ebf9b5\",\"updatedAt\":\"2018-08-28T00:14:02.983500+00:00\"}','2018-08-28 00:39:31.214400','2018-08-28 00:39:31.214400',NULL),
	(136,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/k4ee0d0024c6f408fbebb772b4ebf9b5\",\"updatedAt\":\"2018-08-28T00:14:02.983500+00:00\"}','2018-08-28 00:39:31.225700','2018-08-28 00:39:31.225700',NULL),
	(137,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/k4ee0d0024c6f408fbebb772b4ebf9b5\",\"updatedAt\":\"2018-08-28T00:14:02.983500+00:00\"}','2018-08-28 00:39:31.234900','2018-08-28 00:39:31.234900',NULL),
	(138,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/k4ee0d0024c6f408fbebb772b4ebf9b5\",\"updatedAt\":\"2018-08-28T00:14:02.983500+00:00\"}','2018-08-28 00:39:31.242900','2018-08-28 00:39:31.242900',NULL),
	(139,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/b4f4c2a8e695f4ecca11e7aca71b0a4d\",\"updatedAt\":\"2018-08-28T00:14:10.944200+00:00\"}','2018-08-28 00:39:31.274000','2018-08-28 00:39:31.274000',NULL),
	(140,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/b4f4c2a8e695f4ecca11e7aca71b0a4d\",\"updatedAt\":\"2018-08-28T00:14:10.944200+00:00\"}','2018-08-28 00:39:31.283500','2018-08-28 00:39:31.283500',NULL),
	(141,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/b4f4c2a8e695f4ecca11e7aca71b0a4d\",\"updatedAt\":\"2018-08-28T00:14:10.944200+00:00\"}','2018-08-28 00:39:31.300300','2018-08-28 00:39:31.300300',NULL),
	(142,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/b4f4c2a8e695f4ecca11e7aca71b0a4d\",\"updatedAt\":\"2018-08-28T00:14:10.944200+00:00\"}','2018-08-28 00:39:31.311800','2018-08-28 00:39:31.311800',NULL),
	(143,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/b4f4c2a8e695f4ecca11e7aca71b0a4d\",\"updatedAt\":\"2018-08-28T00:14:10.944200+00:00\"}','2018-08-28 00:39:31.322400','2018-08-28 00:39:31.322400',NULL),
	(144,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/b4f4c2a8e695f4ecca11e7aca71b0a4d\",\"updatedAt\":\"2018-08-28T00:14:10.944200+00:00\"}','2018-08-28 00:39:31.330700','2018-08-28 00:39:31.330700',NULL),
	(145,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/g6a3da4f992d74e63bf73335a3d7f9b7\",\"updatedAt\":\"2018-08-28T00:14:32.414800+00:00\"}','2018-08-28 00:39:31.363300','2018-08-28 00:39:31.363300',NULL),
	(146,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/g6a3da4f992d74e63bf73335a3d7f9b7\",\"updatedAt\":\"2018-08-28T00:14:32.414800+00:00\"}','2018-08-28 00:39:31.370000','2018-08-28 00:39:31.370000',NULL),
	(147,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/g6a3da4f992d74e63bf73335a3d7f9b7\",\"updatedAt\":\"2018-08-28T00:14:32.414800+00:00\"}','2018-08-28 00:39:31.376300','2018-08-28 00:39:31.376300',NULL),
	(148,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/g6a3da4f992d74e63bf73335a3d7f9b7\",\"updatedAt\":\"2018-08-28T00:14:32.414800+00:00\"}','2018-08-28 00:39:31.382900','2018-08-28 00:39:31.382900',NULL),
	(149,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/g6a3da4f992d74e63bf73335a3d7f9b7\",\"updatedAt\":\"2018-08-28T00:14:32.414800+00:00\"}','2018-08-28 00:39:31.394400','2018-08-28 00:39:31.394400',NULL),
	(150,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/g6a3da4f992d74e63bf73335a3d7f9b7\",\"updatedAt\":\"2018-08-28T00:14:32.414800+00:00\"}','2018-08-28 00:39:31.401000','2018-08-28 00:39:31.401000',NULL),
	(151,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/sba6718e290774e3f98feb07a51bd332\",\"updatedAt\":\"2018-08-28T00:14:38.435400+00:00\"}','2018-08-28 00:39:31.433100','2018-08-28 00:39:31.433100',NULL),
	(152,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/sba6718e290774e3f98feb07a51bd332\",\"updatedAt\":\"2018-08-28T00:14:38.435400+00:00\"}','2018-08-28 00:39:31.440400','2018-08-28 00:39:31.440400',NULL),
	(153,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/sba6718e290774e3f98feb07a51bd332\",\"updatedAt\":\"2018-08-28T00:14:38.435400+00:00\"}','2018-08-28 00:39:31.447600','2018-08-28 00:39:31.447600',NULL),
	(154,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/sba6718e290774e3f98feb07a51bd332\",\"updatedAt\":\"2018-08-28T00:14:38.435400+00:00\"}','2018-08-28 00:39:31.454800','2018-08-28 00:39:31.454800',NULL),
	(155,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/sba6718e290774e3f98feb07a51bd332\",\"updatedAt\":\"2018-08-28T00:14:38.435400+00:00\"}','2018-08-28 00:39:31.462900','2018-08-28 00:39:31.462900',NULL),
	(156,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/sba6718e290774e3f98feb07a51bd332\",\"updatedAt\":\"2018-08-28T00:14:38.435400+00:00\"}','2018-08-28 00:39:31.473700','2018-08-28 00:39:31.473700',NULL),
	(157,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.501100','2018-08-28 00:39:31.501100',NULL),
	(158,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.506600','2018-08-28 00:39:31.506600',NULL),
	(159,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.510499','2018-08-28 00:39:31.510499',NULL),
	(160,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.514700','2018-08-28 00:39:31.514700',NULL),
	(161,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.526900','2018-08-28 00:39:31.526900',NULL),
	(162,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.539100','2018-08-28 00:39:31.539100',NULL),
	(163,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.625200','2018-08-28 00:39:31.625200',NULL),
	(164,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.635000','2018-08-28 00:39:31.635000',NULL),
	(165,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.648700','2018-08-28 00:39:31.648700',NULL),
	(166,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.658900','2018-08-28 00:39:31.658900',NULL),
	(167,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.667300','2018-08-28 00:39:31.667300',NULL),
	(168,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.673900','2018-08-28 00:39:31.673900',NULL),
	(169,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/zcda01b14200644a79a16126992f807a\",\"updatedAt\":\"2018-08-28T00:15:59.479800+00:00\"}','2018-08-28 00:39:31.700100','2018-08-28 00:39:31.700100',NULL),
	(170,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/zcda01b14200644a79a16126992f807a\",\"updatedAt\":\"2018-08-28T00:15:59.479800+00:00\"}','2018-08-28 00:39:31.705400','2018-08-28 00:39:31.705400',NULL),
	(171,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/zcda01b14200644a79a16126992f807a\",\"updatedAt\":\"2018-08-28T00:15:59.479800+00:00\"}','2018-08-28 00:39:31.709800','2018-08-28 00:39:31.709800',NULL),
	(172,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/zcda01b14200644a79a16126992f807a\",\"updatedAt\":\"2018-08-28T00:15:59.479800+00:00\"}','2018-08-28 00:39:31.719000','2018-08-28 00:39:31.719000',NULL),
	(173,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/zcda01b14200644a79a16126992f807a\",\"updatedAt\":\"2018-08-28T00:15:59.479800+00:00\"}','2018-08-28 00:39:31.729900','2018-08-28 00:39:31.729900',NULL),
	(174,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/zcda01b14200644a79a16126992f807a\",\"updatedAt\":\"2018-08-28T00:15:59.479800+00:00\"}','2018-08-28 00:39:31.738600','2018-08-28 00:39:31.738600',NULL),
	(175,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.770600','2018-08-28 00:39:31.770600',NULL),
	(176,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.780800','2018-08-28 00:39:31.780800',NULL),
	(177,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.786400','2018-08-28 00:39:31.786400',NULL),
	(178,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.791600','2018-08-28 00:39:31.791600',NULL),
	(179,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.798100','2018-08-28 00:39:31.798100',NULL),
	(180,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.805800','2018-08-28 00:39:31.805800',NULL),
	(181,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.832200','2018-08-28 00:39:31.832200',NULL),
	(182,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.845600','2018-08-28 00:39:31.845600',NULL),
	(183,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.852300','2018-08-28 00:39:31.852300',NULL),
	(184,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.858800','2018-08-28 00:39:31.858800',NULL),
	(185,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.865200','2018-08-28 00:39:31.865200',NULL),
	(186,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.872000','2018-08-28 00:39:31.872000',NULL),
	(187,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/h1e210e3ce3aa43a5b3fde8547648cce\",\"updatedAt\":\"2018-08-28T00:16:46.982400+00:00\"}','2018-08-28 00:39:31.905800','2018-08-28 00:39:31.905800',NULL),
	(188,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/h1e210e3ce3aa43a5b3fde8547648cce\",\"updatedAt\":\"2018-08-28T00:16:46.982400+00:00\"}','2018-08-28 00:39:31.913600','2018-08-28 00:39:31.913600',NULL),
	(189,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/h1e210e3ce3aa43a5b3fde8547648cce\",\"updatedAt\":\"2018-08-28T00:16:46.982400+00:00\"}','2018-08-28 00:39:31.921000','2018-08-28 00:39:31.921000',NULL),
	(190,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/h1e210e3ce3aa43a5b3fde8547648cce\",\"updatedAt\":\"2018-08-28T00:16:46.982400+00:00\"}','2018-08-28 00:39:31.927500','2018-08-28 00:39:31.927500',NULL),
	(191,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/h1e210e3ce3aa43a5b3fde8547648cce\",\"updatedAt\":\"2018-08-28T00:16:46.982400+00:00\"}','2018-08-28 00:39:31.934400','2018-08-28 00:39:31.934400',NULL),
	(192,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/h1e210e3ce3aa43a5b3fde8547648cce\",\"updatedAt\":\"2018-08-28T00:16:46.982400+00:00\"}','2018-08-28 00:39:31.942200','2018-08-28 00:39:31.942200',NULL),
	(193,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.977800','2018-08-28 00:39:31.977800',NULL),
	(194,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.987400','2018-08-28 00:39:31.987400',NULL),
	(195,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:31.995000','2018-08-28 00:39:31.995000',NULL),
	(196,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.001600','2018-08-28 00:39:32.001600',NULL),
	(197,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.010100','2018-08-28 00:39:32.010100',NULL),
	(198,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.018400','2018-08-28 00:39:32.018400',NULL),
	(199,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.054900','2018-08-28 00:39:32.054900',NULL),
	(200,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.062700','2018-08-28 00:39:32.062700',NULL),
	(201,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.072100','2018-08-28 00:39:32.072100',NULL),
	(202,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.079800','2018-08-28 00:39:32.079800',NULL),
	(203,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.089800','2018-08-28 00:39:32.089800',NULL),
	(204,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.099200','2018-08-28 00:39:32.099200',NULL),
	(205,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/d74943de54eef49108523c16ac493e86\",\"updatedAt\":\"2018-08-28T00:18:18.896200+00:00\"}','2018-08-28 00:39:32.146100','2018-08-28 00:39:32.146100',NULL),
	(206,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/d74943de54eef49108523c16ac493e86\",\"updatedAt\":\"2018-08-28T00:18:18.896200+00:00\"}','2018-08-28 00:39:32.154100','2018-08-28 00:39:32.154100',NULL),
	(207,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/d74943de54eef49108523c16ac493e86\",\"updatedAt\":\"2018-08-28T00:18:18.896200+00:00\"}','2018-08-28 00:39:32.168200','2018-08-28 00:39:32.168200',NULL),
	(208,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/d74943de54eef49108523c16ac493e86\",\"updatedAt\":\"2018-08-28T00:18:18.896200+00:00\"}','2018-08-28 00:39:32.181300','2018-08-28 00:39:32.181300',NULL),
	(209,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/d74943de54eef49108523c16ac493e86\",\"updatedAt\":\"2018-08-28T00:18:18.896200+00:00\"}','2018-08-28 00:39:32.187400','2018-08-28 00:39:32.187400',NULL),
	(210,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/d74943de54eef49108523c16ac493e86\",\"updatedAt\":\"2018-08-28T00:18:18.896200+00:00\"}','2018-08-28 00:39:32.192500','2018-08-28 00:39:32.192500',NULL),
	(211,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignmentGroups\\/u7129256ba9ac406bab45cb471a1ec48\",\"updatedAt\":\"2018-08-28T00:18:18.943400+00:00\"}','2018-08-28 00:39:32.231100','2018-08-28 00:39:32.231100',NULL),
	(212,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignmentGroups\\/u7129256ba9ac406bab45cb471a1ec48\",\"updatedAt\":\"2018-08-28T00:18:18.943400+00:00\"}','2018-08-28 00:39:32.240200','2018-08-28 00:39:32.240200',NULL),
	(213,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignmentGroups\\/u7129256ba9ac406bab45cb471a1ec48\",\"updatedAt\":\"2018-08-28T00:18:18.943400+00:00\"}','2018-08-28 00:39:32.250500','2018-08-28 00:39:32.250500',NULL),
	(214,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignmentGroups\\/u7129256ba9ac406bab45cb471a1ec48\",\"updatedAt\":\"2018-08-28T00:18:18.943400+00:00\"}','2018-08-28 00:39:32.257799','2018-08-28 00:39:32.257799',NULL),
	(215,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignmentGroups\\/u7129256ba9ac406bab45cb471a1ec48\",\"updatedAt\":\"2018-08-28T00:18:18.943400+00:00\"}','2018-08-28 00:39:32.266000','2018-08-28 00:39:32.266000',NULL),
	(216,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignmentGroups\\/u7129256ba9ac406bab45cb471a1ec48\",\"updatedAt\":\"2018-08-28T00:18:18.943400+00:00\"}','2018-08-28 00:39:32.279500','2018-08-28 00:39:32.279500',NULL),
	(217,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignmentGroups\\/xe4f2cc7ff1024db0b94ba891fa0319d\",\"updatedAt\":\"2018-08-28T00:18:18.962700+00:00\"}','2018-08-28 00:39:32.311900','2018-08-28 00:39:32.311900',NULL),
	(218,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignmentGroups\\/xe4f2cc7ff1024db0b94ba891fa0319d\",\"updatedAt\":\"2018-08-28T00:18:18.962700+00:00\"}','2018-08-28 00:39:32.320700','2018-08-28 00:39:32.320700',NULL),
	(219,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignmentGroups\\/xe4f2cc7ff1024db0b94ba891fa0319d\",\"updatedAt\":\"2018-08-28T00:18:18.962700+00:00\"}','2018-08-28 00:39:32.328400','2018-08-28 00:39:32.328400',NULL),
	(220,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignmentGroups\\/xe4f2cc7ff1024db0b94ba891fa0319d\",\"updatedAt\":\"2018-08-28T00:18:18.962700+00:00\"}','2018-08-28 00:39:32.338300','2018-08-28 00:39:32.338300',NULL),
	(221,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignmentGroups\\/xe4f2cc7ff1024db0b94ba891fa0319d\",\"updatedAt\":\"2018-08-28T00:18:18.962700+00:00\"}','2018-08-28 00:39:32.347700','2018-08-28 00:39:32.347700',NULL),
	(222,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignmentGroups\\/xe4f2cc7ff1024db0b94ba891fa0319d\",\"updatedAt\":\"2018-08-28T00:18:18.962700+00:00\"}','2018-08-28 00:39:32.357500','2018-08-28 00:39:32.357500',NULL),
	(223,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.425400','2018-08-28 00:39:32.425400',NULL),
	(224,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.434500','2018-08-28 00:39:32.434500',NULL),
	(225,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.444900','2018-08-28 00:39:32.444900',NULL),
	(226,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.466900','2018-08-28 00:39:32.466900',NULL),
	(227,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.481900','2018-08-28 00:39:32.481900',NULL),
	(228,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.492400','2018-08-28 00:39:32.492400',NULL),
	(229,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.545200','2018-08-28 00:39:32.545200',NULL),
	(230,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.557400','2018-08-28 00:39:32.557400',NULL),
	(231,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.568900','2018-08-28 00:39:32.568900',NULL),
	(232,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.581300','2018-08-28 00:39:32.581300',NULL),
	(233,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.597400','2018-08-28 00:39:32.597400',NULL),
	(234,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.610400','2018-08-28 00:39:32.610400',NULL),
	(235,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/ud7c1186e1a44432a963cdacd4368e4d\",\"updatedAt\":\"2018-08-28T00:19:01.029000+00:00\"}','2018-08-28 00:39:32.666300','2018-08-28 00:39:32.666300',NULL),
	(236,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/ud7c1186e1a44432a963cdacd4368e4d\",\"updatedAt\":\"2018-08-28T00:19:01.029000+00:00\"}','2018-08-28 00:39:32.680400','2018-08-28 00:39:32.680400',NULL),
	(237,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/ud7c1186e1a44432a963cdacd4368e4d\",\"updatedAt\":\"2018-08-28T00:19:01.029000+00:00\"}','2018-08-28 00:39:32.695300','2018-08-28 00:39:32.695300',NULL),
	(238,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/ud7c1186e1a44432a963cdacd4368e4d\",\"updatedAt\":\"2018-08-28T00:19:01.029000+00:00\"}','2018-08-28 00:39:32.718000','2018-08-28 00:39:32.718000',NULL),
	(239,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/ud7c1186e1a44432a963cdacd4368e4d\",\"updatedAt\":\"2018-08-28T00:19:01.029000+00:00\"}','2018-08-28 00:39:32.733000','2018-08-28 00:39:32.733000',NULL),
	(240,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/ud7c1186e1a44432a963cdacd4368e4d\",\"updatedAt\":\"2018-08-28T00:19:01.029000+00:00\"}','2018-08-28 00:39:32.747900','2018-08-28 00:39:32.747900',NULL),
	(241,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.810800','2018-08-28 00:39:32.810800',NULL),
	(242,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.828200','2018-08-28 00:39:32.828200',NULL),
	(243,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.843800','2018-08-28 00:39:32.843800',NULL),
	(244,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.858200','2018-08-28 00:39:32.858200',NULL),
	(245,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.882800','2018-08-28 00:39:32.882800',NULL),
	(246,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.890900','2018-08-28 00:39:32.890900',NULL),
	(247,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.932900','2018-08-28 00:39:32.932900',NULL),
	(248,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.946100','2018-08-28 00:39:32.946100',NULL),
	(249,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.958600','2018-08-28 00:39:32.958600',NULL),
	(250,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.975700','2018-08-28 00:39:32.975700',NULL),
	(251,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:32.991200','2018-08-28 00:39:32.991200',NULL),
	(252,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.006900','2018-08-28 00:39:33.006900',NULL),
	(253,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/c40d8a7ce79894a879ee92d410052626\",\"updatedAt\":\"2018-08-28T00:19:55.745200+00:00\"}','2018-08-28 00:39:33.044900','2018-08-28 00:39:33.044900',NULL),
	(254,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/c40d8a7ce79894a879ee92d410052626\",\"updatedAt\":\"2018-08-28T00:19:55.745200+00:00\"}','2018-08-28 00:39:33.057900','2018-08-28 00:39:33.057900',NULL),
	(255,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/c40d8a7ce79894a879ee92d410052626\",\"updatedAt\":\"2018-08-28T00:19:55.745200+00:00\"}','2018-08-28 00:39:33.068300','2018-08-28 00:39:33.068300',NULL),
	(256,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/c40d8a7ce79894a879ee92d410052626\",\"updatedAt\":\"2018-08-28T00:19:55.745200+00:00\"}','2018-08-28 00:39:33.078500','2018-08-28 00:39:33.078500',NULL),
	(257,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/c40d8a7ce79894a879ee92d410052626\",\"updatedAt\":\"2018-08-28T00:19:55.745200+00:00\"}','2018-08-28 00:39:33.089000','2018-08-28 00:39:33.089000',NULL),
	(258,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/c40d8a7ce79894a879ee92d410052626\",\"updatedAt\":\"2018-08-28T00:19:55.745200+00:00\"}','2018-08-28 00:39:33.105000','2018-08-28 00:39:33.105000',NULL),
	(259,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.140300','2018-08-28 00:39:33.140300',NULL),
	(260,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.148100','2018-08-28 00:39:33.148100',NULL),
	(261,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.155600','2018-08-28 00:39:33.155600',NULL),
	(262,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.167600','2018-08-28 00:39:33.167600',NULL),
	(263,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.182700','2018-08-28 00:39:33.182700',NULL),
	(264,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.195300','2018-08-28 00:39:33.195300',NULL),
	(265,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.262700','2018-08-28 00:39:33.262700',NULL),
	(266,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.279500','2018-08-28 00:39:33.279500',NULL),
	(267,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.292500','2018-08-28 00:39:33.292500',NULL),
	(268,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.300600','2018-08-28 00:39:33.300600',NULL),
	(269,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.312300','2018-08-28 00:39:33.312300',NULL),
	(270,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.318500','2018-08-28 00:39:33.318500',NULL),
	(271,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/lf1f97d5feb6746769401727a7d7988e\",\"updatedAt\":\"2018-08-28T00:20:29.855900+00:00\"}','2018-08-28 00:39:33.371200','2018-08-28 00:39:33.371200',NULL),
	(272,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/lf1f97d5feb6746769401727a7d7988e\",\"updatedAt\":\"2018-08-28T00:20:29.855900+00:00\"}','2018-08-28 00:39:33.384000','2018-08-28 00:39:33.384000',NULL),
	(273,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/lf1f97d5feb6746769401727a7d7988e\",\"updatedAt\":\"2018-08-28T00:20:29.855900+00:00\"}','2018-08-28 00:39:33.404400','2018-08-28 00:39:33.404400',NULL),
	(274,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/lf1f97d5feb6746769401727a7d7988e\",\"updatedAt\":\"2018-08-28T00:20:29.855900+00:00\"}','2018-08-28 00:39:33.429200','2018-08-28 00:39:33.429200',NULL),
	(275,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/lf1f97d5feb6746769401727a7d7988e\",\"updatedAt\":\"2018-08-28T00:20:29.855900+00:00\"}','2018-08-28 00:39:33.447300','2018-08-28 00:39:33.447300',NULL),
	(276,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/assignments\\/lf1f97d5feb6746769401727a7d7988e\",\"updatedAt\":\"2018-08-28T00:20:29.855900+00:00\"}','2018-08-28 00:39:33.466400','2018-08-28 00:39:33.466400',NULL),
	(277,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.545000','2018-08-28 00:39:33.545000',NULL),
	(278,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.563300','2018-08-28 00:39:33.563300',NULL),
	(279,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.578600','2018-08-28 00:39:33.578600',NULL),
	(280,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.596800','2018-08-28 00:39:33.596800',NULL),
	(281,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.611000','2018-08-28 00:39:33.611000',NULL),
	(282,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.621400','2018-08-28 00:39:33.621400',NULL),
	(283,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.680000','2018-08-28 00:39:33.680000',NULL),
	(284,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.689900','2018-08-28 00:39:33.689900',NULL),
	(285,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.701000','2018-08-28 00:39:33.701000',NULL),
	(286,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.713000','2018-08-28 00:39:33.713000',NULL),
	(287,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.725800','2018-08-28 00:39:33.725800',NULL),
	(288,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.742000','2018-08-28 00:39:33.742000',NULL),
	(289,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.796100','2018-08-28 00:39:33.796100',NULL),
	(290,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.807000','2018-08-28 00:39:33.807000',NULL),
	(291,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.815700','2018-08-28 00:39:33.815700',NULL),
	(292,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.824800','2018-08-28 00:39:33.824800',NULL),
	(293,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.834400','2018-08-28 00:39:33.834400',NULL),
	(294,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.846500','2018-08-28 00:39:33.846500',NULL),
	(295,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.901600','2018-08-28 00:39:33.901600',NULL),
	(296,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.914400','2018-08-28 00:39:33.914400',NULL),
	(297,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.928900','2018-08-28 00:39:33.928900',NULL),
	(298,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.940100','2018-08-28 00:39:33.940100',NULL),
	(299,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.953900','2018-08-28 00:39:33.953900',NULL),
	(300,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.962500','2018-08-28 00:39:33.962500',NULL),
	(301,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:33.997700','2018-08-28 00:39:33.997700',NULL),
	(302,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:34.011500','2018-08-28 00:39:34.011500',NULL),
	(303,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:34.020100','2018-08-28 00:39:34.020100',NULL),
	(304,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:34.044900','2018-08-28 00:39:34.044900',NULL),
	(305,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:34.061200','2018-08-28 00:39:34.061200',NULL),
	(306,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/y2dfd06aceeb94d648c36ee201dbad72\",\"updatedAt\":\"2018-08-28T00:20:50.735300+00:00\"}','2018-08-28 00:39:34.086200','2018-08-28 00:39:34.086200',NULL),
	(307,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/a94879b1c3b8e482babd7d8141d0d269\",\"updatedAt\":\"2018-08-28T00:21:13.836300+00:00\"}','2018-08-28 00:39:34.171500','2018-08-28 00:39:34.171500',NULL),
	(308,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/a94879b1c3b8e482babd7d8141d0d269\",\"updatedAt\":\"2018-08-28T00:21:13.836300+00:00\"}','2018-08-28 00:39:34.186100','2018-08-28 00:39:34.186100',NULL),
	(309,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/a94879b1c3b8e482babd7d8141d0d269\",\"updatedAt\":\"2018-08-28T00:21:13.836300+00:00\"}','2018-08-28 00:39:34.198700','2018-08-28 00:39:34.198700',NULL),
	(310,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/a94879b1c3b8e482babd7d8141d0d269\",\"updatedAt\":\"2018-08-28T00:21:13.836300+00:00\"}','2018-08-28 00:39:34.212400','2018-08-28 00:39:34.212400',NULL),
	(311,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/a94879b1c3b8e482babd7d8141d0d269\",\"updatedAt\":\"2018-08-28T00:21:13.836300+00:00\"}','2018-08-28 00:39:34.232200','2018-08-28 00:39:34.232200',NULL),
	(312,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/a94879b1c3b8e482babd7d8141d0d269\",\"updatedAt\":\"2018-08-28T00:21:13.836300+00:00\"}','2018-08-28 00:39:34.240200','2018-08-28 00:39:34.240200',NULL),
	(313,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/a94879b1c3b8e482babd7d8141d0d269\",\"updatedAt\":\"2018-08-28T00:21:13.836300+00:00\"}','2018-08-28 00:39:34.316300','2018-08-28 00:39:34.316300',NULL),
	(314,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/a94879b1c3b8e482babd7d8141d0d269\",\"updatedAt\":\"2018-08-28T00:21:13.836300+00:00\"}','2018-08-28 00:39:34.330800','2018-08-28 00:39:34.330800',NULL),
	(315,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/a94879b1c3b8e482babd7d8141d0d269\",\"updatedAt\":\"2018-08-28T00:21:13.836300+00:00\"}','2018-08-28 00:39:34.354500','2018-08-28 00:39:34.354500',NULL),
	(316,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/a94879b1c3b8e482babd7d8141d0d269\",\"updatedAt\":\"2018-08-28T00:21:13.836300+00:00\"}','2018-08-28 00:39:34.377300','2018-08-28 00:39:34.377300',NULL),
	(317,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/a94879b1c3b8e482babd7d8141d0d269\",\"updatedAt\":\"2018-08-28T00:21:13.836300+00:00\"}','2018-08-28 00:39:34.409500','2018-08-28 00:39:34.409500',NULL),
	(318,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/a94879b1c3b8e482babd7d8141d0d269\",\"updatedAt\":\"2018-08-28T00:21:13.836300+00:00\"}','2018-08-28 00:39:34.435700','2018-08-28 00:39:34.435700',NULL),
	(319,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/jf4547db62c1e4a309a85db18fbaf4a8\",\"updatedAt\":\"2018-08-28T00:22:52.530000+00:00\"}','2018-08-28 00:39:34.502100','2018-08-28 00:39:34.502100',NULL),
	(320,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/jf4547db62c1e4a309a85db18fbaf4a8\",\"updatedAt\":\"2018-08-28T00:22:52.530000+00:00\"}','2018-08-28 00:39:34.521700','2018-08-28 00:39:34.521700',NULL),
	(321,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/jf4547db62c1e4a309a85db18fbaf4a8\",\"updatedAt\":\"2018-08-28T00:22:52.530000+00:00\"}','2018-08-28 00:39:34.537400','2018-08-28 00:39:34.537400',NULL),
	(322,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/jf4547db62c1e4a309a85db18fbaf4a8\",\"updatedAt\":\"2018-08-28T00:22:52.530000+00:00\"}','2018-08-28 00:39:34.563400','2018-08-28 00:39:34.563400',NULL),
	(323,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/jf4547db62c1e4a309a85db18fbaf4a8\",\"updatedAt\":\"2018-08-28T00:22:52.530000+00:00\"}','2018-08-28 00:39:34.584400','2018-08-28 00:39:34.584400',NULL),
	(324,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/jf4547db62c1e4a309a85db18fbaf4a8\",\"updatedAt\":\"2018-08-28T00:22:52.530000+00:00\"}','2018-08-28 00:39:34.609900','2018-08-28 00:39:34.609900',NULL),
	(325,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/we313ecb37dba45f599960437c86c59a\",\"updatedAt\":\"2018-08-28T00:22:56.088500+00:00\"}','2018-08-28 00:39:34.671500','2018-08-28 00:39:34.671500',NULL),
	(326,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/we313ecb37dba45f599960437c86c59a\",\"updatedAt\":\"2018-08-28T00:22:56.088500+00:00\"}','2018-08-28 00:39:34.685900','2018-08-28 00:39:34.685900',NULL),
	(327,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/we313ecb37dba45f599960437c86c59a\",\"updatedAt\":\"2018-08-28T00:22:56.088500+00:00\"}','2018-08-28 00:39:34.698100','2018-08-28 00:39:34.698100',NULL),
	(328,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/we313ecb37dba45f599960437c86c59a\",\"updatedAt\":\"2018-08-28T00:22:56.088500+00:00\"}','2018-08-28 00:39:34.710300','2018-08-28 00:39:34.710300',NULL),
	(329,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/we313ecb37dba45f599960437c86c59a\",\"updatedAt\":\"2018-08-28T00:22:56.088500+00:00\"}','2018-08-28 00:39:34.728000','2018-08-28 00:39:34.728000',NULL),
	(330,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/we313ecb37dba45f599960437c86c59a\",\"updatedAt\":\"2018-08-28T00:22:56.088500+00:00\"}','2018-08-28 00:39:34.782800','2018-08-28 00:39:34.782800',NULL),
	(331,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/jf1833e8545654e0abdbd81b7a422d4b\",\"updatedAt\":\"2018-08-28T00:23:09.125596+00:00\"}','2018-08-28 00:39:34.829600','2018-08-28 00:39:34.829600',NULL),
	(332,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/jf1833e8545654e0abdbd81b7a422d4b\",\"updatedAt\":\"2018-08-28T00:23:09.125596+00:00\"}','2018-08-28 00:39:34.843900','2018-08-28 00:39:34.843900',NULL),
	(333,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/jf1833e8545654e0abdbd81b7a422d4b\",\"updatedAt\":\"2018-08-28T00:23:09.125596+00:00\"}','2018-08-28 00:39:34.858500','2018-08-28 00:39:34.858500',NULL),
	(334,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/jf1833e8545654e0abdbd81b7a422d4b\",\"updatedAt\":\"2018-08-28T00:23:09.125596+00:00\"}','2018-08-28 00:39:34.876100','2018-08-28 00:39:34.876100',NULL),
	(335,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/jf1833e8545654e0abdbd81b7a422d4b\",\"updatedAt\":\"2018-08-28T00:23:09.125596+00:00\"}','2018-08-28 00:39:34.893800','2018-08-28 00:39:34.893800',NULL),
	(336,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/jf1833e8545654e0abdbd81b7a422d4b\",\"updatedAt\":\"2018-08-28T00:23:09.125596+00:00\"}','2018-08-28 00:39:34.910100','2018-08-28 00:39:34.910100',NULL),
	(337,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/w8f15d0da416e44018a06451e4f2d64a\",\"updatedAt\":\"2018-08-28T00:23:43.965900+00:00\"}','2018-08-28 00:39:34.967500','2018-08-28 00:39:34.967500',NULL),
	(338,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/w8f15d0da416e44018a06451e4f2d64a\",\"updatedAt\":\"2018-08-28T00:23:43.965900+00:00\"}','2018-08-28 00:39:34.979700','2018-08-28 00:39:34.979700',NULL),
	(339,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/w8f15d0da416e44018a06451e4f2d64a\",\"updatedAt\":\"2018-08-28T00:23:43.965900+00:00\"}','2018-08-28 00:39:34.991300','2018-08-28 00:39:34.991300',NULL),
	(340,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/w8f15d0da416e44018a06451e4f2d64a\",\"updatedAt\":\"2018-08-28T00:23:43.965900+00:00\"}','2018-08-28 00:39:34.000000','2018-08-28 00:39:34.000000',NULL),
	(341,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/w8f15d0da416e44018a06451e4f2d64a\",\"updatedAt\":\"2018-08-28T00:23:43.965900+00:00\"}','2018-08-28 00:39:35.011400','2018-08-28 00:39:35.011400',NULL),
	(342,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/w8f15d0da416e44018a06451e4f2d64a\",\"updatedAt\":\"2018-08-28T00:23:43.965900+00:00\"}','2018-08-28 00:39:35.019200','2018-08-28 00:39:35.019200',NULL),
	(343,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/ff9c7c33fcb5d4d49b66cc8d2f9cdff6\",\"updatedAt\":\"2018-08-28T00:23:50.942000+00:00\"}','2018-08-28 00:39:35.081600','2018-08-28 00:39:35.081600',NULL),
	(344,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/ff9c7c33fcb5d4d49b66cc8d2f9cdff6\",\"updatedAt\":\"2018-08-28T00:23:50.942000+00:00\"}','2018-08-28 00:39:35.092600','2018-08-28 00:39:35.092600',NULL),
	(345,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/ff9c7c33fcb5d4d49b66cc8d2f9cdff6\",\"updatedAt\":\"2018-08-28T00:23:50.942000+00:00\"}','2018-08-28 00:39:35.103800','2018-08-28 00:39:35.103800',NULL),
	(346,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/ff9c7c33fcb5d4d49b66cc8d2f9cdff6\",\"updatedAt\":\"2018-08-28T00:23:50.942000+00:00\"}','2018-08-28 00:39:35.117700','2018-08-28 00:39:35.117700',NULL),
	(347,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/ff9c7c33fcb5d4d49b66cc8d2f9cdff6\",\"updatedAt\":\"2018-08-28T00:23:50.942000+00:00\"}','2018-08-28 00:39:35.128200','2018-08-28 00:39:35.128200',NULL),
	(348,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/ff9c7c33fcb5d4d49b66cc8d2f9cdff6\",\"updatedAt\":\"2018-08-28T00:23:50.942000+00:00\"}','2018-08-28 00:39:35.139000','2018-08-28 00:39:35.139000',NULL),
	(349,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/aece9a9845f6b47d481c171b95cba06e\",\"updatedAt\":\"2018-08-28T00:24:25.483000+00:00\"}','2018-08-28 00:39:35.183500','2018-08-28 00:39:35.183500',NULL),
	(350,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/aece9a9845f6b47d481c171b95cba06e\",\"updatedAt\":\"2018-08-28T00:24:25.483000+00:00\"}','2018-08-28 00:39:35.195800','2018-08-28 00:39:35.195800',NULL),
	(351,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/aece9a9845f6b47d481c171b95cba06e\",\"updatedAt\":\"2018-08-28T00:24:25.483000+00:00\"}','2018-08-28 00:39:35.211700','2018-08-28 00:39:35.211700',NULL),
	(352,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/aece9a9845f6b47d481c171b95cba06e\",\"updatedAt\":\"2018-08-28T00:24:25.483000+00:00\"}','2018-08-28 00:39:35.226000','2018-08-28 00:39:35.226000',NULL),
	(353,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/aece9a9845f6b47d481c171b95cba06e\",\"updatedAt\":\"2018-08-28T00:24:25.483000+00:00\"}','2018-08-28 00:39:35.238300','2018-08-28 00:39:35.238300',NULL),
	(354,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/aece9a9845f6b47d481c171b95cba06e\",\"updatedAt\":\"2018-08-28T00:24:25.483000+00:00\"}','2018-08-28 00:39:35.244100','2018-08-28 00:39:35.244100',NULL),
	(355,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/v4248ce55a97f46918d4e9a338b7d336\",\"updatedAt\":\"2018-08-28T00:24:28.206800+00:00\"}','2018-08-28 00:39:35.276600','2018-08-28 00:39:35.276600',NULL),
	(356,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/v4248ce55a97f46918d4e9a338b7d336\",\"updatedAt\":\"2018-08-28T00:24:28.206800+00:00\"}','2018-08-28 00:39:35.286800','2018-08-28 00:39:35.286800',NULL),
	(357,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/v4248ce55a97f46918d4e9a338b7d336\",\"updatedAt\":\"2018-08-28T00:24:28.206800+00:00\"}','2018-08-28 00:39:35.293100','2018-08-28 00:39:35.293100',NULL),
	(358,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/v4248ce55a97f46918d4e9a338b7d336\",\"updatedAt\":\"2018-08-28T00:24:28.206800+00:00\"}','2018-08-28 00:39:35.300400','2018-08-28 00:39:35.300400',NULL),
	(359,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/v4248ce55a97f46918d4e9a338b7d336\",\"updatedAt\":\"2018-08-28T00:24:28.206800+00:00\"}','2018-08-28 00:39:35.306900','2018-08-28 00:39:35.306900',NULL),
	(360,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/v4248ce55a97f46918d4e9a338b7d336\",\"updatedAt\":\"2018-08-28T00:24:28.206800+00:00\"}','2018-08-28 00:39:35.327100','2018-08-28 00:39:35.327100',NULL),
	(361,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/fb3acf4cd02b44e23b0f931dd2547e72\",\"updatedAt\":\"2018-08-28T00:24:29.826900+00:00\"}','2018-08-28 00:39:35.361400','2018-08-28 00:39:35.361400',NULL),
	(362,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/fb3acf4cd02b44e23b0f931dd2547e72\",\"updatedAt\":\"2018-08-28T00:24:29.826900+00:00\"}','2018-08-28 00:39:35.371700','2018-08-28 00:39:35.371700',NULL),
	(363,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/fb3acf4cd02b44e23b0f931dd2547e72\",\"updatedAt\":\"2018-08-28T00:24:29.826900+00:00\"}','2018-08-28 00:39:35.380500','2018-08-28 00:39:35.380500',NULL),
	(364,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/fb3acf4cd02b44e23b0f931dd2547e72\",\"updatedAt\":\"2018-08-28T00:24:29.826900+00:00\"}','2018-08-28 00:39:35.393800','2018-08-28 00:39:35.393800',NULL),
	(365,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/fb3acf4cd02b44e23b0f931dd2547e72\",\"updatedAt\":\"2018-08-28T00:24:29.826900+00:00\"}','2018-08-28 00:39:35.405700','2018-08-28 00:39:35.405700',NULL),
	(366,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/fb3acf4cd02b44e23b0f931dd2547e72\",\"updatedAt\":\"2018-08-28T00:24:29.826900+00:00\"}','2018-08-28 00:39:35.417700','2018-08-28 00:39:35.417700',NULL),
	(367,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/m6811f0cfd7294d6bbe57d7eb74eac50\",\"updatedAt\":\"2018-08-28T00:24:32.285200+00:00\"}','2018-08-28 00:39:35.464500','2018-08-28 00:39:35.464500',NULL),
	(368,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/m6811f0cfd7294d6bbe57d7eb74eac50\",\"updatedAt\":\"2018-08-28T00:24:32.285200+00:00\"}','2018-08-28 00:39:35.476800','2018-08-28 00:39:35.476800',NULL),
	(369,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/m6811f0cfd7294d6bbe57d7eb74eac50\",\"updatedAt\":\"2018-08-28T00:24:32.285200+00:00\"}','2018-08-28 00:39:35.486000','2018-08-28 00:39:35.486000',NULL),
	(370,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/m6811f0cfd7294d6bbe57d7eb74eac50\",\"updatedAt\":\"2018-08-28T00:24:32.285200+00:00\"}','2018-08-28 00:39:35.495400','2018-08-28 00:39:35.495400',NULL),
	(371,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/m6811f0cfd7294d6bbe57d7eb74eac50\",\"updatedAt\":\"2018-08-28T00:24:32.285200+00:00\"}','2018-08-28 00:39:35.503600','2018-08-28 00:39:35.503600',NULL),
	(372,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/m6811f0cfd7294d6bbe57d7eb74eac50\",\"updatedAt\":\"2018-08-28T00:24:32.285200+00:00\"}','2018-08-28 00:39:35.511200','2018-08-28 00:39:35.511200',NULL),
	(373,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/oba9021da33144e3aa35ea346c95a083\",\"updatedAt\":\"2018-08-28T00:24:44.315100+00:00\"}','2018-08-28 00:39:35.557600','2018-08-28 00:39:35.557600',NULL),
	(374,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/oba9021da33144e3aa35ea346c95a083\",\"updatedAt\":\"2018-08-28T00:24:44.315100+00:00\"}','2018-08-28 00:39:35.568700','2018-08-28 00:39:35.568700',NULL),
	(375,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/oba9021da33144e3aa35ea346c95a083\",\"updatedAt\":\"2018-08-28T00:24:44.315100+00:00\"}','2018-08-28 00:39:35.579900','2018-08-28 00:39:35.579900',NULL),
	(376,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/oba9021da33144e3aa35ea346c95a083\",\"updatedAt\":\"2018-08-28T00:24:44.315100+00:00\"}','2018-08-28 00:39:35.591400','2018-08-28 00:39:35.591400',NULL),
	(377,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/oba9021da33144e3aa35ea346c95a083\",\"updatedAt\":\"2018-08-28T00:24:44.315100+00:00\"}','2018-08-28 00:39:35.600500','2018-08-28 00:39:35.600500',NULL),
	(378,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/oba9021da33144e3aa35ea346c95a083\",\"updatedAt\":\"2018-08-28T00:24:44.315100+00:00\"}','2018-08-28 00:39:35.605000','2018-08-28 00:39:35.605000',NULL),
	(379,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/re1ac9f174d0c4febb2d48e4075ce4cf\",\"updatedAt\":\"2018-08-28T00:25:20.376000+00:00\"}','2018-08-28 00:39:35.628100','2018-08-28 00:39:35.628100',NULL),
	(380,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/re1ac9f174d0c4febb2d48e4075ce4cf\",\"updatedAt\":\"2018-08-28T00:25:20.376000+00:00\"}','2018-08-28 00:39:35.636900','2018-08-28 00:39:35.636900',NULL),
	(381,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/re1ac9f174d0c4febb2d48e4075ce4cf\",\"updatedAt\":\"2018-08-28T00:25:20.376000+00:00\"}','2018-08-28 00:39:35.652900','2018-08-28 00:39:35.652900',NULL),
	(382,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/re1ac9f174d0c4febb2d48e4075ce4cf\",\"updatedAt\":\"2018-08-28T00:25:20.376000+00:00\"}','2018-08-28 00:39:35.664800','2018-08-28 00:39:35.664800',NULL),
	(383,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/re1ac9f174d0c4febb2d48e4075ce4cf\",\"updatedAt\":\"2018-08-28T00:25:20.376000+00:00\"}','2018-08-28 00:39:35.678000','2018-08-28 00:39:35.678000',NULL),
	(384,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/re1ac9f174d0c4febb2d48e4075ce4cf\",\"updatedAt\":\"2018-08-28T00:25:20.376000+00:00\"}','2018-08-28 00:39:35.690800','2018-08-28 00:39:35.690800',NULL),
	(385,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/s16f0d5641c1749e38f2530f246d9589\",\"updatedAt\":\"2018-08-28T00:25:23.503399+00:00\"}','2018-08-28 00:39:35.757700','2018-08-28 00:39:35.757700',NULL),
	(386,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/s16f0d5641c1749e38f2530f246d9589\",\"updatedAt\":\"2018-08-28T00:25:23.503399+00:00\"}','2018-08-28 00:39:35.777700','2018-08-28 00:39:35.777700',NULL),
	(387,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/s16f0d5641c1749e38f2530f246d9589\",\"updatedAt\":\"2018-08-28T00:25:23.503399+00:00\"}','2018-08-28 00:39:35.833900','2018-08-28 00:39:35.833900',NULL),
	(388,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/s16f0d5641c1749e38f2530f246d9589\",\"updatedAt\":\"2018-08-28T00:25:23.503399+00:00\"}','2018-08-28 00:39:35.879900','2018-08-28 00:39:35.879900',NULL),
	(389,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/s16f0d5641c1749e38f2530f246d9589\",\"updatedAt\":\"2018-08-28T00:25:23.503399+00:00\"}','2018-08-28 00:39:35.886300','2018-08-28 00:39:35.886300',NULL),
	(390,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/s16f0d5641c1749e38f2530f246d9589\",\"updatedAt\":\"2018-08-28T00:25:23.503399+00:00\"}','2018-08-28 00:39:35.891200','2018-08-28 00:39:35.891200',NULL),
	(391,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/d12c3122259d746978548c90418301df\",\"updatedAt\":\"2018-08-28T00:25:26.572900+00:00\"}','2018-08-28 00:39:35.916900','2018-08-28 00:39:35.916900',NULL),
	(392,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/d12c3122259d746978548c90418301df\",\"updatedAt\":\"2018-08-28T00:25:26.572900+00:00\"}','2018-08-28 00:39:35.924300','2018-08-28 00:39:35.924300',NULL),
	(393,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/d12c3122259d746978548c90418301df\",\"updatedAt\":\"2018-08-28T00:25:26.572900+00:00\"}','2018-08-28 00:39:35.933600','2018-08-28 00:39:35.933600',NULL),
	(394,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/d12c3122259d746978548c90418301df\",\"updatedAt\":\"2018-08-28T00:25:26.572900+00:00\"}','2018-08-28 00:39:35.945200','2018-08-28 00:39:35.945200',NULL),
	(395,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/d12c3122259d746978548c90418301df\",\"updatedAt\":\"2018-08-28T00:25:26.572900+00:00\"}','2018-08-28 00:39:35.952600','2018-08-28 00:39:35.952600',NULL),
	(396,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/d12c3122259d746978548c90418301df\",\"updatedAt\":\"2018-08-28T00:25:26.572900+00:00\"}','2018-08-28 00:39:35.958900','2018-08-28 00:39:35.958900',NULL),
	(397,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/sf822f7043fd3412cb1c32b818ac8258\",\"updatedAt\":\"2018-08-28T00:25:35.906600+00:00\"}','2018-08-28 00:39:35.984100','2018-08-28 00:39:35.984100',NULL),
	(398,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/sf822f7043fd3412cb1c32b818ac8258\",\"updatedAt\":\"2018-08-28T00:25:35.906600+00:00\"}','2018-08-28 00:39:35.989300','2018-08-28 00:39:35.989300',NULL),
	(399,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/sf822f7043fd3412cb1c32b818ac8258\",\"updatedAt\":\"2018-08-28T00:25:35.906600+00:00\"}','2018-08-28 00:39:35.994500','2018-08-28 00:39:35.994500',NULL),
	(400,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/sf822f7043fd3412cb1c32b818ac8258\",\"updatedAt\":\"2018-08-28T00:25:35.906600+00:00\"}','2018-08-28 00:39:35.000000','2018-08-28 00:39:35.000000',NULL),
	(401,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/sf822f7043fd3412cb1c32b818ac8258\",\"updatedAt\":\"2018-08-28T00:25:35.906600+00:00\"}','2018-08-28 00:39:36.007800','2018-08-28 00:39:36.007800',NULL),
	(402,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/sf822f7043fd3412cb1c32b818ac8258\",\"updatedAt\":\"2018-08-28T00:25:35.906600+00:00\"}','2018-08-28 00:39:36.016200','2018-08-28 00:39:36.016200',NULL),
	(403,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/k65fbc2e78d884ff8bed9cd133115b8c\",\"updatedAt\":\"2018-08-28T00:26:12.729800+00:00\"}','2018-08-28 00:39:36.048500','2018-08-28 00:39:36.048500',NULL),
	(404,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/k65fbc2e78d884ff8bed9cd133115b8c\",\"updatedAt\":\"2018-08-28T00:26:12.729800+00:00\"}','2018-08-28 00:39:36.054000','2018-08-28 00:39:36.054000',NULL),
	(405,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/k65fbc2e78d884ff8bed9cd133115b8c\",\"updatedAt\":\"2018-08-28T00:26:12.729800+00:00\"}','2018-08-28 00:39:36.062700','2018-08-28 00:39:36.062700',NULL),
	(406,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/k65fbc2e78d884ff8bed9cd133115b8c\",\"updatedAt\":\"2018-08-28T00:26:12.729800+00:00\"}','2018-08-28 00:39:36.078100','2018-08-28 00:39:36.078100',NULL),
	(407,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/k65fbc2e78d884ff8bed9cd133115b8c\",\"updatedAt\":\"2018-08-28T00:26:12.729800+00:00\"}','2018-08-28 00:39:36.090500','2018-08-28 00:39:36.090500',NULL),
	(408,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/k65fbc2e78d884ff8bed9cd133115b8c\",\"updatedAt\":\"2018-08-28T00:26:12.729800+00:00\"}','2018-08-28 00:39:36.106500','2018-08-28 00:39:36.106500',NULL),
	(409,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/ve75e4fd429ff4f0e89b77edbca60f74\",\"updatedAt\":\"2018-08-28T00:26:19.087200+00:00\"}','2018-08-28 00:39:36.158300','2018-08-28 00:39:36.158300',NULL),
	(410,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/ve75e4fd429ff4f0e89b77edbca60f74\",\"updatedAt\":\"2018-08-28T00:26:19.087200+00:00\"}','2018-08-28 00:39:36.166100','2018-08-28 00:39:36.166100',NULL),
	(411,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/ve75e4fd429ff4f0e89b77edbca60f74\",\"updatedAt\":\"2018-08-28T00:26:19.087200+00:00\"}','2018-08-28 00:39:36.174500','2018-08-28 00:39:36.174500',NULL),
	(412,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/ve75e4fd429ff4f0e89b77edbca60f74\",\"updatedAt\":\"2018-08-28T00:26:19.087200+00:00\"}','2018-08-28 00:39:36.185700','2018-08-28 00:39:36.185700',NULL),
	(413,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/ve75e4fd429ff4f0e89b77edbca60f74\",\"updatedAt\":\"2018-08-28T00:26:19.087200+00:00\"}','2018-08-28 00:39:36.195600','2018-08-28 00:39:36.195600',NULL),
	(414,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/ve75e4fd429ff4f0e89b77edbca60f74\",\"updatedAt\":\"2018-08-28T00:26:19.087200+00:00\"}','2018-08-28 00:39:36.207000','2018-08-28 00:39:36.207000',NULL),
	(415,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/u305eee9ec87e47c596b5da8bff38131\",\"updatedAt\":\"2018-08-28T00:26:20.095500+00:00\"}','2018-08-28 00:39:36.264500','2018-08-28 00:39:36.264500',NULL),
	(416,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/u305eee9ec87e47c596b5da8bff38131\",\"updatedAt\":\"2018-08-28T00:26:20.095500+00:00\"}','2018-08-28 00:39:36.275200','2018-08-28 00:39:36.275200',NULL),
	(417,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/u305eee9ec87e47c596b5da8bff38131\",\"updatedAt\":\"2018-08-28T00:26:20.095500+00:00\"}','2018-08-28 00:39:36.285900','2018-08-28 00:39:36.285900',NULL),
	(418,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/u305eee9ec87e47c596b5da8bff38131\",\"updatedAt\":\"2018-08-28T00:26:20.095500+00:00\"}','2018-08-28 00:39:36.298300','2018-08-28 00:39:36.298300',NULL),
	(419,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/u305eee9ec87e47c596b5da8bff38131\",\"updatedAt\":\"2018-08-28T00:26:20.095500+00:00\"}','2018-08-28 00:39:36.311500','2018-08-28 00:39:36.311500',NULL),
	(420,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/u305eee9ec87e47c596b5da8bff38131\",\"updatedAt\":\"2018-08-28T00:26:20.095500+00:00\"}','2018-08-28 00:39:36.321700','2018-08-28 00:39:36.321700',NULL),
	(421,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/t937f86900159428eb470f6b13be8d09\",\"updatedAt\":\"2018-08-28T00:26:30.262700+00:00\"}','2018-08-28 00:39:36.371200','2018-08-28 00:39:36.371200',NULL),
	(422,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/t937f86900159428eb470f6b13be8d09\",\"updatedAt\":\"2018-08-28T00:26:30.262700+00:00\"}','2018-08-28 00:39:36.385200','2018-08-28 00:39:36.385200',NULL),
	(423,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/t937f86900159428eb470f6b13be8d09\",\"updatedAt\":\"2018-08-28T00:26:30.262700+00:00\"}','2018-08-28 00:39:36.397900','2018-08-28 00:39:36.397900',NULL),
	(424,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/t937f86900159428eb470f6b13be8d09\",\"updatedAt\":\"2018-08-28T00:26:30.262700+00:00\"}','2018-08-28 00:39:36.411000','2018-08-28 00:39:36.411000',NULL),
	(425,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/t937f86900159428eb470f6b13be8d09\",\"updatedAt\":\"2018-08-28T00:26:30.262700+00:00\"}','2018-08-28 00:39:36.421200','2018-08-28 00:39:36.421200',NULL),
	(426,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/t937f86900159428eb470f6b13be8d09\",\"updatedAt\":\"2018-08-28T00:26:30.262700+00:00\"}','2018-08-28 00:39:36.430300','2018-08-28 00:39:36.430300',NULL),
	(427,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/zb0f9f713f87c4daf995245fbe004f92\",\"updatedAt\":\"2018-08-28T00:27:35.711900+00:00\"}','2018-08-28 00:39:36.467100','2018-08-28 00:39:36.467100',NULL),
	(428,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/zb0f9f713f87c4daf995245fbe004f92\",\"updatedAt\":\"2018-08-28T00:27:35.711900+00:00\"}','2018-08-28 00:39:36.473000','2018-08-28 00:39:36.473000',NULL),
	(429,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/zb0f9f713f87c4daf995245fbe004f92\",\"updatedAt\":\"2018-08-28T00:27:35.711900+00:00\"}','2018-08-28 00:39:36.481300','2018-08-28 00:39:36.481300',NULL),
	(430,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/zb0f9f713f87c4daf995245fbe004f92\",\"updatedAt\":\"2018-08-28T00:27:35.711900+00:00\"}','2018-08-28 00:39:36.491600','2018-08-28 00:39:36.491600',NULL),
	(431,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/zb0f9f713f87c4daf995245fbe004f92\",\"updatedAt\":\"2018-08-28T00:27:35.711900+00:00\"}','2018-08-28 00:39:36.497500','2018-08-28 00:39:36.497500',NULL),
	(432,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/zb0f9f713f87c4daf995245fbe004f92\",\"updatedAt\":\"2018-08-28T00:27:35.711900+00:00\"}','2018-08-28 00:39:36.505300','2018-08-28 00:39:36.505300',NULL),
	(433,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/c0c0908f08fb24edaa443172b7d8ff10\",\"updatedAt\":\"2018-08-28T00:35:09.211300+00:00\"}','2018-08-28 00:39:36.533100','2018-08-28 00:39:36.533100',NULL),
	(434,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/c0c0908f08fb24edaa443172b7d8ff10\",\"updatedAt\":\"2018-08-28T00:35:09.211300+00:00\"}','2018-08-28 00:39:36.540400','2018-08-28 00:39:36.540400',NULL),
	(435,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/c0c0908f08fb24edaa443172b7d8ff10\",\"updatedAt\":\"2018-08-28T00:35:09.211300+00:00\"}','2018-08-28 00:39:36.549600','2018-08-28 00:39:36.549600',NULL),
	(436,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/c0c0908f08fb24edaa443172b7d8ff10\",\"updatedAt\":\"2018-08-28T00:35:09.211300+00:00\"}','2018-08-28 00:39:36.563900','2018-08-28 00:39:36.563900',NULL),
	(437,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/c0c0908f08fb24edaa443172b7d8ff10\",\"updatedAt\":\"2018-08-28T00:35:09.211300+00:00\"}','2018-08-28 00:39:36.574300','2018-08-28 00:39:36.574300',NULL),
	(438,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/c0c0908f08fb24edaa443172b7d8ff10\",\"updatedAt\":\"2018-08-28T00:35:09.211300+00:00\"}','2018-08-28 00:39:36.579800','2018-08-28 00:39:36.579800',NULL),
	(439,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/c0c0908f08fb24edaa443172b7d8ff10\",\"updatedAt\":\"2018-08-28T00:35:09.211300+00:00\"}','2018-08-28 00:39:36.643100','2018-08-28 00:39:36.643100',NULL),
	(440,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/c0c0908f08fb24edaa443172b7d8ff10\",\"updatedAt\":\"2018-08-28T00:35:09.211300+00:00\"}','2018-08-28 00:39:36.656800','2018-08-28 00:39:36.656800',NULL),
	(441,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/c0c0908f08fb24edaa443172b7d8ff10\",\"updatedAt\":\"2018-08-28T00:35:09.211300+00:00\"}','2018-08-28 00:39:36.669100','2018-08-28 00:39:36.669100',NULL),
	(442,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/c0c0908f08fb24edaa443172b7d8ff10\",\"updatedAt\":\"2018-08-28T00:35:09.211300+00:00\"}','2018-08-28 00:39:36.684700','2018-08-28 00:39:36.684700',NULL),
	(443,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/c0c0908f08fb24edaa443172b7d8ff10\",\"updatedAt\":\"2018-08-28T00:35:09.211300+00:00\"}','2018-08-28 00:39:36.692200','2018-08-28 00:39:36.692200',NULL),
	(444,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/c0c0908f08fb24edaa443172b7d8ff10\",\"updatedAt\":\"2018-08-28T00:35:09.211300+00:00\"}','2018-08-28 00:39:36.700000','2018-08-28 00:39:36.700000',NULL),
	(445,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/hc16cc4a29bdf4ed79838367aa4b5aec\",\"updatedAt\":\"2018-08-28T00:29:11.033200+00:00\"}','2018-08-28 00:39:36.755100','2018-08-28 00:39:36.755100',NULL),
	(446,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/hc16cc4a29bdf4ed79838367aa4b5aec\",\"updatedAt\":\"2018-08-28T00:29:11.033200+00:00\"}','2018-08-28 00:39:36.765900','2018-08-28 00:39:36.765900',NULL),
	(447,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/hc16cc4a29bdf4ed79838367aa4b5aec\",\"updatedAt\":\"2018-08-28T00:29:11.033200+00:00\"}','2018-08-28 00:39:36.779000','2018-08-28 00:39:36.779000',NULL),
	(448,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/hc16cc4a29bdf4ed79838367aa4b5aec\",\"updatedAt\":\"2018-08-28T00:29:11.033200+00:00\"}','2018-08-28 00:39:36.792600','2018-08-28 00:39:36.792600',NULL),
	(449,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/hc16cc4a29bdf4ed79838367aa4b5aec\",\"updatedAt\":\"2018-08-28T00:29:11.033200+00:00\"}','2018-08-28 00:39:36.805700','2018-08-28 00:39:36.805700',NULL),
	(450,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/hc16cc4a29bdf4ed79838367aa4b5aec\",\"updatedAt\":\"2018-08-28T00:29:11.033200+00:00\"}','2018-08-28 00:39:36.811400','2018-08-28 00:39:36.811400',NULL),
	(451,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/hc16cc4a29bdf4ed79838367aa4b5aec\",\"updatedAt\":\"2018-08-28T00:29:11.033200+00:00\"}','2018-08-28 00:39:36.871800','2018-08-28 00:39:36.871800',NULL),
	(452,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/hc16cc4a29bdf4ed79838367aa4b5aec\",\"updatedAt\":\"2018-08-28T00:29:11.033200+00:00\"}','2018-08-28 00:39:36.883900','2018-08-28 00:39:36.883900',NULL),
	(453,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/hc16cc4a29bdf4ed79838367aa4b5aec\",\"updatedAt\":\"2018-08-28T00:29:11.033200+00:00\"}','2018-08-28 00:39:36.893300','2018-08-28 00:39:36.893300',NULL),
	(454,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/hc16cc4a29bdf4ed79838367aa4b5aec\",\"updatedAt\":\"2018-08-28T00:29:11.033200+00:00\"}','2018-08-28 00:39:36.910400','2018-08-28 00:39:36.910400',NULL),
	(455,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/hc16cc4a29bdf4ed79838367aa4b5aec\",\"updatedAt\":\"2018-08-28T00:29:11.033200+00:00\"}','2018-08-28 00:39:36.922000','2018-08-28 00:39:36.922000',NULL),
	(456,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/comments\\/hc16cc4a29bdf4ed79838367aa4b5aec\",\"updatedAt\":\"2018-08-28T00:29:11.033200+00:00\"}','2018-08-28 00:39:36.936100','2018-08-28 00:39:36.936100',NULL),
	(457,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/e89718922b5da4afb894199de6f90968\",\"updatedAt\":\"2018-08-28T00:37:04.750100+00:00\"}','2018-08-28 00:39:36.978700','2018-08-28 00:39:36.978700',NULL),
	(458,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/e89718922b5da4afb894199de6f90968\",\"updatedAt\":\"2018-08-28T00:37:04.750100+00:00\"}','2018-08-28 00:39:36.989500','2018-08-28 00:39:36.989500',NULL),
	(459,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/e89718922b5da4afb894199de6f90968\",\"updatedAt\":\"2018-08-28T00:37:04.750100+00:00\"}','2018-08-28 00:39:36.996800','2018-08-28 00:39:36.996800',NULL),
	(460,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/e89718922b5da4afb894199de6f90968\",\"updatedAt\":\"2018-08-28T00:37:04.750100+00:00\"}','2018-08-28 00:39:37.014200','2018-08-28 00:39:37.014200',NULL),
	(461,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/e89718922b5da4afb894199de6f90968\",\"updatedAt\":\"2018-08-28T00:37:04.750100+00:00\"}','2018-08-28 00:39:37.044400','2018-08-28 00:39:37.044400',NULL),
	(462,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/e89718922b5da4afb894199de6f90968\",\"updatedAt\":\"2018-08-28T00:37:04.750100+00:00\"}','2018-08-28 00:39:37.067700','2018-08-28 00:39:37.067700',NULL),
	(463,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/lb3091d6f103d46e4bdd565a6f530e7a\",\"updatedAt\":\"2018-08-28T00:37:00.389800+00:00\"}','2018-08-28 00:39:37.130897','2018-08-28 00:39:37.130897',NULL),
	(464,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/lb3091d6f103d46e4bdd565a6f530e7a\",\"updatedAt\":\"2018-08-28T00:37:00.389800+00:00\"}','2018-08-28 00:39:37.143500','2018-08-28 00:39:37.143500',NULL),
	(465,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/lb3091d6f103d46e4bdd565a6f530e7a\",\"updatedAt\":\"2018-08-28T00:37:00.389800+00:00\"}','2018-08-28 00:39:37.148800','2018-08-28 00:39:37.148800',NULL),
	(466,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/lb3091d6f103d46e4bdd565a6f530e7a\",\"updatedAt\":\"2018-08-28T00:37:00.389800+00:00\"}','2018-08-28 00:39:37.161100','2018-08-28 00:39:37.161100',NULL),
	(467,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/lb3091d6f103d46e4bdd565a6f530e7a\",\"updatedAt\":\"2018-08-28T00:37:00.389800+00:00\"}','2018-08-28 00:39:37.174100','2018-08-28 00:39:37.174100',NULL),
	(468,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/lb3091d6f103d46e4bdd565a6f530e7a\",\"updatedAt\":\"2018-08-28T00:37:00.389800+00:00\"}','2018-08-28 00:39:37.193200','2018-08-28 00:39:37.193200',NULL),
	(469,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/p760b01cadbab4b61a9355b58b0299e4\",\"updatedAt\":\"2018-08-28T00:35:09.161100+00:00\"}','2018-08-28 00:39:37.321000','2018-08-28 00:39:37.321000',NULL),
	(470,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/p760b01cadbab4b61a9355b58b0299e4\",\"updatedAt\":\"2018-08-28T00:35:09.161100+00:00\"}','2018-08-28 00:39:37.339400','2018-08-28 00:39:37.339400',NULL),
	(471,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/p760b01cadbab4b61a9355b58b0299e4\",\"updatedAt\":\"2018-08-28T00:35:09.161100+00:00\"}','2018-08-28 00:39:37.354400','2018-08-28 00:39:37.354400',NULL),
	(472,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/p760b01cadbab4b61a9355b58b0299e4\",\"updatedAt\":\"2018-08-28T00:35:09.161100+00:00\"}','2018-08-28 00:39:37.360800','2018-08-28 00:39:37.360800',NULL),
	(473,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/p760b01cadbab4b61a9355b58b0299e4\",\"updatedAt\":\"2018-08-28T00:35:09.161100+00:00\"}','2018-08-28 00:39:37.397000','2018-08-28 00:39:37.397000',NULL),
	(474,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/p760b01cadbab4b61a9355b58b0299e4\",\"updatedAt\":\"2018-08-28T00:35:09.161100+00:00\"}','2018-08-28 00:39:37.428900','2018-08-28 00:39:37.428900',NULL),
	(475,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/le4acf50aaacc4d86a8ad041040cfa3d\",\"updatedAt\":\"2018-08-28T00:35:19.588900+00:00\"}','2018-08-28 00:39:37.474800','2018-08-28 00:39:37.474800',NULL),
	(476,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/le4acf50aaacc4d86a8ad041040cfa3d\",\"updatedAt\":\"2018-08-28T00:35:19.588900+00:00\"}','2018-08-28 00:39:37.482000','2018-08-28 00:39:37.482000',NULL),
	(477,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/h9dd69f4d0f374a988c721ce9b7b4427\",\"updatedAt\":\"2018-08-28T00:31:37.050100+00:00\"}','2018-08-28 00:39:37.522599','2018-08-28 00:39:37.522599',NULL),
	(478,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/h9dd69f4d0f374a988c721ce9b7b4427\",\"updatedAt\":\"2018-08-28T00:31:37.050100+00:00\"}','2018-08-28 00:39:37.530700','2018-08-28 00:39:37.530700',NULL),
	(479,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/t0b78731421654b3fa51ad176e3595e4\",\"updatedAt\":\"2018-08-28T00:31:37.063297+00:00\"}','2018-08-28 00:39:37.563000','2018-08-28 00:39:37.563000',NULL),
	(480,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/t0b78731421654b3fa51ad176e3595e4\",\"updatedAt\":\"2018-08-28T00:31:37.063297+00:00\"}','2018-08-28 00:39:37.571800','2018-08-28 00:39:37.571800',NULL),
	(481,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/p9c0b53a782d14343a0f8b807b750310\",\"updatedAt\":\"2018-08-28T00:31:37.067900+00:00\"}','2018-08-28 00:39:37.602200','2018-08-28 00:39:37.602200',NULL),
	(482,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/p9c0b53a782d14343a0f8b807b750310\",\"updatedAt\":\"2018-08-28T00:31:37.067900+00:00\"}','2018-08-28 00:39:37.612400','2018-08-28 00:39:37.612400',NULL),
	(483,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/ba577b1d62d4c4c0aac86e3bea5572e6\",\"updatedAt\":\"2018-08-28T00:31:37.073100+00:00\"}','2018-08-28 00:39:37.641500','2018-08-28 00:39:37.641500',NULL),
	(484,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/ba577b1d62d4c4c0aac86e3bea5572e6\",\"updatedAt\":\"2018-08-28T00:31:37.073100+00:00\"}','2018-08-28 00:39:37.664700','2018-08-28 00:39:37.664700',NULL),
	(485,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:37.696400','2018-08-28 00:39:37.696400',NULL),
	(486,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:37.714900','2018-08-28 00:39:37.714900',NULL),
	(487,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/s5802ee9570f642b28342df283d297af\",\"updatedAt\":\"2018-08-28T00:35:28.552600+00:00\"}','2018-08-28 00:39:37.763900','2018-08-28 00:39:37.763900',NULL),
	(488,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/k6070cceae4dd487c8ccbf97ac266c4a\",\"updatedAt\":\"2018-08-28T00:32:17.777800+00:00\"}','2018-08-28 00:39:37.807100','2018-08-28 00:39:37.807100',NULL),
	(489,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/x1e7bb8906106448f8c310cd19a05aa4\",\"updatedAt\":\"2018-08-28T00:32:17.797900+00:00\"}','2018-08-28 00:39:37.837900','2018-08-28 00:39:37.837900',NULL),
	(490,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/s0b455be6df484204ba56cfc9ad68cca\",\"updatedAt\":\"2018-08-28T00:32:17.802000+00:00\"}','2018-08-28 00:39:37.894200','2018-08-28 00:39:37.894200',NULL),
	(491,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/idc8a7cbf118a41d8af1ca4af4fda1cb\",\"updatedAt\":\"2018-08-28T00:32:17.806300+00:00\"}','2018-08-28 00:39:37.962500','2018-08-28 00:39:37.962500',NULL),
	(492,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/s5802ee9570f642b28342df283d297af\",\"updatedAt\":\"2018-08-28T00:35:28.552600+00:00\"}','2018-08-28 00:39:37.989400','2018-08-28 00:39:37.989400',NULL),
	(493,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/obd58aaaf121440c8afa9b47d25522af\",\"updatedAt\":\"2018-08-28T00:35:29.227700+00:00\"}','2018-08-28 00:39:38.023600','2018-08-28 00:39:38.023600',NULL),
	(494,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/d4f7a84149dff4e92a9180d8d97bdd1c\",\"updatedAt\":\"2018-08-28T00:35:38.262000+00:00\"}','2018-08-28 00:39:38.059700','2018-08-28 00:39:38.059700',NULL),
	(495,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/f1e675f1084df446f8f7a1344c6fbf30\",\"updatedAt\":\"2018-08-28T00:33:06.276200+00:00\"}','2018-08-28 00:39:38.079100','2018-08-28 00:39:38.079100',NULL),
	(496,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/e50df2b1949cf40af859f69b12352c47\",\"updatedAt\":\"2018-08-28T00:33:06.294000+00:00\"}','2018-08-28 00:39:38.108100','2018-08-28 00:39:38.108100',NULL),
	(497,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/w20b91ea07ab04205b22718aae7aab2c\",\"updatedAt\":\"2018-08-28T00:33:06.298800+00:00\"}','2018-08-28 00:39:38.140700','2018-08-28 00:39:38.140700',NULL),
	(498,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/categories\\/x6b36728ae84d480b88f5b23de0684e2\",\"updatedAt\":\"2018-08-28T00:33:06.305200+00:00\"}','2018-08-28 00:39:38.185300','2018-08-28 00:39:38.185300',NULL),
	(499,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/yb1f56e05de0b4d0fa9947708cafb791\",\"updatedAt\":\"2018-08-28T00:35:44.707700+00:00\"}','2018-08-28 00:39:38.247300','2018-08-28 00:39:38.247300',NULL),
	(500,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/h8c1d469106224e308f0704c03ab98ac\",\"updatedAt\":\"2018-08-28T00:34:24.713100+00:00\"}','2018-08-28 00:39:38.280800','2018-08-28 00:39:38.280800',NULL),
	(501,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/h8c1d469106224e308f0704c03ab98ac\",\"updatedAt\":\"2018-08-28T00:34:24.713100+00:00\"}','2018-08-28 00:39:38.292700','2018-08-28 00:39:38.292700',NULL),
	(502,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/p760b01cadbab4b61a9355b58b0299e4\",\"updatedAt\":\"2018-08-28T00:35:09.161100+00:00\"}','2018-08-28 00:39:38.329200','2018-08-28 00:39:38.329200',NULL),
	(503,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/p760b01cadbab4b61a9355b58b0299e4\",\"updatedAt\":\"2018-08-28T00:35:09.161100+00:00\"}','2018-08-28 00:39:38.341100','2018-08-28 00:39:38.341100',NULL),
	(504,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/p760b01cadbab4b61a9355b58b0299e4\",\"updatedAt\":\"2018-08-28T00:35:09.161100+00:00\"}','2018-08-28 00:39:38.352600','2018-08-28 00:39:38.352600',NULL),
	(505,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/p760b01cadbab4b61a9355b58b0299e4\",\"updatedAt\":\"2018-08-28T00:35:09.161100+00:00\"}','2018-08-28 00:39:38.384400','2018-08-28 00:39:38.384400',NULL),
	(506,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/p760b01cadbab4b61a9355b58b0299e4\",\"updatedAt\":\"2018-08-28T00:35:09.161100+00:00\"}','2018-08-28 00:39:38.408700','2018-08-28 00:39:38.408700',NULL),
	(507,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/p760b01cadbab4b61a9355b58b0299e4\",\"updatedAt\":\"2018-08-28T00:35:09.161100+00:00\"}','2018-08-28 00:39:38.420100','2018-08-28 00:39:38.420100',NULL),
	(508,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/c0c0908f08fb24edaa443172b7d8ff10\",\"updatedAt\":\"2018-08-28T00:35:09.211300+00:00\"}','2018-08-28 00:39:38.458700','2018-08-28 00:39:38.458700',NULL),
	(509,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/c0c0908f08fb24edaa443172b7d8ff10\",\"updatedAt\":\"2018-08-28T00:35:09.211300+00:00\"}','2018-08-28 00:39:38.468500','2018-08-28 00:39:38.468500',NULL),
	(510,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/c0c0908f08fb24edaa443172b7d8ff10\",\"updatedAt\":\"2018-08-28T00:35:09.211300+00:00\"}','2018-08-28 00:39:38.491400','2018-08-28 00:39:38.491400',NULL),
	(511,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/c0c0908f08fb24edaa443172b7d8ff10\",\"updatedAt\":\"2018-08-28T00:35:09.211300+00:00\"}','2018-08-28 00:39:38.511300','2018-08-28 00:39:38.511300',NULL),
	(512,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/c0c0908f08fb24edaa443172b7d8ff10\",\"updatedAt\":\"2018-08-28T00:35:09.211300+00:00\"}','2018-08-28 00:39:38.533700','2018-08-28 00:39:38.533700',NULL),
	(513,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/c0c0908f08fb24edaa443172b7d8ff10\",\"updatedAt\":\"2018-08-28T00:35:09.211300+00:00\"}','2018-08-28 00:39:38.561600','2018-08-28 00:39:38.561600',NULL),
	(514,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:38.643900','2018-08-28 00:39:38.643900',NULL),
	(515,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:38.660300','2018-08-28 00:39:38.660300',NULL),
	(516,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:38.712400','2018-08-28 00:39:38.712400',NULL),
	(517,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:38.734300','2018-08-28 00:39:38.734300',NULL),
	(518,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/le4acf50aaacc4d86a8ad041040cfa3d\",\"updatedAt\":\"2018-08-28T00:35:19.588900+00:00\"}','2018-08-28 00:39:38.775000','2018-08-28 00:39:38.775000',NULL),
	(519,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:38.840100','2018-08-28 00:39:38.840100',NULL),
	(520,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:38.855600','2018-08-28 00:39:38.855600',NULL),
	(521,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:38.903400','2018-08-28 00:39:38.903400',NULL),
	(522,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:38.914000','2018-08-28 00:39:38.914000',NULL),
	(523,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:38.955300','2018-08-28 00:39:38.955300',NULL),
	(524,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:38.961000','2018-08-28 00:39:38.961000',NULL),
	(525,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:38.997700','2018-08-28 00:39:38.997700',NULL),
	(526,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:39.007800','2018-08-28 00:39:39.007800',NULL),
	(527,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:39.102600','2018-08-28 00:39:39.102600',NULL),
	(528,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:39.157900','2018-08-28 00:39:39.157900',NULL),
	(529,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/le4acf50aaacc4d86a8ad041040cfa3d\",\"updatedAt\":\"2018-08-28T00:35:19.588900+00:00\"}','2018-08-28 00:39:39.206100','2018-08-28 00:39:39.206100',NULL),
	(530,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/le4acf50aaacc4d86a8ad041040cfa3d\",\"updatedAt\":\"2018-08-28T00:35:19.588900+00:00\"}','2018-08-28 00:39:39.222800','2018-08-28 00:39:39.222800',NULL),
	(531,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:39.266800','2018-08-28 00:39:39.266800',NULL),
	(532,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:39.284300','2018-08-28 00:39:39.284300',NULL),
	(533,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/obd58aaaf121440c8afa9b47d25522af\",\"updatedAt\":\"2018-08-28T00:35:29.227700+00:00\"}','2018-08-28 00:39:39.313000','2018-08-28 00:39:39.313000',NULL),
	(534,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/obd58aaaf121440c8afa9b47d25522af\",\"updatedAt\":\"2018-08-28T00:35:29.227700+00:00\"}','2018-08-28 00:39:39.352200','2018-08-28 00:39:39.352200',NULL),
	(535,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/s5802ee9570f642b28342df283d297af\",\"updatedAt\":\"2018-08-28T00:35:28.552600+00:00\"}','2018-08-28 00:39:39.378500','2018-08-28 00:39:39.378500',NULL),
	(536,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/obd58aaaf121440c8afa9b47d25522af\",\"updatedAt\":\"2018-08-28T00:35:29.227700+00:00\"}','2018-08-28 00:39:39.413600','2018-08-28 00:39:39.413600',NULL),
	(537,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/obd58aaaf121440c8afa9b47d25522af\",\"updatedAt\":\"2018-08-28T00:35:29.227700+00:00\"}','2018-08-28 00:39:39.452500','2018-08-28 00:39:39.452500',NULL),
	(538,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/obd58aaaf121440c8afa9b47d25522af\",\"updatedAt\":\"2018-08-28T00:35:29.227700+00:00\"}','2018-08-28 00:39:39.490000','2018-08-28 00:39:39.490000',NULL),
	(539,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/obd58aaaf121440c8afa9b47d25522af\",\"updatedAt\":\"2018-08-28T00:35:29.227700+00:00\"}','2018-08-28 00:39:39.523900','2018-08-28 00:39:39.523900',NULL),
	(540,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/obd58aaaf121440c8afa9b47d25522af\",\"updatedAt\":\"2018-08-28T00:35:29.227700+00:00\"}','2018-08-28 00:39:39.603700','2018-08-28 00:39:39.603700',NULL),
	(541,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/s5802ee9570f642b28342df283d297af\",\"updatedAt\":\"2018-08-28T00:35:28.552600+00:00\"}','2018-08-28 00:39:39.697500','2018-08-28 00:39:39.697500',NULL),
	(542,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/obd58aaaf121440c8afa9b47d25522af\",\"updatedAt\":\"2018-08-28T00:35:29.227700+00:00\"}','2018-08-28 00:39:39.738200','2018-08-28 00:39:39.738200',NULL),
	(543,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/yb1f56e05de0b4d0fa9947708cafb791\",\"updatedAt\":\"2018-08-28T00:35:44.707700+00:00\"}','2018-08-28 00:39:39.783900','2018-08-28 00:39:39.783900',NULL),
	(544,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/yb1f56e05de0b4d0fa9947708cafb791\",\"updatedAt\":\"2018-08-28T00:35:44.707700+00:00\"}','2018-08-28 00:39:39.825600','2018-08-28 00:39:39.825600',NULL),
	(545,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/d4f7a84149dff4e92a9180d8d97bdd1c\",\"updatedAt\":\"2018-08-28T00:35:38.262000+00:00\"}','2018-08-28 00:39:39.859300','2018-08-28 00:39:39.859300',NULL),
	(546,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/yb1f56e05de0b4d0fa9947708cafb791\",\"updatedAt\":\"2018-08-28T00:35:44.707700+00:00\"}','2018-08-28 00:39:39.900100','2018-08-28 00:39:39.900100',NULL),
	(547,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/yb1f56e05de0b4d0fa9947708cafb791\",\"updatedAt\":\"2018-08-28T00:35:44.707700+00:00\"}','2018-08-28 00:39:39.941900','2018-08-28 00:39:39.941900',NULL),
	(548,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/yb1f56e05de0b4d0fa9947708cafb791\",\"updatedAt\":\"2018-08-28T00:35:44.707700+00:00\"}','2018-08-28 00:39:39.977600','2018-08-28 00:39:39.977600',NULL),
	(549,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/yb1f56e05de0b4d0fa9947708cafb791\",\"updatedAt\":\"2018-08-28T00:35:44.707700+00:00\"}','2018-08-28 00:39:40.016299','2018-08-28 00:39:40.016299',NULL),
	(550,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/yb1f56e05de0b4d0fa9947708cafb791\",\"updatedAt\":\"2018-08-28T00:35:44.707700+00:00\"}','2018-08-28 00:39:40.060700','2018-08-28 00:39:40.060700',NULL),
	(551,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/courses\\/d4f7a84149dff4e92a9180d8d97bdd1c\",\"updatedAt\":\"2018-08-28T00:35:38.262000+00:00\"}','2018-08-28 00:39:40.080600','2018-08-28 00:39:40.080600',NULL),
	(552,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/yb1f56e05de0b4d0fa9947708cafb791\",\"updatedAt\":\"2018-08-28T00:35:44.707700+00:00\"}','2018-08-28 00:39:40.117800','2018-08-28 00:39:40.117800',NULL),
	(553,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:40.172900','2018-08-28 00:39:40.172900',NULL),
	(554,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:40.182200','2018-08-28 00:39:40.182200',NULL),
	(555,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/yb1f56e05de0b4d0fa9947708cafb791\",\"updatedAt\":\"2018-08-28T00:35:44.707700+00:00\"}','2018-08-28 00:39:40.212200','2018-08-28 00:39:40.212200',NULL),
	(556,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:40.247300','2018-08-28 00:39:40.247300',NULL),
	(557,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/enrollments\\/j521e4337397c4b2484eabf265e314cd\",\"updatedAt\":\"2018-08-28T00:35:46.394000+00:00\"}','2018-08-28 00:39:40.256699','2018-08-28 00:39:40.256699',NULL),
	(558,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/tcc103f3018c9471caae122e1b4630c0\",\"updatedAt\":\"2018-08-28T00:35:54.170800+00:00\"}','2018-08-28 00:39:40.340100','2018-08-28 00:39:40.340100',NULL),
	(559,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/posts\\/tcc103f3018c9471caae122e1b4630c0\",\"updatedAt\":\"2018-08-28T00:35:54.170800+00:00\"}','2018-08-28 00:39:40.362400','2018-08-28 00:39:40.362400',NULL),
	(560,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/df07e6e27dceb4b04b2071840ab5d00d\",\"updatedAt\":\"2018-08-28T00:36:31.029000+00:00\"}','2018-08-28 00:39:40.419200','2018-08-28 00:39:40.419200',NULL),
	(561,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/df07e6e27dceb4b04b2071840ab5d00d\",\"updatedAt\":\"2018-08-28T00:36:31.029000+00:00\"}','2018-08-28 00:39:40.452700','2018-08-28 00:39:40.452700',NULL),
	(562,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/o620f30c116314db088f1fb59e8a5f87\",\"updatedAt\":\"2018-08-28T00:36:49.808600+00:00\"}','2018-08-28 00:39:40.517000','2018-08-28 00:39:40.517000',NULL),
	(563,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/o620f30c116314db088f1fb59e8a5f87\",\"updatedAt\":\"2018-08-28T00:36:49.808600+00:00\"}','2018-08-28 00:39:40.524800','2018-08-28 00:39:40.524800',NULL),
	(564,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/a54c46e4cef0b4183ac9a2fc6bece1ac\",\"updatedAt\":\"2018-08-28T00:36:52.694100+00:00\"}','2018-08-28 00:39:40.585300','2018-08-28 00:39:40.585300',NULL),
	(565,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/a54c46e4cef0b4183ac9a2fc6bece1ac\",\"updatedAt\":\"2018-08-28T00:36:52.694100+00:00\"}','2018-08-28 00:39:40.604000','2018-08-28 00:39:40.604000',NULL),
	(566,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/a54c46e4cef0b4183ac9a2fc6bece1ac\",\"updatedAt\":\"2018-08-28T00:36:52.694100+00:00\"}','2018-08-28 00:39:40.624700','2018-08-28 00:39:40.624700',NULL),
	(567,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/a54c46e4cef0b4183ac9a2fc6bece1ac\",\"updatedAt\":\"2018-08-28T00:36:52.694100+00:00\"}','2018-08-28 00:39:40.638900','2018-08-28 00:39:40.638900',NULL),
	(568,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/a54c46e4cef0b4183ac9a2fc6bece1ac\",\"updatedAt\":\"2018-08-28T00:36:52.694100+00:00\"}','2018-08-28 00:39:40.652300','2018-08-28 00:39:40.652300',NULL),
	(569,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/a54c46e4cef0b4183ac9a2fc6bece1ac\",\"updatedAt\":\"2018-08-28T00:36:52.694100+00:00\"}','2018-08-28 00:39:40.682400','2018-08-28 00:39:40.682400',NULL),
	(570,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/lb3091d6f103d46e4bdd565a6f530e7a\",\"updatedAt\":\"2018-08-28T00:37:00.389800+00:00\"}','2018-08-28 00:39:40.733200','2018-08-28 00:39:40.733200',NULL),
	(571,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/lb3091d6f103d46e4bdd565a6f530e7a\",\"updatedAt\":\"2018-08-28T00:37:00.389800+00:00\"}','2018-08-28 00:39:40.754900','2018-08-28 00:39:40.754900',NULL),
	(572,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/lb3091d6f103d46e4bdd565a6f530e7a\",\"updatedAt\":\"2018-08-28T00:37:00.389800+00:00\"}','2018-08-28 00:39:40.787900','2018-08-28 00:39:40.787900',NULL),
	(573,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/lb3091d6f103d46e4bdd565a6f530e7a\",\"updatedAt\":\"2018-08-28T00:37:00.389800+00:00\"}','2018-08-28 00:39:40.810800','2018-08-28 00:39:40.810800',NULL),
	(574,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/lb3091d6f103d46e4bdd565a6f530e7a\",\"updatedAt\":\"2018-08-28T00:37:00.389800+00:00\"}','2018-08-28 00:39:40.818200','2018-08-28 00:39:40.818200',NULL),
	(575,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/lb3091d6f103d46e4bdd565a6f530e7a\",\"updatedAt\":\"2018-08-28T00:37:00.389800+00:00\"}','2018-08-28 00:39:40.833300','2018-08-28 00:39:40.833300',NULL),
	(576,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/l8d32c7e41a3d450b89caeb30f9746e0\",\"updatedAt\":\"2018-08-28T00:37:01.933800+00:00\"}','2018-08-28 00:39:40.940600','2018-08-28 00:39:40.940600',NULL),
	(577,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/l8d32c7e41a3d450b89caeb30f9746e0\",\"updatedAt\":\"2018-08-28T00:37:01.933800+00:00\"}','2018-08-28 00:39:40.960700','2018-08-28 00:39:40.960700',NULL),
	(578,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/l8d32c7e41a3d450b89caeb30f9746e0\",\"updatedAt\":\"2018-08-28T00:37:01.933800+00:00\"}','2018-08-28 00:39:40.981500','2018-08-28 00:39:40.981500',NULL),
	(579,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/l8d32c7e41a3d450b89caeb30f9746e0\",\"updatedAt\":\"2018-08-28T00:37:01.933800+00:00\"}','2018-08-28 00:39:41.015300','2018-08-28 00:39:41.015300',NULL),
	(580,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/l8d32c7e41a3d450b89caeb30f9746e0\",\"updatedAt\":\"2018-08-28T00:37:01.933800+00:00\"}','2018-08-28 00:39:41.032900','2018-08-28 00:39:41.032900',NULL),
	(581,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/l8d32c7e41a3d450b89caeb30f9746e0\",\"updatedAt\":\"2018-08-28T00:37:01.933800+00:00\"}','2018-08-28 00:39:41.053800','2018-08-28 00:39:41.053800',NULL),
	(582,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/e89718922b5da4afb894199de6f90968\",\"updatedAt\":\"2018-08-28T00:37:04.750100+00:00\"}','2018-08-28 00:39:41.099600','2018-08-28 00:39:41.099600',NULL),
	(583,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/e89718922b5da4afb894199de6f90968\",\"updatedAt\":\"2018-08-28T00:37:04.750100+00:00\"}','2018-08-28 00:39:41.120900','2018-08-28 00:39:41.120900',NULL),
	(584,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/e89718922b5da4afb894199de6f90968\",\"updatedAt\":\"2018-08-28T00:37:04.750100+00:00\"}','2018-08-28 00:39:41.143200','2018-08-28 00:39:41.143200',NULL),
	(585,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/e89718922b5da4afb894199de6f90968\",\"updatedAt\":\"2018-08-28T00:37:04.750100+00:00\"}','2018-08-28 00:39:41.163200','2018-08-28 00:39:41.163200',NULL),
	(586,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/e89718922b5da4afb894199de6f90968\",\"updatedAt\":\"2018-08-28T00:37:04.750100+00:00\"}','2018-08-28 00:39:41.184800','2018-08-28 00:39:41.184800',NULL),
	(587,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"deleted\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/e89718922b5da4afb894199de6f90968\",\"updatedAt\":\"2018-08-28T00:37:04.750100+00:00\"}','2018-08-28 00:39:41.199700','2018-08-28 00:39:41.199700',NULL),
	(588,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/o5478dbd4913645fd894f8077beb5821\",\"updatedAt\":\"2018-08-28T00:37:05.643100+00:00\"}','2018-08-28 00:39:41.296800','2018-08-28 00:39:41.296800',NULL),
	(589,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/o5478dbd4913645fd894f8077beb5821\",\"updatedAt\":\"2018-08-28T00:37:05.643100+00:00\"}','2018-08-28 00:39:41.317500','2018-08-28 00:39:41.317500',NULL),
	(590,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/o5478dbd4913645fd894f8077beb5821\",\"updatedAt\":\"2018-08-28T00:37:05.643100+00:00\"}','2018-08-28 00:39:41.339900','2018-08-28 00:39:41.339900',NULL),
	(591,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/o5478dbd4913645fd894f8077beb5821\",\"updatedAt\":\"2018-08-28T00:37:05.643100+00:00\"}','2018-08-28 00:39:41.358900','2018-08-28 00:39:41.358900',NULL),
	(592,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/o5478dbd4913645fd894f8077beb5821\",\"updatedAt\":\"2018-08-28T00:37:05.643100+00:00\"}','2018-08-28 00:39:41.369400','2018-08-28 00:39:41.369400',NULL),
	(593,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/o5478dbd4913645fd894f8077beb5821\",\"updatedAt\":\"2018-08-28T00:37:05.643100+00:00\"}','2018-08-28 00:39:41.378100','2018-08-28 00:39:41.378100',NULL),
	(594,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/g8a90658e9e004ef2844fd02c01e6a57\",\"updatedAt\":\"2018-08-28T00:39:53.513800+00:00\"}','2018-08-28 00:39:56.451500','2018-08-28 00:39:56.451500',NULL),
	(595,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/g8a90658e9e004ef2844fd02c01e6a57\",\"updatedAt\":\"2018-08-28T00:39:53.513800+00:00\"}','2018-08-28 00:39:56.459700','2018-08-28 00:39:56.459700',NULL),
	(596,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/g8a90658e9e004ef2844fd02c01e6a57\",\"updatedAt\":\"2018-08-28T00:39:53.513800+00:00\"}','2018-08-28 00:39:56.471600','2018-08-28 00:39:56.471600',NULL),
	(597,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/g8a90658e9e004ef2844fd02c01e6a57\",\"updatedAt\":\"2018-08-28T00:39:53.513800+00:00\"}','2018-08-28 00:39:56.479200','2018-08-28 00:39:56.479200',NULL),
	(598,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/g8a90658e9e004ef2844fd02c01e6a57\",\"updatedAt\":\"2018-08-28T00:39:53.513800+00:00\"}','2018-08-28 00:39:56.484500','2018-08-28 00:39:56.484500',NULL),
	(599,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/g8a90658e9e004ef2844fd02c01e6a57\",\"updatedAt\":\"2018-08-28T00:39:53.513800+00:00\"}','2018-08-28 00:39:56.490100','2018-08-28 00:39:56.490100',NULL),
	(600,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/r8930f48279a541b1a09b3da22a6dbf3\",\"updatedAt\":\"2018-08-28T00:39:55.911200+00:00\"}','2018-08-28 00:39:56.522000','2018-08-28 00:39:56.522000',NULL),
	(601,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/r8930f48279a541b1a09b3da22a6dbf3\",\"updatedAt\":\"2018-08-28T00:39:55.911200+00:00\"}','2018-08-28 00:39:56.529200','2018-08-28 00:39:56.529200',NULL),
	(602,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/r8930f48279a541b1a09b3da22a6dbf3\",\"updatedAt\":\"2018-08-28T00:39:55.911200+00:00\"}','2018-08-28 00:39:56.535300','2018-08-28 00:39:56.535300',NULL),
	(603,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/r8930f48279a541b1a09b3da22a6dbf3\",\"updatedAt\":\"2018-08-28T00:39:55.911200+00:00\"}','2018-08-28 00:39:56.546700','2018-08-28 00:39:56.546700',NULL),
	(604,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/r8930f48279a541b1a09b3da22a6dbf3\",\"updatedAt\":\"2018-08-28T00:39:55.911200+00:00\"}','2018-08-28 00:39:56.557300','2018-08-28 00:39:56.557300',NULL),
	(605,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/r8930f48279a541b1a09b3da22a6dbf3\",\"updatedAt\":\"2018-08-28T00:39:55.911200+00:00\"}','2018-08-28 00:39:56.563300','2018-08-28 00:39:56.563300',NULL),
	(606,1,'U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/z4f38a1260ec441da86d3fa5c4ab219f\",\"updatedAt\":\"2018-08-28T00:39:57.917600+00:00\"}','2018-08-28 00:39:59.601500','2018-08-28 00:39:59.601500',NULL),
	(607,2,'JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/z4f38a1260ec441da86d3fa5c4ab219f\",\"updatedAt\":\"2018-08-28T00:39:57.917600+00:00\"}','2018-08-28 00:39:59.607200','2018-08-28 00:39:59.607200',NULL),
	(608,3,'d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/z4f38a1260ec441da86d3fa5c4ab219f\",\"updatedAt\":\"2018-08-28T00:39:57.917600+00:00\"}','2018-08-28 00:39:59.611300','2018-08-28 00:39:59.611300',NULL),
	(609,10,'zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/z4f38a1260ec441da86d3fa5c4ab219f\",\"updatedAt\":\"2018-08-28T00:39:57.917600+00:00\"}','2018-08-28 00:39:59.615700','2018-08-28 00:39:59.615700',NULL),
	(610,11,'Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/z4f38a1260ec441da86d3fa5c4ab219f\",\"updatedAt\":\"2018-08-28T00:39:57.917600+00:00\"}','2018-08-28 00:39:59.623000','2018-08-28 00:39:59.623000',NULL),
	(611,14,'HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3','{\"action\":\"updated\",\"target\":[],\"updateUrl\":\"https:\\/\\/demo.notebowl.xyz\\/api\\/v1.0\\/likes\\/z4f38a1260ec441da86d3fa5c4ab219f\",\"updatedAt\":\"2018-08-28T00:39:57.917600+00:00\"}','2018-08-28 00:39:59.632200','2018-08-28 00:39:59.632200',NULL);

/*!40000 ALTER TABLE `sockets` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table submissions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `submissions`;

CREATE TABLE `submissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `owner_id` int(10) unsigned NOT NULL,
  `owner_type` varchar(190) NOT NULL,
  `creator_id` int(10) unsigned NOT NULL,
  `parent_id` int(10) unsigned NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `resource_key` varchar(32) NOT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `text` longtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `submissions_resource_key_unique` (`resource_key`),
  KEY `submissions_assignment_id_deleted_at_index` (`parent_id`,`deleted_at`),
  KEY `submissions_owner_id_index` (`owner_id`),
  KEY `submissions_parent_id_index` (`parent_id`),
  KEY `submissions_creator_id_index` (`creator_id`),
  KEY `submissions_deleted_at_index` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table terms
# ------------------------------------------------------------

DROP TABLE IF EXISTS `terms`;

CREATE TABLE `terms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(190) NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `available_date` datetime NOT NULL,
  `permalink` varchar(190) NOT NULL,
  `university_id` int(10) unsigned NOT NULL,
  `resource_key` varchar(32) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `university_terms_resource_key_unique` (`resource_key`),
  UNIQUE KEY `university_terms_permalink_university_id_deleted_at_unique` (`permalink`,`university_id`,`deleted_at`),
  KEY `university_terms_term_available_index` (`available_date`),
  KEY `university_terms_deleted_at_index` (`deleted_at`),
  KEY `university_terms_term_available_deleted_at_index` (`available_date`,`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `terms` WRITE;
/*!40000 ALTER TABLE `terms` DISABLE KEYS */;

INSERT INTO `terms` (`id`, `title`, `start_date`, `end_date`, `available_date`, `permalink`, `university_id`, `resource_key`, `created_at`, `updated_at`, `deleted_at`)
VALUES
	(1,'Fall 2014','2014-01-01 00:00:00','2050-01-01 00:00:00','2014-01-01 00:00:00','forever-term',1,'JwQlgcfCVRWjDkPiwonbMgGPIaF5WJ1S','2016-05-13 01:59:34.329759','2016-05-13 01:59:34.329759',NULL);

/*!40000 ALTER TABLE `terms` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table universities
# ------------------------------------------------------------

DROP TABLE IF EXISTS `universities`;

CREATE TABLE `universities` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(190) NOT NULL,
  `permalink` varchar(190) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `zip` int(11) NOT NULL,
  `domain` varchar(190) NOT NULL,
  `state` int(10) unsigned NOT NULL DEFAULT '2',
  `resource_key` varchar(32) NOT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `default_logo` varchar(190) DEFAULT NULL,
  `profile_logo` varchar(190) DEFAULT NULL,
  `group_create` tinyint(1) NOT NULL DEFAULT '1',
  `accepted_domain` varchar(190) DEFAULT NULL,
  `timezone` varchar(190) NOT NULL DEFAULT 'America/Phoenix',
  `enroll_admins_courses` tinyint(1) NOT NULL,
  `enroll_admins_groups` tinyint(1) NOT NULL,
  `send_email_from_user` tinyint(1) NOT NULL DEFAULT '0',
  `default_course_price` double(6,2) NOT NULL DEFAULT '0.00',
  `enable_google_convert_submissions` tinyint(1) NOT NULL DEFAULT '0',
  `enable_grade_averages_assistant` tinyint(1) NOT NULL DEFAULT '1',
  `clubs_contact` varchar(255) DEFAULT NULL,
  `grade_scale_medians` varchar(255) NOT NULL DEFAULT '30ÿ65ÿ75ÿ85ÿ95',
  `grade_scale_titles` varchar(255) NOT NULL DEFAULT 'FÿDÿCÿBÿA',
  `grade_scale_values` varchar(255) NOT NULL DEFAULT '0ÿ60ÿ70ÿ80ÿ90',
  `club_officer_date` datetime DEFAULT NULL,
  `club_reregister_open_date` datetime DEFAULT NULL,
  `club_reregister_close_date` datetime DEFAULT NULL,
  `lock_sis_rosters` tinyint(1) NOT NULL DEFAULT '0',
  `intercom_key` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `universities_resource_key_unique` (`resource_key`),
  UNIQUE KEY `universities_permalink_deleted_at_unique` (`permalink`,`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `universities` WRITE;
/*!40000 ALTER TABLE `universities` DISABLE KEYS */;

INSERT INTO `universities` (`id`, `name`, `permalink`, `created_at`, `updated_at`, `zip`, `domain`, `state`, `resource_key`, `deleted_at`, `default_logo`, `profile_logo`, `group_create`, `accepted_domain`, `timezone`, `enroll_admins_courses`, `enroll_admins_groups`, `send_email_from_user`, `default_course_price`, `enable_google_convert_submissions`, `enable_grade_averages_assistant`, `clubs_contact`, `grade_scale_medians`, `grade_scale_titles`, `grade_scale_values`, `club_officer_date`, `club_reregister_open_date`, `club_reregister_close_date`, `lock_sis_rosters`, `intercom_key`)
VALUES
	(1,'University of Arizona','ua-az','2016-05-13 01:59:34.195980','2018-04-19 04:12:51.653700',0,'demo.notebowl.xyz',2,'i5bb990b3969342e5b815d64ac4d3893',NULL,NULL,NULL,1,NULL,'America/Phoenix',0,0,0,0.00,0,1,NULL,'30;65;75;85;95','F;D;C;B;A','0;60;70;80;90',NULL,NULL,NULL,0,NULL);

/*!40000 ALTER TABLE `universities` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table user_emails
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_emails`;

CREATE TABLE `user_emails` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `email` varchar(190) NOT NULL,
  `resource_key` varchar(32) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `password` varchar(190) DEFAULT NULL,
  `type` enum('notification','login') NOT NULL DEFAULT 'notification',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_emails_resource_key_unique` (`resource_key`),
  UNIQUE KEY `user_emails_user_id_email_deleted_at_unique` (`user_id`,`email`,`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table user_role
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_role`;

CREATE TABLE `user_role` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `role_id` int(10) unsigned NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_role_role_id_user_id_unique` (`role_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table user_sessions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_sessions`;

CREATE TABLE `user_sessions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `ip_address` varchar(16) NOT NULL,
  `device_id` int(11) DEFAULT NULL,
  `user_agent` mediumtext NOT NULL,
  `session_id` varchar(190) NOT NULL DEFAULT '',
  `logged_out` timestamp(6) NULL DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `resource_key` varchar(32) NOT NULL,
  `university_id` int(10) unsigned NOT NULL,
  `expired` tinyint(1) DEFAULT NULL,
  `user_email` int(10) unsigned DEFAULT NULL,
  `nonce` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_sessions_resource_key_unique` (`resource_key`),
  KEY `user_sessions_university_id_created_at_deleted_at_index` (`university_id`,`created_at`,`deleted_at`),
  KEY `user_sessions_user_id_index` (`user_id`),
  KEY `user_sessions_created_at_index` (`created_at`),
  KEY `user_sessions_session_id_index` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `user_sessions` WRITE;
/*!40000 ALTER TABLE `user_sessions` DISABLE KEYS */;

INSERT INTO `user_sessions` (`id`, `user_id`, `ip_address`, `device_id`, `user_agent`, `session_id`, `logged_out`, `created_at`, `updated_at`, `deleted_at`, `resource_key`, `university_id`, `expired`, `user_email`, `nonce`)
VALUES
	(1,1,'172.18.0.1',NULL,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3514.2 Safari/537.36','bDdEnkFnMmLtY9dyH007mBHhtbC19ArJJlsQnUFb',NULL,'2018-08-28 00:02:53.258000','2018-08-28 00:02:53.258000',NULL,'babb8d085c6f34914afd8e9f11b35f80',1,NULL,NULL,NULL),
	(2,1,'172.18.0.1',NULL,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3514.2 Safari/537.36','DoTrmAH3A3i9FFFJSTXAujPmiSPWoqolEA1D5KE2',NULL,'2018-08-28 00:06:26.682900','2018-08-28 00:06:26.682900',NULL,'v1f43a7a2bb7845bbb34ff5f099ac062',1,NULL,NULL,NULL),
	(3,14,'172.18.0.1',NULL,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3514.2 Safari/537.36','GBxH08swkO8dIGvYfcT2xz0ocXozE5PdlqohcZMu',NULL,'2018-08-28 00:22:41.407400','2018-08-28 00:22:41.407400',NULL,'vb047bce55f0e4b92b9390e1b3ccfbaa',1,NULL,NULL,NULL),
	(4,10,'172.18.0.1',NULL,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3514.2 Safari/537.36','C55nmi2apnjrhy7PkCUZRdaKWliMpQW80XxSlBS2',NULL,'2018-08-28 00:23:28.252300','2018-08-28 00:23:28.252300',NULL,'x72c2da85036045a68913acfe35b2164',1,NULL,NULL,NULL),
	(5,11,'172.18.0.1',NULL,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3514.2 Safari/537.36','T5zkF5KYBmbxfizxDr0p1viZblHs75QqjBZNIZfL',NULL,'2018-08-28 00:24:14.224900','2018-08-28 00:24:14.224900',NULL,'pc8535dd8fc1047539163361186a7154',1,NULL,NULL,NULL),
	(6,2,'172.18.0.1',NULL,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3514.2 Safari/537.36','ZhcG9dBx8fM8eh0ejHCuVCosz4DtaPutEQOhSAKj',NULL,'2018-08-28 00:25:08.637800','2018-08-28 00:25:08.637800',NULL,'ua83b5533bf274b8d937e09f1582426e',1,NULL,NULL,NULL),
	(7,14,'172.18.0.1',NULL,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3514.2 Safari/537.36','mdpQ8VDGkgu00ZtGCD7WqZeOQGBnSm6a1EoIy1Ci',NULL,'2018-08-28 00:25:52.804700','2018-08-28 00:25:52.804700',NULL,'ba05df9cbf7db4aba8aeebc749ca4d33',1,NULL,NULL,NULL),
	(8,3,'172.18.0.1',NULL,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3514.2 Safari/537.36','mCxl4DrwOhUwUjKY6mVo7i18qXl8hNL2IvR2Ekhx',NULL,'2018-08-28 00:27:16.609000','2018-08-28 00:27:16.609000',NULL,'mf9eefb38024a430983aaf0413e79c88',1,NULL,NULL,NULL),
	(9,10,'172.18.0.1',NULL,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3514.2 Safari/537.36','dUEMi0Nt8DE0YEMYyWJ9P8LcGylA3qNewu1UDqCd',NULL,'2018-08-28 00:28:46.108600','2018-08-28 00:28:46.108600',NULL,'e6f9601ebeee44b3a862d3995af927ab',1,NULL,NULL,NULL),
	(10,1,'172.18.0.1',NULL,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3514.2 Safari/537.36','o3z6zHk4xn31zKIAYuqPS7DsmdMmyQws96jxcvEe',NULL,'2018-08-28 00:29:58.381900','2018-08-28 00:29:58.381900',NULL,'a50d9c9063a864431b401d5f6d5338e6',1,NULL,NULL,NULL),
	(11,1,'172.18.0.1',NULL,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3514.2 Safari/537.36','yIQ0rH5f7mLBZ5oQ09JcTJRtWXbadoB9WDYjlIj1',NULL,'2018-08-28 00:34:31.885100','2018-08-28 00:34:31.885100',NULL,'nea3fbfd64de1450c9bf286930435039',1,NULL,NULL,NULL),
	(12,3,'172.18.0.1',NULL,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3514.2 Safari/537.36','4Quxeh7mk9YbiUVYYV6n5132vWesvC4jxGL2BsHr',NULL,'2018-08-28 00:34:55.270100','2018-08-28 00:34:55.270100',NULL,'q13b69087e5de420b8a017afe79dbb84',1,NULL,NULL,NULL),
	(13,10,'172.18.0.1',NULL,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3514.2 Safari/537.36','1fvuoO9EZp5eduYOWNVmHmVmK3ur1NUMebOMrsQ1',NULL,'2018-08-28 00:36:42.006100','2018-08-28 00:36:42.006100',NULL,'o8bca508cac244d0fbfb60d41041eb15',1,NULL,NULL,NULL),
	(14,3,'172.18.0.1',NULL,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3514.2 Safari/537.36','46lVSnT4LDhAO4UCpLkXUaOyY9KZoSkmFxDeWD2X',NULL,'2018-08-28 00:37:51.285800','2018-08-28 00:37:51.285800',NULL,'t0a0dcef7776a4e9e956de3e4df0200f',1,NULL,NULL,NULL),
	(15,14,'172.18.0.1',NULL,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3514.2 Safari/537.36','tgcWLsgnB1RUXG8DYUbGiIKQJjoJ3Sz2Hw8TfR8W',NULL,'2018-08-28 00:39:43.265900','2018-08-28 00:39:43.265900',NULL,'b39697d0f28f54ad890fc3e54435439e',1,NULL,NULL,NULL),
	(16,3,'172.18.0.1',NULL,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3514.2 Safari/537.36','pEdRim6Z9EmNiu8xiHiyB4LNzp2anODQ9zQRF4Up',NULL,'2018-08-28 00:40:18.452200','2018-08-28 00:40:18.452200',NULL,'c3959b97f7f4947f6ad3531ab3ee815d',1,NULL,NULL,NULL),
	(17,3,'172.18.0.1',NULL,'Notebowl%20Mobile/162000 CFNetwork/901.1 Darwin/18.0.0','2mByTtTDhOMQjB5BQDLunLWlEktz79mtnlRlQcry',NULL,'2018-08-28 00:42:05.875400','2018-08-28 00:42:05.875400',NULL,'sf21666e1202141b9aa79a47a19e2442',1,NULL,NULL,NULL),
	(18,3,'172.18.0.1',NULL,'Notebowl%20Mobile/162000 CFNetwork/901.1 Darwin/18.0.0','f5cPCfwHRpOf5ifqodShdvG4caYEm0kM6rBY0MtL',NULL,'2018-08-28 00:42:06.646400','2018-08-28 00:42:06.646400',NULL,'q5e9bfa516c2641918105df8a1781176',1,NULL,NULL,NULL);

/*!40000 ALTER TABLE `user_sessions` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `university_id` int(10) unsigned NOT NULL,
  `email` varchar(190) NOT NULL,
  `phone_number` varchar(190) DEFAULT NULL,
  `password` varchar(190) DEFAULT NULL,
  `profile_picture` varchar(190) DEFAULT '',
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `resource_key` varchar(32) NOT NULL,
  `admin` tinyint(1) NOT NULL DEFAULT '0',
  `mode` smallint(6) NOT NULL,
  `reset_token` varchar(190) DEFAULT NULL,
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  `tos_verify` tinyint(1) NOT NULL DEFAULT '0',
  `timezone` varchar(190) DEFAULT NULL,
  `first_name` varchar(190) DEFAULT NULL,
  `last_name` varchar(190) DEFAULT NULL,
  `event_create` tinyint(1) NOT NULL DEFAULT '1',
  `group_create` tinyint(1) NOT NULL DEFAULT '1',
  `post_create` tinyint(1) NOT NULL DEFAULT '1',
  `api_token` varchar(64) DEFAULT NULL,
  `stripe_id` varchar(255) DEFAULT NULL,
  `card_brand` varchar(255) DEFAULT NULL,
  `card_last_four` varchar(255) DEFAULT NULL,
  `trial_ends_at` timestamp NULL DEFAULT NULL,
  `grad_year` int(10) unsigned DEFAULT NULL,
  `grad_month` int(10) unsigned DEFAULT NULL,
  `last_login_at` timestamp(6) NULL DEFAULT NULL,
  `intercom` tinyint(1) NOT NULL DEFAULT '1',
  `verified_email` tinyint(1) NOT NULL DEFAULT '1',
  `zoom_api` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_resource_key_unique` (`resource_key`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_university_id_index` (`university_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`id`, `university_id`, `email`, `phone_number`, `password`, `profile_picture`, `created_at`, `updated_at`, `resource_key`, `admin`, `mode`, `reset_token`, `deleted_at`, `tos_verify`, `timezone`, `first_name`, `last_name`, `event_create`, `group_create`, `post_create`, `api_token`, `stripe_id`, `card_brand`, `card_last_four`, `trial_ends_at`, `grad_year`, `grad_month`, `last_login_at`, `intercom`, `verified_email`, `zoom_api`)
VALUES
	(1,1,'admin@notebowl.com',NULL,'$2y$10$QJVvdy8scOkpjAWiTz.jbu2OTieU.IcMgmwej6d2hx9VFxFaFVwGK','https://notebowl.s3.amazonaws.com/users/U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi/profile-picture/EFZRd9vadqmvY11kSWCFgeCK1k09BBu1','2016-05-13 01:59:41.424897','2018-08-28 00:34:31.895300','U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi',1,2,NULL,NULL,1,NULL,'Notebowl','User',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-08-28 00:34:31.895200',1,1,NULL),
	(2,1,'alexs@notebowl.com',NULL,'$2y$10$j4fOmjMjh.lvoPJzDZZpqeIOnDOAtaHx9Xma7KyeVmjmoQXQloVDG','https://notebowl.s3.amazonaws.com/users/JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4/profile-picture/PMjowlCwESuuBWYvuikErkWqsm85tTEn','2016-05-13 01:59:41.507325','2018-08-28 00:25:08.647900','JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4',0,2,NULL,NULL,1,NULL,'Alex','Slaughter',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-08-28 00:25:08.647900',1,1,NULL),
	(3,1,'andrew.chaifetz@notebowl.com',NULL,'$2y$10$r131g6obNE3GeeTtIP6.FOmSbQUOTjZdRMwHLmwocvKjrWN0KIbs6','https://notebowl.s3.amazonaws.com/users/d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ/profile-picture/SMuLTTF2p5EqNpNeOHQHfyNzx5b4j4Du','2016-05-13 01:59:41.583603','2018-08-28 00:42:06.651700','d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ',0,2,NULL,NULL,1,NULL,'Andrew','Chaifetz',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-08-28 00:42:06.651600',1,1,NULL),
	(4,1,'alexc@notebowl.com',NULL,'$2y$10$Mpn2yVOf52QUpVBit/R8Rus28ZwDdhWFPhYuKDT4.9HvNyf45RUdO','https://notebowl.s3.amazonaws.com/users/mZBS7dLUiNdBEfDVjUh6krB54jlRaCPt/profile-picture/qvXxuSg7ESUmgJDWxRJDyiKfpFOsv1um','2016-05-13 01:59:41.668478','2016-11-10 20:20:28.692100','mZBS7dLUiNdBEfDVjUh6krB54jlRaCPt',0,2,NULL,NULL,1,NULL,'Alex','Coomans',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(5,1,'matt.silverstone@notebowl.com',NULL,'$2y$10$4FyJx3S8IcCMBQoXiFkXZ.t3aVar2omHJJ7yB2kss6nl4rIBOZdN6',NULL,'2016-05-13 01:59:41.751167','2016-11-10 20:20:28.692100','BipyPUZK2b1otMJOkVh21CUlA3GvO9Oh',0,2,NULL,NULL,1,NULL,'Matt','Sliverstone',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(6,1,'scott.birgel@notebowl.com',NULL,'$2y$10$NtmoZLU3RVviRH.JmsYZHur5zM4LO9vMrI8q0/jtDIanYs1.lCRWG',NULL,'2016-05-13 01:59:41.831772','2016-11-10 20:20:28.692100','q5ja2Qw5IP8RETJq43vGGahB9L91oXjn',0,2,NULL,NULL,1,NULL,'Scott','Birgel',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(7,1,'alec.stapp@notebowl.com',NULL,'$2y$10$/GeZXoCspxUT4vE9lvgvhOjnQ.KALN4.RVRmhvGcvWdd4ayffvjX6',NULL,'2016-05-13 01:59:41.907205','2016-11-10 20:20:28.692100','SKXNr8e8eOSTgelgcL4W4HHizteF9zmc',0,2,NULL,NULL,1,NULL,'Alec','Stapp',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(8,1,'bob.smith@notebowl.com',NULL,'$2y$10$vaoNAqN1CFST.73KTXx4VuIYkxVb4H5F4qs/hl9aZH9XCkrxBG1vG','https://notebowl.s3.amazonaws.com/users/EYVoid6eBnSNUcyhN6J67EybnjOQNRhW/profile-picture/jspAVoL4NVR1KVBMaOGHHqQH3PVCmwqz','2016-05-13 01:59:41.980726','2016-11-10 20:20:28.692100','EYVoid6eBnSNUcyhN6J67EybnjOQNRhW',0,2,NULL,NULL,1,NULL,'Bob','Smith',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(9,1,'issac.ortega@notebowl.com',NULL,'$2y$10$4a9EQBYDGCye6VjPtfPsd.KXISe7bgoUedCn67OwUnBOvwvJT5lny',NULL,'2016-05-13 01:59:42.053595','2016-11-10 20:20:28.692100','eSpvwhe9b3dsBkHZz1Xxgx0TE9cYaF9Q',0,2,NULL,NULL,1,NULL,'Issac','Ortega',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(10,1,'aaron.ogata@notebowl.com',NULL,'$2y$10$O4xopCZRhlgDAj6P62DY5emyHEihO7pJNXkDX.4GPQeKMkKItjEVS','https://notebowl.s3.amazonaws.com/users/zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP/profile-picture/Cg5PccELp5x3y5tFarKAKDhQ2NKdLdKM','2016-05-13 01:59:42.131956','2018-08-28 00:36:42.010800','zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP',0,2,NULL,NULL,1,NULL,'Aaron','Ogata',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-08-28 00:36:42.010700',1,1,NULL),
	(11,1,'nina.iarkova@notebowl.com',NULL,'$2y$10$/JBc6YXnDBQqWRtFkG6qy.l0X3/NA8u88ut08GzBhdfF27P.rXS9i','https://notebowl.s3.amazonaws.com/users/Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC/profile-picture/PKw1Kqut3OSD8WUa10c0oSnSmyHNYrif','2016-05-13 01:59:42.214564','2018-08-28 00:24:14.230600','Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC',0,2,NULL,NULL,1,NULL,'Nina','Iarkova',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-08-28 00:24:14.230500',1,1,NULL),
	(12,1,'rachel.helmstetter@notebowl.com',NULL,'$2y$10$SXbzSG7z8Ot1ACw7zNcJa.W2niC1sbM6gBEgtYTaptqK7u7q7BoIG',NULL,'2016-05-13 01:59:42.298808','2016-11-10 20:20:28.692100','nzrHeALihLTymfkwJBsslhg0DadMFlxW',0,2,NULL,NULL,1,NULL,'Rachel','Helmstetter',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(13,1,'jose.garcia@notebowl.com',NULL,'$2y$10$chEUy4yP0USX7nuJ.oxIcOjYrdIC/QBhD56eJWW6VJdx48VMZ7L22',NULL,'2016-05-13 01:59:42.384662','2016-11-10 20:20:28.692100','XdnqLaL8eoMFFzLazUJT0yl9zoT2dx1E',0,2,NULL,NULL,1,NULL,'Jose','Garcia',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(14,1,'keith.taylor@notebowl.com',NULL,'$2y$10$80cBoPBKeoWKEmHIH1AH4uZcFkeyeQ2vhXo/WzCNT5jeC9/eiRo3q','https://notebowl.s3.amazonaws.com/users/HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3/profile-picture/sDZo4XroQICYygcvu7pNBBIby0MftYbB','2016-05-13 01:59:42.466155','2018-08-28 00:39:43.272500','HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3',0,2,NULL,NULL,1,NULL,'Keith','Taylor',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-08-28 00:39:43.272500',1,1,NULL),
	(15,1,'zedel@asu.edu',NULL,'$2y$10$rYAGI/IqVZpbNtjNxgJr5u/gcbJvZalbe0EGcgQujJiJjcT3tFvzy',NULL,'2016-05-13 01:59:42.545244','2016-11-10 20:20:28.692100','kKGeYrjclHb0s4iDeDSQISx0nKKx3S84',0,2,NULL,NULL,1,NULL,'Zachary','Edel',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(16,1,'demo-user@notebowl.com',NULL,'$2y$10$OFclDBtCIx5Cou8MR/lKm.mBUnyjArU.mm0sfFN9QkYJmUXlW/YMy',NULL,'2016-05-13 01:59:42.670308','2016-11-10 20:20:28.692100','k3SJ7WctkCFNcFAj7KumfWebx7doIieh',0,2,NULL,NULL,1,NULL,'Notebowl','Tester',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(17,1,'rmahmad@notebowl.com',NULL,'$2y$10$lq.WjdBRmPwkMOof0t3iNucXOzX83sKrW76b8cww0wCo6ElHRtoh6',NULL,'2016-05-13 01:59:42.807548','2016-11-10 20:20:28.692100','OJSU0SlF4aFknh4Six8kgbxrlTDXLFPe',0,2,NULL,NULL,1,NULL,'Rizwan','Ahmad',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(18,1,'spluta@notebowl.com',NULL,'$2y$10$w/O5TcqkCnqyV4Phn3GBPubazrkDuG8XQPrbZkX8tnotiP0DaSi.y','https://notebowl.s3.amazonaws.com/users/Eq0uKBoESBjPxuTMDtG6FsAi8CdbPEK1/profile-picture/uwFFWjZI8tlRzsG3r5vy5pUcaTvARcI3 ','2016-05-13 01:59:42.886432','2016-11-10 20:20:28.692100','Eq0uKBoESBjPxuTMDtG6FsAi8CdbPEK1',0,2,NULL,NULL,1,NULL,'Stephen','Pluta',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL);

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
