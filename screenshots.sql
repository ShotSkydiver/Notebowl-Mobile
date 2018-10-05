# ************************************************************
# Sequel Pro SQL dump
# Version 5040
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.23-log)
# Database: notebowl_development
# Generation Time: 2018-10-05 19:21:50 +0000
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `assessment_answers` WRITE;
/*!40000 ALTER TABLE `assessment_answers` DISABLE KEYS */;

INSERT INTO `assessment_answers` (`id`, `title`, `question_id`, `is_correct`, `creator_id`, `resource_key`, `created_at`, `updated_at`, `deleted_at`)
VALUES
	(1,'True',1,1,3,'l194867ea15ba47ac99648d28086a95e','2018-09-26 12:35:04.853100','2018-09-26 12:35:04.853100',NULL),
	(2,'False',2,1,3,'l1e4e00b7ac404976bd2f2c92787fd87','2018-09-26 12:35:08.917900','2018-09-26 12:35:08.917900',NULL),
	(3,'bgfbg gfbgfbbfgbg gsgf sg sfg fsg',5,1,3,'m5d789e798f4147a4b5bd719a55dfd83','2018-10-05 00:36:33.331000','2018-10-05 00:36:38.346400',NULL),
	(4,'xzcxzcxsa',6,0,3,'u3a36528c86ec43b9a15256076fca620','2018-10-05 00:37:19.264500','2018-10-05 00:37:19.264500',NULL),
	(5,'vfdvbfdg',6,0,3,'d1b7356c76d1d453888562749cf809e8','2018-10-05 00:37:21.298000','2018-10-05 00:37:21.298000',NULL),
	(6,'gtrbfbf',6,1,3,'b449ecdbc17ac4515ba99a53138f29a7','2018-10-05 00:37:23.357400','2018-10-05 00:37:25.294200',NULL),
	(7,'True',8,1,3,'ude8075842b5540259d6dafd2ccc3fcb','2018-10-05 02:29:21.772600','2018-10-05 02:29:21.772600',NULL);

/*!40000 ALTER TABLE `assessment_answers` ENABLE KEYS */;
UNLOCK TABLES;


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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `assessment_questions` WRITE;
/*!40000 ALTER TABLE `assessment_questions` DISABLE KEYS */;

INSERT INTO `assessment_questions` (`id`, `title`, `points`, `question_scheme`, `assessment_id`, `creator_id`, `resource_key`, `created_at`, `updated_at`, `deleted_at`, `description`, `extra_credit`)
VALUES
	(1,'feferwrw',10,'true_false',1,3,'jcf15cee17720464d9bed0f21bec0855','2018-09-26 12:34:58.822100','2018-09-26 12:35:04.178100',NULL,NULL,0),
	(2,'ewfewfewfw',10,'true_false',1,3,'l8adc1c73e05446639ac701a9f0759cb','2018-09-26 12:34:58.858500','2018-09-26 12:35:08.871200',NULL,NULL,0),
	(3,NULL,10,'true_false',2,3,'abc3982a59b994cb58ccc7dc89c15511','2018-09-26 21:17:14.294500','2018-10-03 07:51:25.598200','2018-10-03 07:51:25.598200',NULL,0),
	(4,NULL,10,'true_false',2,3,'me4869d78c32044a9a32eea49146a144','2018-09-26 21:17:14.345300','2018-10-03 07:51:25.648800','2018-10-03 07:51:25.648800',NULL,0),
	(5,'fgfdgdfgfdgfdggsdfg g f gf ff sg f',10.5,'free_response',3,3,'v7f0bb97fdd6846c8986dfe74f7a099f','2018-10-05 00:35:35.717000','2018-10-05 00:36:31.263600',NULL,NULL,0),
	(6,'cvsefaerevgrvadfvfdv . afd',20,'checkbox',3,3,'hfbe63019705e4f51a0f32b1625c5806','2018-10-05 00:35:35.771000','2018-10-05 00:37:16.288100',NULL,NULL,0),
	(7,'cdvgfgfdgdfgdfsgdgdf xz',30,'file_upload',3,3,'n6ff96591c0de46498d923a92f7a548c','2018-10-05 00:37:26.495400','2018-10-05 00:37:44.353600',NULL,NULL,0),
	(8,'',20,'true_false',4,3,'i5953e67314b24c3cb2b487916bf05ae','2018-10-05 02:29:01.967200','2018-10-05 02:29:15.635700',NULL,NULL,0);

/*!40000 ALTER TABLE `assessment_questions` ENABLE KEYS */;
UNLOCK TABLES;


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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `assessment_responses` WRITE;
/*!40000 ALTER TABLE `assessment_responses` DISABLE KEYS */;

INSERT INTO `assessment_responses` (`id`, `answer_id`, `assessment_id`, `submission_id`, `user_id`, `text_content`, `resource_key`, `created_at`, `updated_at`, `deleted_at`, `question_id`)
VALUES
	(1,NULL,1,1,19,'True','x1dd38a211aef4d1f9a2e19ecc9fe03a','2018-09-26 12:36:22.269100','2018-09-26 12:36:22.269100',NULL,1),
	(2,NULL,3,2,19,NULL,'t52190bf373974933b917d0e9b231db8','2018-10-05 01:56:27.421500','2018-10-05 01:56:27.421500',NULL,7),
	(3,NULL,3,2,19,'no','b6815a6fe6bb245e1a25a33c8c802a9c','2018-10-05 01:57:03.095400','2018-10-05 01:57:03.095400',NULL,5),
	(4,4,3,2,19,NULL,'h3ffae4952ffc4b1ab64b654b172897b','2018-10-05 01:57:23.278900','2018-10-05 01:57:23.278900',NULL,6),
	(5,5,3,2,19,NULL,'o8c3997348c4e4a97ba7a30815606dee','2018-10-05 01:57:25.136100','2018-10-05 01:57:25.136100',NULL,6),
	(6,NULL,3,3,14,NULL,'v33ad1bb7a1e0454e81036fa435df324','2018-10-05 02:16:20.864800','2018-10-05 02:16:20.864800',NULL,7),
	(7,NULL,3,3,14,'nope','i0e6afc5218fd43e6932243a35ce4f31','2018-10-05 02:16:31.842900','2018-10-05 02:16:32.444900',NULL,5),
	(8,4,3,3,14,NULL,'b3050b90f923b49ef90aa46a711587a7','2018-10-05 02:16:43.038300','2018-10-05 02:16:43.038300',NULL,6),
	(9,6,3,3,14,NULL,'k41d09c6a452b462192fde5f1a33bb1d','2018-10-05 02:16:44.277400','2018-10-05 02:16:44.277400',NULL,6);

/*!40000 ALTER TABLE `assessment_responses` ENABLE KEYS */;
UNLOCK TABLES;


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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `assessment_submissions` WRITE;
/*!40000 ALTER TABLE `assessment_submissions` DISABLE KEYS */;

INSERT INTO `assessment_submissions` (`id`, `assessment_id`, `user_id`, `time_started`, `time_completed`, `resource_key`, `created_at`, `updated_at`, `deleted_at`)
VALUES
	(1,1,19,'2018-09-26 12:36:20.241800',NULL,'c2be94e00f7ba4d1b983c890498999c5','2018-09-26 12:36:20.293500','2018-09-26 12:36:20.293500',NULL),
	(2,3,19,'2018-10-05 01:56:26.360300','2018-10-05 01:57:47.320400','ma9d9efcd61fa430cacafae036fa063a','2018-10-05 01:56:26.430700','2018-10-05 01:57:47.351500',NULL),
	(3,3,14,'2018-10-05 02:16:19.500399','2018-10-05 02:16:56.058800','le7b4840f8dee4b93a9026013d84cd59','2018-10-05 02:16:19.516800','2018-10-05 02:16:56.073000',NULL);

/*!40000 ALTER TABLE `assessment_submissions` ENABLE KEYS */;
UNLOCK TABLES;


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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `assessments` WRITE;
/*!40000 ALTER TABLE `assessments` DISABLE KEYS */;

INSERT INTO `assessments` (`id`, `title`, `permalink`, `resource_key`, `description`, `attempts`, `time_limit`, `grace_period`, `parent_id`, `creator_id`, `category_id`, `available_date`, `due_date`, `result_scheme`, `question_scheme`, `partial_credit`, `created_at`, `updated_at`, `deleted_at`, `default_question_points`, `answer_order`, `question_order`, `parent_type`, `locked`, `action_mode`, `grade_scheme`, `grades_published`)
VALUES
	(1,'The Night Sky Quiz','the-night-sky-quiz','o15e7d4535b8146ac90a7b1ed6d33b18','Astronomy is the oldest science, and its history shows a growing realization of our insignificant status in a vast and ancient universe.\n\nComplete the quiz and submit for grading, 10 points per question.',1,0,0,3,3,13,'2018-09-26 12:34:00','2018-11-01 06:59:00','score','true_false',0,'2018-09-26 12:34:57.991600','2018-10-05 02:39:10.348900',NULL,10,'normal','normal','App\\Models\\Course',0,NULL,'Percentage',1),
	(2,'nil due','nil-due','r35c03c2c16b4420d89db80a448d720f','wewewe',1,0,0,2,3,5,NULL,NULL,'score','true_false',0,'2018-09-26 21:17:13.559700','2018-10-03 07:51:25.662600','2018-10-03 07:51:25.662600',10,'normal','normal','App\\Models\\Course',0,NULL,'Points',1),
	(3,'assess respons','assess-respons','v2fbb38db1ac9479c80084721f160830','okokokkkkk',1,0,0,2,3,6,'2018-10-05 00:35:00','2018-10-12 06:59:00','score','free_response',0,'2018-10-05 00:35:34.995200','2018-10-05 00:37:50.551200',NULL,0,'normal','normal','App\\Models\\Course',0,NULL,'Percentage',1),
	(4,'unpubzzed','unpubzzed','c8f0bc5d5fba14af08786b090b45454f','kihkiukui',1,0,0,2,3,5,NULL,NULL,'score','radio',0,'2018-10-05 02:28:41.919400','2018-10-05 02:28:41.919400',NULL,0,'normal','normal','App\\Models\\Course',0,NULL,'Points',1);

/*!40000 ALTER TABLE `assessments` ENABLE KEYS */;
UNLOCK TABLES;


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
  UNIQUE KEY `assignment_group_users_resource_key_unique` (`resource_key`),
  KEY `assignment_group_users_deleted_at_index` (`deleted_at`),
  KEY `assignment_group_users_parent_id_index` (`parent_id`),
  KEY `assignment_group_users_parent_type_index` (`parent_type`),
  KEY `assignment_group_users_user_id_index` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `assignment_group_users` WRITE;
/*!40000 ALTER TABLE `assignment_group_users` DISABLE KEYS */;

INSERT INTO `assignment_group_users` (`id`, `parent_id`, `user_id`, `resource_key`, `created_at`, `updated_at`, `deleted_at`, `parent_type`)
VALUES
	(1,1,19,'a5f0b21877203401995a8166a7edfb80','2018-09-26 10:52:41.813800','2018-09-26 10:52:41.813800',NULL,'App\\Models\\AssignmentGroup');

/*!40000 ALTER TABLE `assignment_group_users` ENABLE KEYS */;
UNLOCK TABLES;


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
  UNIQUE KEY `assignment_groups_resource_key_unique` (`resource_key`),
  KEY `assignment_groups_deleted_at_index` (`deleted_at`),
  KEY `assignment_groups_locked_index` (`locked`),
  KEY `assignment_groups_parent_id_index` (`parent_id`),
  KEY `assignment_groups_parent_type_index` (`parent_type`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `assignment_groups` WRITE;
/*!40000 ALTER TABLE `assignment_groups` DISABLE KEYS */;

INSERT INTO `assignment_groups` (`id`, `parent_id`, `name`, `resource_key`, `created_at`, `updated_at`, `deleted_at`, `parent_type`, `locked`)
VALUES
	(1,4,'Group 1','u7129256ba9ac406bab45cb471a1ec48','2018-08-28 00:18:18.943400','2018-09-26 10:52:53.150600',NULL,'App\\Models\\Assignment',1),
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
  `discussion_visibility` enum('always','after_one','after_min') NOT NULL DEFAULT 'always',
  PRIMARY KEY (`id`),
  UNIQUE KEY `assignments_resource_key_unique` (`resource_key`),
  UNIQUE KEY `assignments_permalink_course_id_deleted_at_unique` (`permalink`,`parent_id`,`deleted_at`),
  KEY `assignments_course_id_deleted_at_index` (`parent_id`,`deleted_at`),
  KEY `assignments_course_id_index` (`parent_id`),
  KEY `assignments_parent_id_index` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `assignments` WRITE;
/*!40000 ALTER TABLE `assignments` DISABLE KEYS */;

INSERT INTO `assignments` (`id`, `title`, `desc`, `due_date`, `available_date`, `points`, `parent_id`, `creator_id`, `grade_only`, `category_id`, `submission_late`, `permalink`, `type`, `group_max`, `min_num_posts`, `min_num_comments`, `word_count_posts`, `word_count_comments`, `posts_required`, `comments_required`, `created_at`, `updated_at`, `resource_key`, `deleted_at`, `grades_published`, `grader_scheme`, `google_convert_submissions`, `upload_restrict_extensions`, `grade_scheme`, `submission_scheme`, `anonymous_posting`, `discussion_visibility`)
VALUES
	(2,'Space Freefall Discussion Board','Watch the video and leave ONE post on the discussion board and ONE comment for  25 points. ** Minimum of 40 words for your post and a minimum of 10 words on a comment for full credit.','2018-10-19 06:59:00','2018-08-28 00:15:00',25,3,1,0,11,1,'space-freefall-discussion','Individual',2,0,0,0,0,'Recommended','Recommended','2018-08-28 00:15:59.479800','2018-09-26 10:47:54.186900','zcda01b14200644a79a16126992f807a',NULL,1,'Professor',0,NULL,'Points','Discussion Board',0,'always'),
	(3,'Lunar Travel Topic Paper','For this assignment, each of you will be writing a 4-6 page research paper outlining the US and Soviet attempts to land on the moon, detailing the roadblocks in their way and the impact that the 1969 lunar landing has had on our modern understanding of astronomy. Use at least three scholarly and two non-scholarly sources.','2018-10-19 06:59:00','2018-08-28 00:16:00',50,3,1,0,11,1,'lunar-travel-topic-paper','Individual',2,0,0,0,0,'Recommended','Recommended','2018-08-28 00:16:46.982400','2018-09-26 10:55:13.133000','h1e210e3ce3aa43a5b3fde8547648cce',NULL,1,'Professor',0,NULL,'(In)complete','File Submission',0,'always'),
	(4,'Group Overnight Starwatch','The purpose of this project is to get you to take note of the apparent motion of the constellations with\nrespect to the horizon. The diurnal motion is observed by watching a constellation through one night.\nKeep in mind that the “time of day” is the position of the sun with respect to YOU.\n\nDo this on the first CLEAR NIGHT!! It can cloud up for weeks & weeks!!!\n\n** See attached handout for project details.\n** Attach a photo below for proof of your group stargazing.\n\nWe will discuss in class your experience after winter break.','2018-11-08 06:59:00','2018-08-28 00:16:00',30,3,1,0,11,1,'group-overnight-starwatch','Group',3,0,0,0,0,'Recommended','Recommended','2018-08-28 00:18:18.896200','2018-09-26 19:51:26.936800','d74943de54eef49108523c16ac493e86',NULL,1,'Professor',0,NULL,'Percentage','File Submission',0,'always'),
	(5,'The Night Sky Quiz','Astronomy is the oldest science, and its history shows a growing realization of our insignificant status in a vast and ancient universe.\n\nComplete the quiz and submit for grading, 10 points per question.','2018-11-16 06:59:00','2018-11-09 00:18:00',30,3,1,0,13,0,'the-night-sky-quiz','Individual',2,0,0,0,0,'Recommended','Recommended','2018-08-28 00:19:01.029000','2018-09-26 12:35:37.826700','ud7c1186e1a44432a963cdacd4368e4d','2018-09-26 12:35:37.826700',1,'Professor',0,NULL,'Percentage','No Submission',0,'always'),
	(6,'Intro to Astronomy Exam','A continuing revolution in telescope design and construction is giving astronomers an unprecedented set of tools for exploring the universe.\n\nThis exam will be graded before spring break, please ask if any questions!','2018-11-01 06:59:00','2018-08-28 00:19:00',40,3,1,0,12,0,'intro-to-astronomy-exam','Individual',2,0,0,0,0,'Recommended','Recommended','2018-08-28 00:19:55.745200','2018-10-05 02:36:45.294000','c40d8a7ce79894a879ee92d410052626',NULL,1,'Professor',0,NULL,'Letter Grade','No Submission',0,'always'),
	(7,'Mission to Mars','Review the SpaceX Mission to Mars and write up a one-page paper with your opinions on the pros and cons of this mission. And your thoughts on when it is possible.','2018-12-06 06:59:00','2018-08-28 00:20:00',50,3,1,0,14,0,'mission-to-mars','Individual',2,0,0,0,0,'Recommended','Recommended','2018-08-28 00:20:29.855900','2018-10-05 02:39:40.258500','lf1f97d5feb6746769401727a7d7988e',NULL,1,'Professor',0,NULL,'Letter Grade','File Submission',0,'always'),
	(8,'Discussion Post #1','Watch this video about the voting rights and representation of U.S. Territories (Guam, American Samoan, and Puerto Rico). Afterwards, share your thoughts on what you learned by posting and commenting on the discussion board below.','2018-11-01 06:59:00','2018-09-26 19:51:00',30,2,3,0,5,0,'discussion-post--1','Individual',2,3,0,0,0,'Recommended','Recommended','2018-09-26 19:53:20.658900','2018-10-03 07:52:13.799800','oc845a1e5fc944b82ac6bdc91d7b7155','2018-10-03 07:52:13.799800',1,'Professor',0,NULL,'Percentage','Discussion Board',0,'always'),
	(9,'American History Quiz on Chapter 1&2','This is the first History Quiz for the class and will cover chapter\'s 1 & 2 on how the U.S. government was formed and the American Revolution.','2018-10-04 06:59:00','2018-09-26 19:53:00',40,4,3,0,17,0,'american-history-quiz-on-','Individual',2,0,0,0,0,'Recommended','Recommended','2018-09-26 19:54:01.966600','2018-09-26 19:54:01.966600','h2c18ba321e834175838d08ef18f5573',NULL,1,'Professor',0,NULL,'Percentage','No Submission',0,'always'),
	(10,'not published','wefwef','2018-10-04 06:59:00','2018-09-26 21:14:00',80,2,3,0,5,0,'not-published','Individual',2,0,0,0,0,'Recommended','Recommended','2018-09-26 21:14:20.415100','2018-10-03 07:53:23.429700','z51235fd8ecd340949043e24b101c449','2018-10-03 07:53:23.429700',0,'Professor',0,NULL,'Points','No Submission',0,'always'),
	(11,'not availavble yet','scvd','2018-11-01 06:59:00','2018-10-17 21:14:00',30,2,3,0,5,0,'not-availavble-yet','Individual',2,0,0,0,0,'Recommended','Recommended','2018-09-26 21:14:56.682800','2018-10-03 07:52:33.938400','iddef06c406e74b9ea41a067887638f8','2018-10-03 07:52:33.938400',1,'Professor',0,NULL,'Points','No Submission',0,'always'),
	(12,'discussz boarsze 2p 2c w/ counts','Hejrhjerhjehrjke whrjkh rhejkrhkwjerh. khjkre','2018-12-13 07:04:00','2018-07-13 07:04:00',60,2,3,0,5,0,'discussz-boarsze','Individual',2,2,2,200,200,'Required','Required','2018-10-03 07:49:02.511399','2018-10-03 08:03:37.495700','b1c2b15eb6a08475abad26157eec08bb',NULL,1,'Professor',0,NULL,'Points','Discussion Board',0,'always'),
	(13,'discussz boarsze 2 coms','Hejrhjerhjehrjke whrjkh rhejkrhkwjerhdvsfd df fs . khjkre','2018-12-13 07:04:00','2018-07-13 07:04:00',80,2,3,0,5,0,'discussz-boarsze-only-com','Individual',2,0,2,0,0,'Recommended','Recommended','2018-10-03 07:57:50.686800','2018-10-03 08:03:53.575600','pa835c2a277fc47bc9b711b946d6347c',NULL,1,'Professor',0,NULL,'Letter Grade','Discussion Board',0,'always'),
	(14,'discussz boarsze only 1 post','Hejrhjerhjehrjke whrjkh rhejkrhkwjdefefeferhdvsfd df fs . khjkre','2018-12-13 07:04:23','2018-10-02 07:04:23',45,2,3,0,5,1,'discussz-boarsze-only-1-p','Individual',2,1,0,0,0,'Recommended','Recommended','2018-10-03 08:01:45.002700','2018-10-03 08:01:45.002700','dbef7c72a5f5847bb8bf5408b656a22e',NULL,1,'Professor',0,NULL,'Letter Grade','Discussion Board',0,'always'),
	(15,'discussz boarsze no reqs','whewe rgrmntkr. grt ththt t ','2018-12-13 07:04:23','2018-10-02 07:04:23',70,2,3,0,5,0,'discussz-boarsze-no-reqs','Individual',2,0,0,0,0,'Recommended','Recommended','2018-10-03 08:02:39.595300','2018-10-03 08:02:39.595300','d57244187ffb74ab6ad9ae2de335906a',NULL,1,'Professor',0,NULL,'Percentage','Discussion Board',0,'always'),
	(16,'discussz boarsze 2 postsz','whewe rgrmntkr. grt ththt t hbjhgjh hjb hhjj ','2018-12-13 07:04:23','2018-10-02 07:04:23',65,2,3,0,5,0,'discussz-boarsze-2-postsz','Individual',2,2,0,0,0,'Recommended','Recommended','2018-10-03 08:05:00.649700','2018-10-03 08:05:00.649700','h1c82abfa37ba4d89a5470658c61df9d',NULL,1,'Professor',0,NULL,'Points','Discussion Board',0,'always'),
	(17,'esflkmself','wefefg','2018-10-25 06:59:00','2018-10-17 21:39:00',59,2,3,0,5,0,'esflkmself','Individual',2,0,0,0,0,'Recommended','Recommended','2018-10-04 21:39:42.535700','2018-10-04 21:41:38.555900','k65dd75f16ec346a099862ce2ddf7267',NULL,1,'Professor',0,NULL,'Points','No Submission',0,'always'),
	(18,'file subbb baby','v btdgcx','2018-10-12 06:59:00','2018-10-04 22:35:00',60,2,3,0,5,0,'file-subbb-baby','Individual',2,0,0,0,0,'Recommended','Recommended','2018-10-04 22:36:07.012900','2018-10-04 22:36:07.012900','k05314b60554f48e3b9ef6cff7400003',NULL,1,'Professor',0,NULL,'Percentage','File Submission',0,'always'),
	(19,'file sub w reqs','hhiahihhih','2018-10-12 06:59:00','2018-10-04 22:41:00',40,2,3,0,5,0,'file-sub-w-reqs','Individual',2,0,0,0,0,'Recommended','Recommended','2018-10-04 22:42:13.520800','2018-10-04 22:42:13.520800','sa1122383b4304145b0336aeb49d8e5d',NULL,1,'Professor',0,'jpg','Points','File Submission',0,'always');

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
  `related_id` int(10) unsigned DEFAULT NULL,
  `related_type` varchar(255) DEFAULT NULL,
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
  KEY `attachments_file_name_index` (`file_name`),
  KEY `attachments_related_id_related_type_index` (`related_id`,`related_type`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `attachments` WRITE;
/*!40000 ALTER TABLE `attachments` DISABLE KEYS */;

INSERT INTO `attachments` (`id`, `attachment_name`, `file_name`, `location`, `status`, `owner_id`, `parent_id`, `parent_type`, `available_date`, `view_scheme`, `created_at`, `updated_at`, `resource_key`, `attachment_scheme`, `size`, `type`, `deleted_at`, `related_id`, `related_type`)
VALUES
	(1,'Explorations: Introduction to Astronomy',NULL,'9780077345099','completed',1,3,'App\\Models\\Course','2018-08-28 00:05:16',NULL,'2018-08-28 00:05:20.787900','2018-08-28 00:05:20.787900','vfc60395a035d41069bf6f8263557350','Book',0,NULL,NULL,NULL,NULL),
	(2,'https://medium.com/s/story/why-a-great-customer-experience-can-be-even-more-important-than-the-product-d347e4dd3f6e',NULL,'https://medium.com/s/story/why-a-great-customer-experience-can-be-even-more-important-than-the-product-d347e4dd3f6e','completed',3,3,'App\\Models\\User',NULL,NULL,'2018-09-26 10:31:37.015000','2018-09-26 10:31:37.015000','o3dc3c351a35e48d9833efe240cdf63a','External',0,NULL,NULL,NULL,NULL),
	(3,'IMG_0066.JPG','IMG_0066.JPG','files/1538692630/ve98b146c620d45538d4ebcce299cd107c689d617e7fe4f528a0424099dee242/pmAFSBmgui1sw0njI9UIcxue63oUIT5Ct3YMzcIh.jpeg.JPG','completed',19,4,'App\\Models\\Submission',NULL,NULL,'2018-10-04 22:37:15.616700','2018-10-04 22:37:15.616700','af64e0f3983004e03a0af5f31839ee20','S3',70874,'image/jpeg',NULL,NULL,NULL),
	(4,'chad.jpg','chad.jpg','files/1538705238/ve2402f8e63fd4b239ae912e3da5f69d34f675086ccc74e07abe3d1eee712a2c/Za5bwkgE1ma0xuw7fXcbaVzaArVRQfE1JmPd7UGS.jpeg.jpg','completed',19,8,'App\\Models\\Submission',NULL,NULL,'2018-10-05 02:07:50.716600','2018-10-05 02:07:50.716600','k7385d4f06a1b46f793b4ab844876692','S3',687306,'image/jpeg',NULL,NULL,NULL),
	(5,'chad.jpg','chad.jpg','files/1538705809/we437c6fbb61641399088a8acdf9a8971b25e8eda5875478983814cd0746b8b4/Cohi2x2KGo7VHuc7o4YvwK1kHwAlvWly4YqM9GiP.jpeg.jpg','completed',14,6,'App\\Models\\AssessmentResponse',NULL,NULL,'2018-10-05 02:16:51.772800','2018-10-05 02:16:51.772800','t304b9f9264484f07a3fe0f88bc9c860','S3',687306,'image/jpeg',NULL,NULL,NULL);

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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4;

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
  `owner_id` int(11) NOT NULL,
  `owner_type` varchar(255) NOT NULL,
  `related_id` int(11) NOT NULL,
  `related_type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `comments_resource_key_unique` (`resource_key`),
  KEY `comments_post_id_deleted_at_index` (`post_id`,`deleted_at`),
  KEY `comments_post_id_index` (`post_id`),
  KEY `comments_user_id_index` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;

INSERT INTO `comments` (`id`, `user_id`, `post_id`, `text`, `created_at`, `updated_at`, `resource_key`, `deleted_at`, `edited_at`, `anonymous`, `owner_id`, `owner_type`, `related_id`, `related_type`)
VALUES
	(1,14,1,'Thanks for sharing! This is nuts!','2018-08-28 00:23:09.125596','2018-08-28 00:23:09.125596','jf1833e8545654e0abdbd81b7a422d4b',NULL,NULL,0,3,'App\\Models\\Course',3,'App\\Models\\Course'),
	(2,10,2,'I will be at the library after school going over the radiation chapter. Let\'s team up!','2018-08-28 00:23:50.942000','2018-08-28 00:23:50.942000','ff9c7c33fcb5d4d49b66cc8d2f9cdff6',NULL,NULL,0,3,'App\\Models\\Course',3,'App\\Models\\Course'),
	(3,11,2,'I will be as well!','2018-08-28 00:24:25.483000','2018-08-28 00:24:25.483000','aece9a9845f6b47d481c171b95cba06e',NULL,NULL,0,3,'App\\Models\\Course',3,'App\\Models\\Course'),
	(4,2,3,'I\'ll send them to you now!','2018-08-28 00:25:35.906600','2018-08-28 00:25:35.906600','sf822f7043fd3412cb1c32b818ac8258',NULL,NULL,0,3,'App\\Models\\Course',3,'App\\Models\\Course'),
	(5,14,4,'In a Newtonian black hole, infinite energy is released in the collapse that forms the black hole. For general relativistic black holes, finite energy is released in the collapse that forms the black hole.','2018-08-28 00:26:12.729800','2018-08-28 00:26:12.729800','k65fbc2e78d884ff8bed9cd133115b8c',NULL,NULL,0,3,'App\\Models\\Course',3,'App\\Models\\Course'),
	(6,14,2,'Thanks guys, let\'s do it!','2018-08-28 00:26:30.262700','2018-08-28 00:26:30.262700','t937f86900159428eb470f6b13be8d09',NULL,NULL,0,3,'App\\Models\\Course',3,'App\\Models\\Course'),
	(7,3,4,'Also, the Newtonian black hole involves no disturbance to space and time. Compared to general relativistic black holes where there are causally isolated regions of space and time.','2018-08-28 00:27:35.711900','2018-08-28 00:27:35.711900','zb0f9f713f87c4daf995245fbe004f92',NULL,NULL,0,3,'App\\Models\\Course',3,'App\\Models\\Course'),
	(8,10,4,'This link will help you determine the difference between the two black holes formations!\nhttp://www.pitt.edu/~jdnorton/teaching/HPS_0410/chapters/black_holes/#Newtonian1','2018-08-28 00:29:04.204100','2018-08-28 00:29:11.033200','hc16cc4a29bdf4ed79838367aa4b5aec',NULL,'2018-08-28 00:29:11.018700',0,3,'App\\Models\\Course',3,'App\\Models\\Course'),
	(9,3,7,'www.usnews.com/news/national-news/articles/2018-06-19/is-leaving-the-un-human-rights-council-a-big-deal','2018-09-26 10:33:13.840300','2018-09-26 10:33:21.776100','uceefd7ae300741839fb0e6a888c1209','2018-09-26 10:33:21.776100',NULL,0,4,'App\\Models\\Course',4,'App\\Models\\Course'),
	(10,19,6,'Social media plays a huge impact on politics. For example, Donald Trump uses Twitter as a way to easily voice his opinion to the public to generate a lot of controversy on particular issues and topics.','2018-09-26 10:37:26.421300','2018-09-26 10:37:49.387300','if1705eef7d8c487587f2a5f947f4c53','2018-09-26 10:37:49.387300',NULL,0,4,'App\\Models\\Course',4,'App\\Models\\Course'),
	(11,19,6,'Social media plays a huge impact on politics. For example, Donald Trump uses Twitter as a way to easily voice his opinion to the public to generate a lot of controversy on particular issues and topics.','2018-09-26 10:37:57.395000','2018-09-26 10:37:57.395000','e028722bd85ce4ae5b9330e0d709a998',NULL,NULL,0,4,'App\\Models\\Course',4,'App\\Models\\Course'),
	(12,3,6,'Exactly! It works perfectly!','2018-09-26 19:54:31.317300','2018-09-26 19:54:31.317300','v01b4ab8266dd46e39558b1728a37c33',NULL,NULL,0,4,'App\\Models\\Course',4,'App\\Models\\Course'),
	(13,19,9,'this is the firs to comment!!!','2018-10-03 08:17:02.750700','2018-10-03 08:17:02.750700','j7ea86c3ae0094a15886de7c9fdc859f',NULL,NULL,0,2,'App\\Models\\Course',13,'App\\Models\\Assignment'),
	(14,14,9,'look it a different users comment on a discussion board post','2018-10-03 08:19:22.004000','2018-10-03 08:19:22.004000','s1ed0fb8f0b75463ba1f8320ea83fffd',NULL,NULL,0,2,'App\\Models\\Course',13,'App\\Models\\Assignment'),
	(15,14,10,'let\'s complete this yo','2018-10-03 08:19:46.310300','2018-10-03 08:19:46.310300','k14ee90fac6af48ceb250e9413e76c36',NULL,NULL,0,2,'App\\Models\\Course',13,'App\\Models\\Assignment'),
	(16,14,12,'and a comment just for good measure','2018-10-03 08:20:31.143700','2018-10-03 08:20:31.143700','oa148da70eb4c448c8237b5653ca089e',NULL,NULL,0,2,'App\\Models\\Course',15,'App\\Models\\Assignment'),
	(17,14,13,'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In sagittis vitae turpis non aliquet. Nunc ac vehicula leo. Ut placerat efficitur posuere. Nunc lorem velit, ultricies volutpat justo ut, consequat ultrices nisi. Quisque sit amet feugiat mi. Nullam viverra lobortis faucibus. Sed volutpat placerat lorem et congue. Nunc fermentum iaculis lorem, sed facilisis mi efficitur consequat. Sed magna elit, facilisis nec elit non, gravida egestas justo. Ut eleifend sem a turpis posuere, ut varius est vulputate. Proin et rhoncus augue. Praesent vel ante lacus. Pellentesque ultrices et tellus nec dignissim. Vivamus ac aliquam massa, a tempus lorem.\n\nUt sed varius erat. Aenean quis turpis a metus tristique hendrerit ut sed ipsum. Suspendisse ac arcu gravida, tempus libero lacinia, sollicitudin ex. In ut tortor dignissim, mattis elit quis, volutpat risus. Donec id nulla diam. Curabitur nec ex sit amet leo malesuada mattis in in sem. Sed aliquam molestie tellus in faucibus. Suspendisse scelerisque arcu dui, non tincidunt nibh imperdiet volutpat. Morbi interdum quis nibh a interdum. Duis ullamcorper arcu sed ex viverra, eget scelerisque orci malesuada. Phasellus a cursus velit. Proin mi arcu, tincidunt sed sagittis nec, semper nec turpis. Etiam quis eros eu lorem luctus sodales. Aliquam nec nulla ullamcorper, semper urna pretium, tristique massa.\n\nInteger eget vehicula metus. Nam mollis, nulla nec finibus tempor, magna dolor accumsan massa, et facilisis lorem quam eleifend nibh. Phasellus dolor enim, efficitur sit.','2018-10-03 08:21:49.791800','2018-10-03 08:21:49.791800','s42734c9c1b4f4b30b19dfd6f1c149ad',NULL,NULL,0,2,'App\\Models\\Course',12,'App\\Models\\Assignment'),
	(18,14,14,'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In sagittis vitae turpis non aliquet. Nunc ac vehicula leo. Ut placerat efficitur posuere. Nunc lorem velit, ultricies volutpat justo ut, consequat ultrices nisi. Quisque sit amet feugiat mi. Nullam viverra lobortis faucibus. Sed volutpat placerat lorem et congue. Nunc fermentum iaculis lorem, sed facilisis mi efficitur consequat. Sed magna elit, facilisis nec elit non, gravida egestas justo. Ut eleifend sem a turpis posuere, ut varius est vulputate. Proin et rhoncus augue. Praesent vel ante lacus. Pellentesque ultrices et tellus nec dignissim. Vivamus ac aliquam massa, a tempus lorem.\n\nUt sed varius erat. Aenean quis turpis a metus tristique hendrerit ut sed ipsum. Suspendisse ac arcu gravida, tempus libero lacinia, sollicitudin ex. In ut tortor dignissim, mattis elit quis, volutpat risus. Donec id nulla diam. Curabitur nec ex sit amet leo malesuada mattis in in sem. Sed aliquam molestie tellus in faucibus. Suspendisse scelerisque arcu dui, non tincidunt nibh imperdiet volutpat. Morbi interdum quis nibh a interdum. Duis ullamcorper arcu sed ex viverra, eget scelerisque orci malesuada. Phasellus a cursus velit. Proin mi arcu, tincidunt sed sagittis nec, semper nec turpis. Etiam quis eros eu lorem luctus sodales. Aliquam nec nulla ullamcorper, semper urna pretium, tristique massa.\n\nInteger eget vehicula metus. Nam mollis, nulla nec finibus tempor, magna dolor accumsan massa, et facilisis lorem quam eleifend nibh. Phasellus dolor enim, efficitur sit.','2018-10-03 08:21:57.481800','2018-10-03 08:21:57.481800','i88c4cbbc552a4a53a86d251761aeaed',NULL,NULL,0,2,'App\\Models\\Course',12,'App\\Models\\Assignment'),
	(19,14,17,'surprise unexpected comment','2018-10-03 08:23:55.565200','2018-10-03 08:23:55.565200','hfd0441a00241495e9e0a20ed48217b2',NULL,NULL,0,2,'App\\Models\\Course',14,'App\\Models\\Assignment'),
	(20,19,10,'finisshed','2018-10-03 08:46:04.344400','2018-10-03 08:46:04.344400','q6e40af66d73444ecbfc1b54f7f73dd7',NULL,NULL,0,2,'App\\Models\\Course',13,'App\\Models\\Assignment'),
	(21,3,22,'nah dude','2018-10-03 08:55:26.077700','2018-10-03 08:55:26.077700','q76ee6d64371d4d7492f0a65e0690b3c',NULL,NULL,0,2,'App\\Models\\Course',14,'App\\Models\\Assignment'),
	(22,3,17,'fam bae goals','2018-10-03 08:55:39.658900','2018-10-03 08:55:39.658900','i4fda3093739147229470a584bfe3da2',NULL,NULL,0,2,'App\\Models\\Course',14,'App\\Models\\Assignment'),
	(23,19,13,'jesus christ wtf','2018-10-03 11:57:20.828900','2018-10-03 11:57:20.828900','re1bc14bbf9444cce88950c7ed211ca2',NULL,NULL,0,2,'App\\Models\\Course',12,'App\\Models\\Assignment'),
	(24,19,6,'it a me','2018-10-03 17:28:05.276400','2018-10-03 17:28:05.276400','o97bcfdd8586b42ec9c923066439b2b0',NULL,NULL,0,4,'App\\Models\\Course',4,'App\\Models\\Course'),
	(25,19,6,'hey hi','2018-10-03 17:28:31.335100','2018-10-03 17:28:31.335100','bda0be87db45f45b2a08c9aa569058a3',NULL,NULL,0,4,'App\\Models\\Course',4,'App\\Models\\Course'),
	(26,19,19,'heloo lhigi','2018-10-03 17:30:28.206600','2018-10-03 17:30:28.206600','t1d078f63f6594cadad7931b33e773d0',NULL,NULL,0,2,'App\\Models\\Course',12,'App\\Models\\Assignment'),
	(27,14,24,'ok','2018-10-03 18:24:14.959700','2018-10-03 18:24:14.959700','aef78920f7d214f459af9696a0022094',NULL,NULL,0,2,'App\\Models\\Course',12,'App\\Models\\Assignment'),
	(28,11,26,'try again','2018-10-03 19:43:30.707100','2018-10-03 19:43:30.707100','l57bf5ef0193e4867b2fe5416dadef3e',NULL,NULL,0,2,'App\\Models\\Course',16,'App\\Models\\Assignment'),
	(29,19,9,'3 commenr','2018-10-04 22:21:26.755200','2018-10-04 22:21:26.755200','lf1453fefe0e64e8e96d50a6b6732d8d',NULL,NULL,0,2,'App\\Models\\Course',13,'App\\Models\\Assignment'),
	(30,19,28,'fukl','2018-10-04 22:24:26.747600','2018-10-04 22:24:26.747600','u081d07c4125149be93cd134f746f1ad',NULL,NULL,0,2,'App\\Models\\Course',12,'App\\Models\\Assignment'),
	(31,19,28,'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In sagittis vitae turpis non aliquet. Nunc ac vehicula leo. Ut placerat efficitur posuere. Nunc lorem velit, ultricies volutpat justo ut, consequat ultrices nisi. Quisque sit amet feugiat mi. Nullam viverra lobortis faucibus. Sed volutpat placerat lorem et congue. Nunc fermentum iaculis lorem, sed facilisis mi efficitur consequat. Sed magna elit, facilisis nec elit non, gravida egestas justo. Ut eleifend sem a turpis posuere, ut varius est vulputate. Proin et rhoncus augue. Praesent vel ante lacus. Pellentesque ultrices et tellus nec dignissim. Vivamus ac aliquam massa, a tempus lorem.\n\nUt sed varius erat. Aenean quis turpis a metus tristique hendrerit ut sed ipsum. Suspendisse ac arcu gravida, tempus libero lacinia, sollicitudin ex. In ut tortor dignissim, mattis elit quis, volutpat risus. Donec id nulla diam. Curabitur nec ex sit amet leo malesuada mattis in in sem. Sed aliquam molestie tellus in faucibus. Suspendisse scelerisque arcu dui, non tincidunt nibh imperdiet volutpat. Morbi interdum quis nibh a interdum. Duis ullamcorper arcu sed ex viverra, eget scelerisque orci malesuada. Phasellus a cursus velit. Proin mi arcu, tincidunt sed sagittis nec, semper nec turpis. Etiam quis eros eu lorem luctus sodales. Aliquam nec nulla ullamcorper, semper urna pretium, tristique massa.\n\nInteger eget vehicula metus. Nam mollis, nulla nec finibus tempor, magna dolor accumsan massa, et facilisis lorem quam eleifend nibh. Phasellus dolor enim, efficitur sit.','2018-10-04 22:24:35.897000','2018-10-04 22:24:35.897000','p1986d0643a624981b4a71a10aaea9f1',NULL,NULL,0,2,'App\\Models\\Course',12,'App\\Models\\Assignment'),
	(32,19,23,'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In sagittis vitae turpis non aliquet. Nunc ac vehicula leo. Ut placerat efficitur posuere. Nunc lorem velit, ultricies volutpat justo ut, consequat ultrices nisi. Quisque sit amet feugiat mi. Nullam viverra lobortis faucibus. Sed volutpat placerat lorem et congue. Nunc fermentum iaculis lorem, sed facilisis mi efficitur consequat. Sed magna elit, facilisis nec elit non, gravida egestas justo. Ut eleifend sem a turpis posuere, ut varius est vulputate. Proin et rhoncus augue. Praesent vel ante lacus. Pellentesque ultrices et tellus nec dignissim. Vivamus ac aliquam massa, a tempus lorem.\n\nUt sed varius erat. Aenean quis turpis a metus tristique hendrerit ut sed ipsum. Suspendisse ac arcu gravida, tempus libero lacinia, sollicitudin ex. In ut tortor dignissim, mattis elit quis, volutpat risus. Donec id nulla diam. Curabitur nec ex sit amet leo malesuada mattis in in sem. Sed aliquam molestie tellus in faucibus. Suspendisse scelerisque arcu dui, non tincidunt nibh imperdiet volutpat. Morbi interdum quis nibh a interdum. Duis ullamcorper arcu sed ex viverra, eget scelerisque orci malesuada. Phasellus a cursus velit. Proin mi arcu, tincidunt sed sagittis nec, semper nec turpis. Etiam quis eros eu lorem luctus sodales. Aliquam nec nulla ullamcorper, semper urna pretium, tristique massa.\n\nInteger eget vehicula metus. Nam mollis, nulla nec finibus tempor, magna dolor accumsan massa, et facilisis lorem quam eleifend nibh. Phasellus dolor enim, efficitur sit.','2018-10-04 22:24:50.512100','2018-10-04 22:24:50.512100','r3760e807c50a4e61b863d4d6b67c8c4',NULL,NULL,0,2,'App\\Models\\Course',12,'App\\Models\\Assignment');

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
  `grade_scheme` varchar(255) NOT NULL DEFAULT 'round',
  `grade_base` varchar(255) NOT NULL DEFAULT 'percent',
  `grade_precision` int(11) NOT NULL DEFAULT '1',
  `grade_curve_amount` double NOT NULL DEFAULT '0',
  `paywall` tinyint(1) NOT NULL DEFAULT '0',
  `published` tinyint(1) NOT NULL DEFAULT '0',
  `profile_picture` varchar(255) DEFAULT NULL,
  `grade_scale` varchar(255) DEFAULT NULL,
  `course_tab_enabled_about_observer` tinyint(1) NOT NULL DEFAULT '1',
  `course_tab_enabled_assignments_observer` tinyint(1) NOT NULL DEFAULT '1',
  `course_tab_enabled_documents_observer` tinyint(1) NOT NULL DEFAULT '1',
  `course_tab_enabled_grades_observer` tinyint(1) NOT NULL DEFAULT '0',
  `course_tab_enabled_roster_observer` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `courses_resource_key_unique` (`resource_key`),
  UNIQUE KEY `courses_permalink_unique` (`permalink`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;

INSERT INTO `courses` (`id`, `university_id`, `term_id`, `name`, `subject`, `number`, `permalink`, `available_date`, `end_date`, `enrollment_close_date`, `archive_date`, `units`, `use_weighted_grades`, `created_at`, `updated_at`, `resource_key`, `deleted_at`, `use_drop_lowest`, `type`, `location`, `description`, `invite_group_id`, `price`, `download_restrict_assessments`, `download_restrict_assignments`, `download_restrict_bulletin`, `download_restrict_documents`, `download_restrict_submissions`, `download_restrict_extensions`, `course_tab_enabled_about`, `course_tab_enabled_about_t_a`, `course_tab_enabled_about_student`, `course_tab_enabled_assignments`, `course_tab_enabled_assignments_t_a`, `course_tab_enabled_assignments_student`, `course_tab_enabled_documents`, `course_tab_enabled_documents_t_a`, `course_tab_enabled_documents_student`, `course_tab_enabled_grades`, `course_tab_enabled_grades_t_a`, `course_tab_enabled_grades_student`, `course_tab_enabled_roster`, `course_tab_enabled_roster_t_a`, `course_tab_enabled_roster_student`, `course_tab_name_about`, `course_tab_name_assignments`, `course_tab_name_documents`, `course_tab_name_grades`, `course_tab_name_roster`, `course_tab_name_bulletin`, `points_enabled`, `enable_student_average_grade_letter`, `enable_student_average_grade_letter_t_a`, `enable_student_average_grade_letter_student`, `enable_student_average_grade_percentage`, `enable_student_average_grade_percentage_t_a`, `enable_student_average_grade_percentage_student`, `enable_student_average_grade_points`, `enable_student_average_grade_points_t_a`, `enable_student_average_grade_points_student`, `enable_letter_grade_override`, `grade_scheme`, `grade_base`, `grade_precision`, `grade_curve_amount`, `paywall`, `published`, `profile_picture`, `grade_scale`, `course_tab_enabled_about_observer`, `course_tab_enabled_assignments_observer`, `course_tab_enabled_documents_observer`, `course_tab_enabled_grades_observer`, `course_tab_enabled_roster_observer`)
VALUES
	(1,1,1,'Electro Magnetic Physics','PHYS','241','phys-241','2014-01-01 00:00:00','2050-01-01 00:00:00','2030-01-01 00:00:00',NULL,4,0,'2016-05-13 01:59:34.340111','2018-09-26 10:20:32.898600','bOVgMXqceI7050G5oNQI8G7TgALRy5gz',NULL,0,NULL,'Harville 220','In addition to the basic concepts of Electromagnetism, a vast variety of interesting topics are covered in this course: Lightning, Pacemakers, Electric Shock Treatment, Electrocardiograms, Metal Detectors, Musical Instruments, Magnetic Levitation, Bullet Trains, Electric Motors, Radios, TV, Car Coils, Superconductivity, Aurora Borealis, Rainbows, Radio Telescopes, Interferometers, Particle Accelerators (a.k.a. Atom Smashers or Colliders), Mass Spectrometers, Red Sunsets, Blue Skies, Haloes around Sun and Moon, Color Perception, Doppler Effect, Big-Bang Cosmology.',NULL,0.00,1,1,1,1,0,'',1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,'About','Assignments','Documents','Grades','Roster','Bulletin',1,1,1,1,1,1,1,0,0,0,0,'round','percent',1,0,1,1,NULL,'F,0,30;D,60,65;C,70,75;B,80,85;A,90,95',1,1,1,0,1),
	(2,1,1,'Honors English','ENG','109','eng-109h','2014-01-01 00:00:00','2050-01-01 00:00:00','2030-01-01 00:00:00',NULL,3,0,'2016-05-13 01:59:41.304750','2018-10-03 08:06:04.942400','oP8ByiAzFX6MQ8eSlsoNzPoYBQgXWrci',NULL,0,NULL,'Hall B202','',NULL,0.00,1,1,1,1,0,'',1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,'About','Assignments','Documents','Grades','Roster','Bulletin',1,1,1,1,1,1,1,0,0,0,0,'round','percent',2,0,1,1,'https://demo.notebowl.xyz/rpc/v1.0/services/generate/profilePicture/47ACDF/49D1DB','F,0,30;D-,60,61.5;D,63,65;D+,67,68.5;C-,70,71.5;C,73,75;C+,77,78.5;B-,80,81.5;B,83,85;B+,87,88.5;A-,90,91.5;A,93,95;A+,97,98.5',1,1,1,0,1),
	(3,1,1,'Exploring Time and Space','ASTR','108','astronomy--exploring-time','2014-01-01 00:00:00','2050-01-01 00:00:00',NULL,NULL,3,0,'2018-08-28 00:04:20.354200','2018-09-26 14:27:53.842600','lc70cff6d40844d52b9927fa9a406a13',NULL,0,NULL,'Suite 200','This course is designed for anyone who is interested in learning more about modern astronomy. We will help you get up to date on the most recent astronomical discoveries while also providing support at an introductory level for those who have no background in science.',NULL,0.00,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,'About','Assignments','Documents','Grades','Roster','Bulletin',1,1,1,1,1,1,1,0,0,0,0,'round','percent',1,0,0,1,'https://demo.notebowl.xyz/rpc/v1.0/services/generate/profilePicture/BF4458/854D88','F,0,30;D-,60,61.5;D,63,65;D+,67,68.5;C-,70,71.5;C,73,75;C+,77,78.5;B-,80,81.5;B,83,85;B+,87,88.5;A-,90,91.5;A,93,95;A+,97,98.5',1,1,1,0,1),
	(4,1,1,'The Role of Politics and Government','AMH','400','american-history--the-rol','2014-01-01 00:00:00','2050-01-01 00:00:00',NULL,NULL,3,0,'2018-08-28 00:31:37.039100','2018-10-03 08:08:08.259000','le4acf50aaacc4d86a8ad041040cfa3d',NULL,0,NULL,NULL,NULL,NULL,0.00,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,'About','Assignments','Documents','Grades','Roster','Bulletin',1,1,1,1,1,1,1,0,0,0,0,'round','percent',1,0,0,1,'https://demo.notebowl.xyz/rpc/v1.0/services/generate/profilePicture/47689B/4897CC','F,0,30;D,60,65;C,70,75;B,80,85;A,90,95',1,1,1,0,1),
	(5,1,1,'Google Leadership Development Program','GOOG','007','google-leadership-develop','2014-01-01 00:00:00','2050-01-01 00:00:00',NULL,NULL,0,0,'2018-08-28 00:32:17.769300','2018-09-26 10:01:35.234900','s5802ee9570f642b28342df283d297af',NULL,0,NULL,'','This course is designed to hone business expertise and develop skills for a leadership position. \r\n\r\nProgram Objectives:\r\n1. Discover how experiences, beliefs and values effect our leadership style.\r\n2. Develop human potential and build relationships of mutual trust and respect.\r\n3. Create and maintain processes and procedures that drive innovation.\r\n4. Develop leadership by demonstrating effective questioning and listening skills.',NULL,0.00,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,'About','Assignments','Documents','Grades','Roster','Bulletin',1,1,1,1,1,1,1,0,0,0,0,'round','percent',1,0,0,1,NULL,'F,0,30;D,60,65;C,70,75;B,80,85;A,90,95',1,1,1,0,1),
	(6,1,1,'Mission to Mars','SPACE','100','mission-to-mars','2014-01-01 00:00:00','2050-01-01 00:00:00',NULL,NULL,0,0,'2018-08-28 00:33:06.264900','2018-09-26 10:01:35.251800','d4f7a84149dff4e92a9180d8d97bdd1c',NULL,0,NULL,NULL,NULL,NULL,0.00,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,'About','Assignments','Documents','Grades','Roster','Bulletin',1,1,1,1,1,1,1,0,0,0,0,'round','percent',1,0,0,1,NULL,'F,0,30;D,60,65;C,70,75;B,80,85;A,90,95',1,1,1,0,1);

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;

INSERT INTO `devices` (`id`, `os`, `uuid`, `name`, `type`, `model`, `created_at`, `updated_at`, `resource_key`, `deleted_at`, `user_id`, `token`, `verified`)
VALUES
	(1,'11.4','D1235149-0885-43E9-BFA0-A5935AE985AD','Jeff Goldblum','iPhone','x86_64','2018-10-04 21:10:08.078600','2018-10-04 21:10:08.078600','nfcef3f72759948108b3272ab33a4db4',NULL,14,NULL,1),
	(2,'11.4','40DACCC9-2DCC-4B81-B2A4-5487F7EB44D3','Jeff Goldblum','iPhone','x86_64','2018-10-04 22:19:28.121700','2018-10-04 22:19:28.121700','r6876465e6270491e8a0add33c1192bc',NULL,19,NULL,1),
	(3,'11.4','1C35B43C-BB4D-4C4A-BEB4-A798E8959665','Jeff Goldblum','iPhone','x86_64','2018-10-05 02:09:18.166000','2018-10-05 02:09:18.166000','re660349d2094488b87d1677402cd1da',NULL,14,NULL,1),
	(4,'11.4','FE733D1C-FAA4-45F8-A013-10D361A5B230','Jeff Goldblum','iPhone','x86_64','2018-10-05 02:26:39.392200','2018-10-05 02:26:39.392200','kdb730a19d77b45b8b7c254691b01815',NULL,3,NULL,1);

/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;


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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `emails` WRITE;
/*!40000 ALTER TABLE `emails` DISABLE KEYS */;

INSERT INTO `emails` (`id`, `identifier`, `sender_id`, `recipient_id`, `subject`, `body`, `created_at`, `updated_at`, `deleted_at`)
VALUES
	(1,'a0fa887cf924e4c8284cb8d53358827c@mail.notebowl.com',NULL,14,'Enrolled in ENG 109: Honors English','<html>\n    <head>\n        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />\n    </head>\n    <body>\n            <style>\n    </style>\n\n            <style>\n            body {\n                font-family: \"Helvetica Neue\", Helvetica, Arial, sans-serif;\n                max-width: 600px;\n                margin: 30px auto;\n                padding: 0 10px;\n                background-color: #FFF;\n                color: #1a1a1a;\n                font-size: 13px;\n                cursor: default;\n            }\n\n            #email-header {\n                text-align: center;\n                margin-bottom: 30px;\n            }\n\n            #email-header img {\n                width: 200px;\n            }\n\n            #message-wrapper {\n                background-color: white;\n                border: 1px solid #e1e1e1;\n                border-radius: 15px;\n            }\n\n            #featured {\n                display: block;\n                padding: 32px 35px;\n            }\n\n            #featured .profile-pic {\n                float: left;\n                height: 50px;\n                width: 50px;\n                border-radius: 3px;\n                background-size: cover;\n                background-repeat: no-repeat;\n                background-position: 50% 50%;\n                background-color: #f7f7f7;\n            }\n\n            #featured .profile-pic.profile-pic-nb {\n                background-color: #fff;\n                background-image: url(\'https://platform.notebowl.com/latest/images/notebowl-favicon.png\');\n            }\n\n            #featured .profile-pic + .profile-pic-margin {\n                margin-left: 65px;\n            }\n\n            #featured #info {\n                display: inline-block;\n                width: 100%;\n                margin-bottom: 25px;\n            }\n\n            #featured #info h1 {\n                margin: 0 0 3px;\n                color: #1a1a1a;\n                font-size: 17px;\n                font-weight: 500;\n                letter-spacing: .5px;\n            }\n\n            #featured #info h2 {\n                margin: 0;\n                font-size: 14px;\n                line-height: 1.3;\n                font-weight: normal;\n                color: #4d4d4d;\n            }\n\n             #featured #info h2 + h2 {\n                margin-top: 2px;\n            }\n\n            #featured #info .info-right {\n                position: relative;\n                text-align: left;\n                padding-top: 6px;\n                line-height: 16px;\n                font-size: 13px;\n                color: #888;\n            }\n\n            #featured .main-text,\n            #featured .greeting-line {\n                font-size: 15px;\n                line-height: 1.5384615385;\n                color: #464646;\n                letter-spacing: .1px;\n            }\n\n            #featured .greeting-line {\n                margin-bottom: 20px;\n            }\n\n            #featured .action-footer {\n                clear: both;\n                margin: 40px auto 0;\n                text-align: center;\n            }\n\n            #featured ul li + li {\n                margin-top: 5px;\n            }\n\n            #footer {\n                background-color: #F5F6F5;\n                text-align: center;\n                color: #888;\n                padding: 30px;\n                border-bottom-left-radius: 15px;\n                border-bottom-right-radius: 15px;\n            }\n\n            #footer .footer-item + .footer-item {\n                margin-top: 8px;\n            }\n\n            a {\n                background-color: transparent;\n                color: #1a83bd;\n                text-decoration: none;\n                cursor: pointer;\n            }\n\n            a:hover,\n            a:focus {\n                color: #1a6b9a;\n                text-decoration: underline;\n            }\n\n            .btn {\n                display: inline-block;\n                margin-bottom: 0;\n                font-weight: 400;\n                text-align: center;\n                vertical-align: middle;\n                cursor: pointer;\n                background-image: none;\n                border: 1px solid transparent;\n                white-space: nowrap;\n                padding: 6px 12px;\n                font-size: 14px;\n                line-height: 1.42857143;\n                letter-spacing: .3px;\n                border-radius: 4px;\n                -webkit-user-select: none;\n                -moz-user-select: none;\n                -ms-user-select: none;\n                user-select: none;\n                text-decoration: none;\n            }\n\n            .btn:hover,\n            .btn:focus {\n                text-decoration: none;\n            }\n\n            .btn-success {\n                color: #fff;\n                background-color: #5cb85c;\n                border-color: #53b66f;\n            }\n\n            .btn-success:hover,\n            .btn-success:focus {\n                color: #fff;\n                background-color: #44985c;\n                border-color: #44985c;\n            }\n\n            .btn-warning {\n                color: #fff;\n                background-color: #ff8d40;\n                border-color: #ff8d40;\n            }\n\n            .btn-warning:hover,\n            .btn-warning:focus {\n                color: #fff;\n                background-color: #e06a36;\n                border-color: #e06a36;\n            }\n\n            .red {\n                color: #ca262a;\n            }\n\n            .text-muted {\n                color: #888;\n            }\n\n            .text-xs {\n                font-size: 11px;\n            }\n\n            .text-sm {\n                font-size: 12px;\n            }\n\n            .text-lg {\n                font-size: 16px;\n            }\n\n            .text-center {\n                text-align: center;\n            }\n\n            .list-unstyled {\n                padding-left: 0;\n                list-style: none;\n                margin: 0;\n            }\n\n            .list-unstyled li {\n                margin: 0;\n            }\n\n            .list-unstyled li b {\n                font-weight: 500;\n            }\n\n            .heading {\n                border-bottom: 2px solid #e1e1e1;\n                font-size: 17px;\n                color: #717171;\n                font-weight: 500;\n                margin: 25px 0 15px;\n            }\n\n            .well.well-primary {\n                background: #e6f4fb;\n                border: 1px solid #3ba6e2;\n            }\n\n            .well {\n                min-height: 20px;\n                margin: 20px 0px;\n                padding: 12px 18px;\n                background-color: #fbfbfb;\n                border: 1px solid #e1e1e1;\n                border-radius: 3px;\n                color: #4f4f4f;\n            }\n\n            @media (min-width: 510px) {\n                body {\n                    font-size: 14px;\n                }\n\n                #featured .profile-pic + .profile-pic-margin {\n                    margin-left: 72px;\n                }\n\n                #featured #info .info-left {\n                    float: left;\n                    max-width: 315px;\n                }\n\n                #featured #info .info-right {\n                    float: right;\n                    max-width: 175px;\n                    text-align: right;\n                }\n\n                #featured #info h1 {\n                    font-size: 19px;\n                }\n\n                #featured #info h2 {\n                    font-size: 15px;\n                }\n\n                #featured .action-footer .btn {\n                    font-size: 16px;\n                }\n\n                #featured .main-text,\n                #featured .greeting-line {\n                    font-size: 17px;\n                }\n\n                .heading {\n                    font-size: 19px;\n                }\n                .text-lg {\n                    font-size: 23px;\n                }\n            }\n        </style>\n        \n        <div id=\"email-content\">\n            <div id=\"email-header\" role=\"banner\">\n                <img src=\"https://demo.notebowl.xyz/latest/images/notebowl-logo.png\" alt=\"Notebowl\"/>\n            </div>\n            <div id=\"message-wrapper\">\n                <div id=\"featured\" role=\"main\">\n                    <div id=\"content\">\n    <div class=\"greeting-line\">Dear Keith,</div>\n    <div class=\"main-text\">\n        You have been enrolled in <b>Honors English</b> for <b>Fall 2018</b> at <b>University of Arizona</b>.\n    </div>\n    <div class=\"action-footer\">\n        <a href=\"https://demo.notebowl.xyz/gateway/services/links/k71c7530b59c04ab3b9eccca9b553aa5?source=email\" class=\"btn btn-success\" target=\"_blank\">\n            View Course\n        </a>\n    </div>\n</div>\n\n                </div>\n                <div id=\"footer\" role=\"contentinfo\">\n                    <div class=\"footer-item text-muted\">\n                        <i>This is an automatically generated message. Please do not respond.</i>\n                    </div>\n                    <div class=\"footer-item text-muted\">\n                        If you have any questions, please contact us at <a href=\"mailto:support@notebowl.com\">support@notebowl.com</a>.\n                    </div>\n                    <br>\n                    <div class=\"footer-item text-sm\">\n                                                <a href=\"http://support.notebowl.com/general/announcements-and-platform-information/privacy-policy\" target=\"_blank\">Privacy Policy</a>\n                    </div>\n                    <div class=\"footer-item text-xs text-muted\">\n                        <i>Copyright &copy; 2013-2018 Notebowl Inc, All Rights Reserved</i>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </body>\n</html>\n','2018-10-03 08:58:52.501900','2018-10-03 08:58:52.501900',NULL),
	(2,'a260ec20415eac8928486f5e9b74c7a9@mail.notebowl.com',NULL,11,'Enrolled in ENG 109: Honors English','<html>\n    <head>\n        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />\n    </head>\n    <body>\n            <style>\n    </style>\n\n            <style>\n            body {\n                font-family: \"Helvetica Neue\", Helvetica, Arial, sans-serif;\n                max-width: 600px;\n                margin: 30px auto;\n                padding: 0 10px;\n                background-color: #FFF;\n                color: #1a1a1a;\n                font-size: 13px;\n                cursor: default;\n            }\n\n            #email-header {\n                text-align: center;\n                margin-bottom: 30px;\n            }\n\n            #email-header img {\n                width: 200px;\n            }\n\n            #message-wrapper {\n                background-color: white;\n                border: 1px solid #e1e1e1;\n                border-radius: 15px;\n            }\n\n            #featured {\n                display: block;\n                padding: 32px 35px;\n            }\n\n            #featured .profile-pic {\n                float: left;\n                height: 50px;\n                width: 50px;\n                border-radius: 3px;\n                background-size: cover;\n                background-repeat: no-repeat;\n                background-position: 50% 50%;\n                background-color: #f7f7f7;\n            }\n\n            #featured .profile-pic.profile-pic-nb {\n                background-color: #fff;\n                background-image: url(\'https://platform.notebowl.com/latest/images/notebowl-favicon.png\');\n            }\n\n            #featured .profile-pic + .profile-pic-margin {\n                margin-left: 65px;\n            }\n\n            #featured #info {\n                display: inline-block;\n                width: 100%;\n                margin-bottom: 25px;\n            }\n\n            #featured #info h1 {\n                margin: 0 0 3px;\n                color: #1a1a1a;\n                font-size: 17px;\n                font-weight: 500;\n                letter-spacing: .5px;\n            }\n\n            #featured #info h2 {\n                margin: 0;\n                font-size: 14px;\n                line-height: 1.3;\n                font-weight: normal;\n                color: #4d4d4d;\n            }\n\n             #featured #info h2 + h2 {\n                margin-top: 2px;\n            }\n\n            #featured #info .info-right {\n                position: relative;\n                text-align: left;\n                padding-top: 6px;\n                line-height: 16px;\n                font-size: 13px;\n                color: #888;\n            }\n\n            #featured .main-text,\n            #featured .greeting-line {\n                font-size: 15px;\n                line-height: 1.5384615385;\n                color: #464646;\n                letter-spacing: .1px;\n            }\n\n            #featured .greeting-line {\n                margin-bottom: 20px;\n            }\n\n            #featured .action-footer {\n                clear: both;\n                margin: 40px auto 0;\n                text-align: center;\n            }\n\n            #featured ul li + li {\n                margin-top: 5px;\n            }\n\n            #footer {\n                background-color: #F5F6F5;\n                text-align: center;\n                color: #888;\n                padding: 30px;\n                border-bottom-left-radius: 15px;\n                border-bottom-right-radius: 15px;\n            }\n\n            #footer .footer-item + .footer-item {\n                margin-top: 8px;\n            }\n\n            a {\n                background-color: transparent;\n                color: #1a83bd;\n                text-decoration: none;\n                cursor: pointer;\n            }\n\n            a:hover,\n            a:focus {\n                color: #1a6b9a;\n                text-decoration: underline;\n            }\n\n            .btn {\n                display: inline-block;\n                margin-bottom: 0;\n                font-weight: 400;\n                text-align: center;\n                vertical-align: middle;\n                cursor: pointer;\n                background-image: none;\n                border: 1px solid transparent;\n                white-space: nowrap;\n                padding: 6px 12px;\n                font-size: 14px;\n                line-height: 1.42857143;\n                letter-spacing: .3px;\n                border-radius: 4px;\n                -webkit-user-select: none;\n                -moz-user-select: none;\n                -ms-user-select: none;\n                user-select: none;\n                text-decoration: none;\n            }\n\n            .btn:hover,\n            .btn:focus {\n                text-decoration: none;\n            }\n\n            .btn-success {\n                color: #fff;\n                background-color: #5cb85c;\n                border-color: #53b66f;\n            }\n\n            .btn-success:hover,\n            .btn-success:focus {\n                color: #fff;\n                background-color: #44985c;\n                border-color: #44985c;\n            }\n\n            .btn-warning {\n                color: #fff;\n                background-color: #ff8d40;\n                border-color: #ff8d40;\n            }\n\n            .btn-warning:hover,\n            .btn-warning:focus {\n                color: #fff;\n                background-color: #e06a36;\n                border-color: #e06a36;\n            }\n\n            .red {\n                color: #ca262a;\n            }\n\n            .text-muted {\n                color: #888;\n            }\n\n            .text-xs {\n                font-size: 11px;\n            }\n\n            .text-sm {\n                font-size: 12px;\n            }\n\n            .text-lg {\n                font-size: 16px;\n            }\n\n            .text-center {\n                text-align: center;\n            }\n\n            .list-unstyled {\n                padding-left: 0;\n                list-style: none;\n                margin: 0;\n            }\n\n            .list-unstyled li {\n                margin: 0;\n            }\n\n            .list-unstyled li b {\n                font-weight: 500;\n            }\n\n            .heading {\n                border-bottom: 2px solid #e1e1e1;\n                font-size: 17px;\n                color: #717171;\n                font-weight: 500;\n                margin: 25px 0 15px;\n            }\n\n            .well.well-primary {\n                background: #e6f4fb;\n                border: 1px solid #3ba6e2;\n            }\n\n            .well {\n                min-height: 20px;\n                margin: 20px 0px;\n                padding: 12px 18px;\n                background-color: #fbfbfb;\n                border: 1px solid #e1e1e1;\n                border-radius: 3px;\n                color: #4f4f4f;\n            }\n\n            @media (min-width: 510px) {\n                body {\n                    font-size: 14px;\n                }\n\n                #featured .profile-pic + .profile-pic-margin {\n                    margin-left: 72px;\n                }\n\n                #featured #info .info-left {\n                    float: left;\n                    max-width: 315px;\n                }\n\n                #featured #info .info-right {\n                    float: right;\n                    max-width: 175px;\n                    text-align: right;\n                }\n\n                #featured #info h1 {\n                    font-size: 19px;\n                }\n\n                #featured #info h2 {\n                    font-size: 15px;\n                }\n\n                #featured .action-footer .btn {\n                    font-size: 16px;\n                }\n\n                #featured .main-text,\n                #featured .greeting-line {\n                    font-size: 17px;\n                }\n\n                .heading {\n                    font-size: 19px;\n                }\n                .text-lg {\n                    font-size: 23px;\n                }\n            }\n        </style>\n        \n        <div id=\"email-content\">\n            <div id=\"email-header\" role=\"banner\">\n                <img src=\"https://demo.notebowl.xyz/latest/images/notebowl-logo.png\" alt=\"Notebowl\"/>\n            </div>\n            <div id=\"message-wrapper\">\n                <div id=\"featured\" role=\"main\">\n                    <div id=\"content\">\n    <div class=\"greeting-line\">Dear Nina,</div>\n    <div class=\"main-text\">\n        You have been enrolled in <b>Honors English</b> for <b>Fall 2018</b> at <b>University of Arizona</b>.\n    </div>\n    <div class=\"action-footer\">\n        <a href=\"https://demo.notebowl.xyz/gateway/services/links/k71c7530b59c04ab3b9eccca9b553aa5?source=email\" class=\"btn btn-success\" target=\"_blank\">\n            View Course\n        </a>\n    </div>\n</div>\n\n                </div>\n                <div id=\"footer\" role=\"contentinfo\">\n                    <div class=\"footer-item text-muted\">\n                        <i>This is an automatically generated message. Please do not respond.</i>\n                    </div>\n                    <div class=\"footer-item text-muted\">\n                        If you have any questions, please contact us at <a href=\"mailto:support@notebowl.com\">support@notebowl.com</a>.\n                    </div>\n                    <br>\n                    <div class=\"footer-item text-sm\">\n                                                <a href=\"http://support.notebowl.com/general/announcements-and-platform-information/privacy-policy\" target=\"_blank\">Privacy Policy</a>\n                    </div>\n                    <div class=\"footer-item text-xs text-muted\">\n                        <i>Copyright &copy; 2013-2018 Notebowl Inc, All Rights Reserved</i>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </body>\n</html>\n','2018-10-03 18:27:34.327400','2018-10-03 18:27:34.327400',NULL);

/*!40000 ALTER TABLE `emails` ENABLE KEYS */;
UNLOCK TABLES;


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
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `enrollments` WRITE;
/*!40000 ALTER TABLE `enrollments` DISABLE KEYS */;

INSERT INTO `enrollments` (`parent_id`, `user_id`, `id`, `resource_key`, `origin`, `created_at`, `updated_at`, `deleted_at`, `role`, `status`, `parent_type`, `payment_required`, `last_access_at`)
VALUES
	(1,1,1,'e3299ca780a4943429cf2406a32e8f44','native',NULL,'2018-04-19 04:12:51.598000',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(2,1,2,'lM8sGHB9d0yFvTxDhe1q935Fk3QAiFBg','native',NULL,NULL,NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(2,2,3,'QUTDx6ls4PDHnj96d9nmig5XYxF7puJL','native',NULL,NULL,NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(2,16,4,'VvRgrT831R1YtXz7T3lu8QSO2sgPevD1','native',NULL,NULL,NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(2,3,5,'CTYj90xHVSYMuB1UW05SbstexZQVaSgZ','native',NULL,'2018-10-05 02:34:01.692300',NULL,'Professor','Accepted','App\\Models\\Course',1,'2018-10-05 02:34:01.000000'),
	(1,2,6,'m5M9BD1S5HVPpNnZ61hFeboe8HEfXrWR','native',NULL,NULL,NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(1,16,7,'OXEZBqLnrLCpl2S71NMY3lT9EsAsGxlH','native',NULL,NULL,NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(1,3,8,'Pc8jxtrWFEAQXNfI1l5aMJJIqnxTX7IY','native',NULL,'2018-09-26 10:15:22.013200',NULL,'Professor','Accepted','App\\Models\\Course',1,NULL),
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
	(3,3,26,'v10654dbd44574da4a7fc36cbda7f976','native','2018-08-28 00:05:35.134800','2018-10-05 02:39:24.344700',NULL,'Professor','Accepted','App\\Models\\Course',1,'2018-10-05 02:39:24.000000'),
	(3,1,27,'y2dfd06aceeb94d648c36ee201dbad72','native','2018-08-28 00:06:01.514300','2018-08-28 00:20:50.735300',NULL,'Professor','Accepted','App\\Models\\Course',1,'2018-08-28 00:20:50.000000'),
	(3,10,28,'k4ee0d0024c6f408fbebb772b4ebf9b5','native','2018-08-28 00:14:02.983500','2018-08-28 00:14:02.983500',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(3,2,29,'b4f4c2a8e695f4ecca11e7aca71b0a4d','native','2018-08-28 00:14:10.944200','2018-08-28 00:14:10.944200',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(3,14,30,'g6a3da4f992d74e63bf73335a3d7f9b7','native','2018-08-28 00:14:32.414800','2018-10-04 22:57:54.948400',NULL,'Student','Accepted','App\\Models\\Course',1,'2018-10-04 22:57:54.000000'),
	(3,11,31,'sba6718e290774e3f98feb07a51bd332','native','2018-08-28 00:14:38.435400','2018-09-26 10:44:39.050100',NULL,'Student','Accepted','App\\Models\\Course',1,'2018-09-26 10:44:39.000000'),
	(4,3,32,'j521e4337397c4b2484eabf265e314cd','native','2018-08-28 00:31:51.672400','2018-10-05 02:46:25.475300',NULL,'Professor','Accepted','App\\Models\\Course',1,'2018-10-05 02:46:25.000000'),
	(5,3,33,'obd58aaaf121440c8afa9b47d25522af','native','2018-08-28 00:32:38.218400','2018-08-28 00:35:29.227700',NULL,'Professor','Accepted','App\\Models\\Course',1,'2018-08-28 00:35:29.000000'),
	(6,3,34,'yb1f56e05de0b4d0fa9947708cafb791','native','2018-08-28 00:33:18.675000','2018-08-28 00:35:44.707700',NULL,'Professor','Accepted','App\\Models\\Course',1,'2018-08-28 00:35:44.000000'),
	(4,10,35,'h8c1d469106224e308f0704c03ab98ac','native','2018-08-28 00:34:24.713100','2018-08-28 00:34:24.713100',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(1,19,36,'c743abe115b3f461b941e0663793dabe','native','2018-09-26 10:13:11.131500','2018-09-26 10:13:11.131500',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(2,19,37,'o18f7bc6aa08a48c88193d81c5711297','native','2018-09-26 10:13:18.459600','2018-10-05 02:08:30.086900',NULL,'Student','Accepted','App\\Models\\Course',1,'2018-10-05 02:08:30.000000'),
	(3,19,38,'fd57a22fac4504224aca1f3f35d2bed3','native','2018-09-26 10:13:31.988800','2018-09-26 14:29:26.787800',NULL,'Student','Accepted','App\\Models\\Course',1,'2018-09-26 14:29:26.000000'),
	(4,19,39,'tcf0c892941ac47f2a5cb5a53f2e370c','native','2018-09-26 10:13:40.226200','2018-09-26 10:37:10.805100',NULL,'Student','Accepted','App\\Models\\Course',1,'2018-09-26 10:37:10.000000'),
	(5,19,40,'oce9884d9693b43da8e1338d7d30a7f2','native','2018-09-26 10:13:50.237800','2018-09-26 10:13:50.237800',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(6,19,41,'pc672a14c4b3342b9a1260a09f063223','native','2018-09-26 10:14:00.737900','2018-09-26 10:14:00.737900',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(1,19,42,'xd3d0cead258c43eb8580b75eec2a04f','native','2018-09-26 10:14:11.400000','2018-09-26 10:14:11.400000',NULL,'Member','Accepted','App\\Models\\Group',1,NULL),
	(2,14,43,'x31227ec0689f4c50a19759c64cb22c2','native','2018-10-03 08:18:18.192000','2018-10-05 02:17:25.647900',NULL,'Student','Accepted','App\\Models\\Course',1,'2018-10-05 02:17:25.000000'),
	(2,11,44,'d48338062c71d455cae906eb4cb668d8','native','2018-10-03 18:27:31.502399','2018-10-03 19:44:06.339600',NULL,'Student','Accepted','App\\Models\\Course',1,'2018-10-03 19:44:06.000000');

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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

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
  KEY `events_owner_id_owner_type_deleted_at_index` (`parent_id`,`parent_type`,`deleted_at`),
  KEY `events_creator_id_index` (`creator_id`),
  KEY `events_parent_id_index` (`parent_id`),
  KEY `events_parent_type_index` (`parent_type`),
  KEY `events_deleted_at_index` (`deleted_at`)
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
  KEY `grades_creator_id_index` (`creator_id`),
  KEY `grades_available_date_index` (`available_date`),
  KEY `grades_created_at_index` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `grades` WRITE;
/*!40000 ALTER TABLE `grades` DISABLE KEYS */;

INSERT INTO `grades` (`id`, `grade`, `related_id`, `related_type`, `created_at`, `updated_at`, `resource_key`, `deleted_at`, `parent_id`, `parent_type`, `available_date`, `owner_type`, `owner_id`, `creator_id`)
VALUES
	(1,32.600000,19,'App\\Models\\User','2018-09-26 10:49:32.785800','2018-09-26 19:50:49.158100','k686eed2e071b4aec80916f80bf13945',NULL,6,'App\\Models\\Assignment','2018-09-26 10:49:32','App\\Models\\Assignment',6,3),
	(2,NULL,19,'App\\Models\\User','2018-09-26 10:49:46.666900','2018-09-26 12:35:37.773200','s0508c40eac7041f3af03e45eb4b337d','2018-09-26 12:35:37.773200',5,'App\\Models\\Assignment','2018-09-26 10:49:46','App\\Models\\Assignment',5,3),
	(3,7.350000,19,'App\\Models\\User','2018-09-26 10:54:47.267700','2018-09-26 19:50:57.001900','iff26558edd9f4dc5b791d314d176c31',NULL,4,'App\\Models\\Assignment','2018-09-26 10:54:47','App\\Models\\Assignment',4,3),
	(4,NULL,19,'App\\Models\\User','2018-09-26 10:55:15.620400','2018-09-26 12:33:30.707700','z76b4f5782c574048ae656d14361fedc',NULL,3,'App\\Models\\Assignment','2018-09-26 10:55:15','App\\Models\\Assignment',3,3),
	(5,45.750000,19,'App\\Models\\User','2018-09-26 10:55:34.194900','2018-09-26 10:55:34.194900','b2df00d7170b3438abd59aec5447cb13',NULL,7,'App\\Models\\Assignment','2018-09-26 10:55:34','App\\Models\\Assignment',7,3),
	(6,10.000000,19,'App\\Models\\User','2018-09-26 12:36:22.360800','2018-09-26 12:36:22.360800','ff3e118205b06457f9a8a3b9ce5bca4f',NULL,1,'App\\Models\\AssessmentQuestion','2018-09-26 12:36:22','App\\Models\\AssessmentSubmission',1,19),
	(7,10.000000,19,'App\\Models\\User','2018-09-26 12:36:22.408500','2018-09-26 12:36:22.408500','z173bdab11e484eb584360abd65e326f',NULL,1,'App\\Models\\AssessmentSubmission','2018-09-26 12:36:22','App\\Models\\Assessment',1,19),
	(8,39.825000,19,'App\\Models\\User','2018-10-03 08:56:16.191000','2018-10-03 08:56:16.191000','i2d317f3d494b443bb3d1fbae7a14694',NULL,14,'App\\Models\\Assignment','2018-10-03 08:56:16','App\\Models\\Assignment',14,3),
	(9,27.675000,14,'App\\Models\\User','2018-10-03 08:56:24.259200','2018-10-03 08:56:24.259200','v01bf3bdb7bcc40a7ac45cc820cad90c',NULL,14,'App\\Models\\Assignment','2018-10-03 08:56:24','App\\Models\\Assignment',14,3),
	(10,58.500000,14,'App\\Models\\User','2018-10-03 08:57:40.743600','2018-10-03 08:57:40.743600','m171b0beb042842d7a5fbefff0956221',NULL,16,'App\\Models\\Assignment','2018-10-03 08:57:40','App\\Models\\Assignment',16,3),
	(11,NULL,19,'App\\Models\\User','2018-10-05 01:56:27.525400','2018-10-05 01:56:27.525400','fdc24ea21b5754dbbbc3468db46282cc',NULL,7,'App\\Models\\AssessmentQuestion','2018-10-05 01:56:27','App\\Models\\AssessmentSubmission',2,19),
	(12,NULL,19,'App\\Models\\User','2018-10-05 01:56:27.590400','2018-10-05 01:57:47.421700','s1087a1d72bab416db2d049658d52e0d',NULL,2,'App\\Models\\AssessmentSubmission','2018-10-05 01:57:45','App\\Models\\Assessment',3,19),
	(13,NULL,19,'App\\Models\\User','2018-10-05 01:57:03.140900','2018-10-05 01:57:03.140900','u28e2b40785554f738af916ee04981fe',NULL,5,'App\\Models\\AssessmentQuestion','2018-10-05 01:57:03','App\\Models\\AssessmentSubmission',2,19),
	(14,0.000000,19,'App\\Models\\User','2018-10-05 01:57:23.340300','2018-10-05 01:57:23.340300','paf2f2ba1d0a84179816d8e7b6d6f04d',NULL,6,'App\\Models\\AssessmentQuestion','2018-10-05 01:57:23','App\\Models\\AssessmentSubmission',2,19),
	(15,NULL,14,'App\\Models\\User','2018-10-05 02:16:20.904200','2018-10-05 02:16:20.904200','mbba360313df94708aad3e47d9b30c87',NULL,7,'App\\Models\\AssessmentQuestion','2018-10-05 02:16:20','App\\Models\\AssessmentSubmission',3,14),
	(16,NULL,14,'App\\Models\\User','2018-10-05 02:16:20.927400','2018-10-05 02:16:56.135200','h9dbf78a826bb42c6bf14c42875ede99',NULL,3,'App\\Models\\AssessmentSubmission','2018-10-05 02:16:54','App\\Models\\Assessment',3,14),
	(17,NULL,14,'App\\Models\\User','2018-10-05 02:16:31.881100','2018-10-05 02:16:31.881100','s92809528e48842a297829aa84af1f70',NULL,5,'App\\Models\\AssessmentQuestion','2018-10-05 02:16:31','App\\Models\\AssessmentSubmission',3,14),
	(18,0.000000,14,'App\\Models\\User','2018-10-05 02:16:43.084200','2018-10-05 02:16:43.084200','t380ebdaa7f244935a100ba1519d94c5',NULL,6,'App\\Models\\AssessmentQuestion','2018-10-05 02:16:43','App\\Models\\AssessmentSubmission',3,14);

/*!40000 ALTER TABLE `grades` ENABLE KEYS */;
UNLOCK TABLES;


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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

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
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4;

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
	(20,5,14,'2018-08-28 00:39:57.917600','2018-08-28 00:39:57.917600','z4f38a1260ec441da86d3fa5c4ab219f','App\\Models\\Comment',NULL),
	(21,6,19,'2018-09-26 10:37:29.065500','2018-09-26 10:37:29.065500','y2722f35e784948a986c9de554f1bda9','App\\Models\\Post',NULL),
	(22,8,19,'2018-09-26 10:38:54.465800','2018-09-26 10:38:54.465800','s592a4de118b340c98a5a3deacaa1b87','App\\Models\\Comment',NULL),
	(23,5,19,'2018-09-26 10:39:00.150100','2018-09-26 10:39:00.150100','lc183695e9e6a46ea9d64c00612565a7','App\\Models\\Comment',NULL),
	(24,2,19,'2018-09-26 10:39:13.042700','2018-09-26 10:39:13.042700','i49940a3bcf24405da5dee496498a349','App\\Models\\Post',NULL),
	(25,1,19,'2018-09-26 10:39:14.605700','2018-09-26 10:39:14.605700','k3839c8b3ab48438daf54ba19029d650','App\\Models\\Post',NULL),
	(26,4,10,'2018-09-26 10:42:12.638200','2018-09-26 10:42:12.638200','o061be9a99dd748ac9b01ee8714c724d','App\\Models\\Comment',NULL),
	(27,3,10,'2018-09-26 10:42:15.695300','2018-09-26 10:42:15.695300','c838e3c43230b410485127d1785e5ec9','App\\Models\\Post',NULL),
	(28,4,11,'2018-09-26 10:44:45.689900','2018-09-26 10:44:45.689900','qf5a5c43068864b3f861624075f0816d','App\\Models\\Post',NULL),
	(29,8,11,'2018-09-26 10:44:47.918800','2018-09-26 10:44:47.918800','bd68b8e4c99e147c2b135c4b1081bdaa','App\\Models\\Comment',NULL),
	(30,5,11,'2018-09-26 10:44:51.864000','2018-09-26 10:44:51.864000','z538a0040c5af4784b8a2264b43600d6','App\\Models\\Comment',NULL),
	(31,11,3,'2018-09-26 10:58:32.026800','2018-09-26 10:59:04.265100','bebaebbb75739479e88092e7e1e364ef','App\\Models\\Comment','2018-09-26 10:59:04.265100'),
	(32,11,3,'2018-09-26 10:59:06.144300','2018-09-26 19:49:05.947900','r408199180eec4ab28cccb48991ca702','App\\Models\\Comment','2018-09-26 19:49:05.947900'),
	(33,11,3,'2018-09-26 19:49:07.621000','2018-09-26 19:49:07.621000','zf823070d830a4faf884e947f3f681df','App\\Models\\Comment',NULL),
	(34,13,14,'2018-10-03 08:19:00.060300','2018-10-03 08:19:00.060300','q64b87fb772b5481ca40a864db341d9a','App\\Models\\Comment',NULL),
	(35,9,14,'2018-10-03 08:19:02.448300','2018-10-03 08:19:02.448300','q189e32d9a86444d49ad10ec939d2c02','App\\Models\\Post',NULL),
	(36,15,19,'2018-10-03 08:26:21.016299','2018-10-03 08:26:21.016299','j9807b7f46efb43f38be9c2e6b23b2b4','App\\Models\\Comment',NULL),
	(37,20,3,'2018-10-03 08:58:01.558700','2018-10-03 08:58:01.558700','ab61d80fa3c4344288d9f71f90f791b4','App\\Models\\Post',NULL),
	(38,17,19,'2018-10-03 11:57:58.082600','2018-10-03 11:57:58.082600','oc46be4facdea481aa39d6ab5007b030','App\\Models\\Comment',NULL),
	(39,13,19,'2018-10-03 11:58:00.440600','2018-10-03 11:58:00.440600','v8140f8af61e1438bb6cabbf54206924','App\\Models\\Post',NULL),
	(40,18,19,'2018-10-03 11:58:05.190500','2018-10-03 11:58:05.190500','wa96e73dc280548268ecee534e5ca0e8','App\\Models\\Comment',NULL),
	(41,23,14,'2018-10-03 11:59:11.552900','2018-10-03 11:59:11.552900','q319cde4656b54be8b0ca0ed1a97aaec','App\\Models\\Post',NULL),
	(42,23,14,'2018-10-03 11:59:15.719300','2018-10-03 11:59:15.719300','qe49ec29fae2f42d4a3a06a2bdae4f31','App\\Models\\Comment',NULL),
	(43,19,14,'2018-10-03 11:59:20.502100','2018-10-03 11:59:20.502100','e256e89d8b33f43ee903288bbafc801b','App\\Models\\Post',NULL),
	(44,23,19,'2018-10-03 12:08:59.335600','2018-10-03 12:08:59.335600','i2b3382f3a1ea49b0b2093c507464c3d','App\\Models\\Post',NULL),
	(45,22,3,'2018-10-03 15:30:35.544300','2018-10-03 15:30:35.544300','e435ce9c7c8b84d8ab9fad3805ce41ce','App\\Models\\Post',NULL),
	(46,17,3,'2018-10-03 15:31:00.956900','2018-10-03 15:31:00.956900','f24434b5da929460a9ee5ff274eb0a3a','App\\Models\\Post',NULL),
	(47,4,3,'2018-10-03 18:17:50.752600','2018-10-03 18:17:50.752600','ydd7851c4b41a4914b3ca7553704d5c4','App\\Models\\Post',NULL);

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
  `queue` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `machines` WRITE;
/*!40000 ALTER TABLE `machines` DISABLE KEYS */;

INSERT INTO `machines` (`id`, `name`, `expires_at`, `created_at`, `updated_at`, `deleted_at`, `queue`)
VALUES
	(1,'nb-local','2017-06-26 07:16:47.000000','2017-01-24 01:01:30.155000','2017-10-03 09:52:26.326500','2017-10-03 09:52:26.326400',0),
	(2,'b7b6565f80db','2017-10-03 09:53:26.000000','2017-10-03 09:52:26.320100','2017-10-25 21:54:12.556500','2017-10-25 21:54:12.556400',0),
	(3,'296263dd2821','2017-10-25 21:55:12.000000','2017-10-25 21:54:12.550000','2018-03-26 20:21:51.009600','2018-03-26 20:21:51.009500',0),
	(4,'a55ea4d7425f','2018-03-26 20:22:53.000000','2018-03-26 20:21:50.939100','2018-04-05 22:27:36.676900','2018-04-05 22:27:36.676800',0),
	(5,'6705ae5b9a18','2018-04-05 22:29:36.000000','2018-04-05 22:27:36.615900','2018-04-12 06:27:46.647900','2018-04-12 06:27:46.647800',0),
	(6,'052d8d1bca7a','2018-04-19 04:14:50.000000','2018-04-12 06:27:46.570300','2018-04-23 03:56:21.677200','2018-04-23 03:56:21.677000',0),
	(7,'e19f8d20c7f4','2018-04-23 03:58:21.000000','2018-04-23 03:56:21.560900','2018-04-23 23:20:31.888600','2018-04-23 23:20:31.888400',0),
	(8,'1e021f6fa963','2018-04-26 23:31:48.000000','2018-04-23 23:20:31.773200','2018-04-30 02:34:16.405200','2018-04-30 02:34:16.405000',0),
	(9,'3912ea3d6bf0','2018-04-30 02:36:16.000000','2018-04-30 02:34:16.265900','2018-05-08 23:08:50.502299','2018-05-08 23:08:50.502200',0),
	(10,'044fefbd18b6','2018-05-08 23:10:50.000000','2018-05-08 23:08:50.193100','2018-05-31 20:47:44.619700','2018-05-31 20:47:44.619500',0),
	(11,'fc5bfae16182','2018-05-31 20:49:44.000000','2018-05-31 20:47:44.484600','2018-06-30 23:04:48.029100','2018-06-30 23:04:48.028900',0),
	(12,'a8b15126d54e','2018-06-30 23:09:47.000000','2018-06-30 23:04:47.945700','2018-07-12 22:50:54.325900','2018-07-12 22:50:54.325700',0),
	(13,'a7c426e166cf','2018-07-16 22:09:58.000000','2018-07-12 22:50:54.191800','2018-08-05 22:58:27.302700','2018-08-05 22:58:27.302700',0),
	(14,'9255c9379982','2018-08-05 23:03:27.000000','2018-08-05 22:58:27.242100','2018-08-21 17:58:59.486400','2018-08-21 17:58:59.486400',0),
	(15,'363b8c85dc28','2018-08-21 18:03:59.000000','2018-08-21 17:58:59.412800','2018-09-05 22:15:03.864100','2018-09-05 22:15:03.864100',0),
	(16,'03ef57e1b220','2018-09-06 01:51:09.000000','2018-09-05 22:15:03.805600','2018-09-25 10:38:03.471600','2018-09-25 10:38:03.471600',0),
	(17,'775adecf52a5','2018-09-25 10:43:03.000000','2018-09-25 10:38:03.411700','2018-10-03 07:28:26.536000','2018-10-03 07:28:26.536000',0),
	(18,'dc91318d9fed','2018-10-03 10:26:51.000000','2018-10-03 07:28:26.492400','2018-10-03 11:55:03.548500','2018-10-03 11:55:03.548500',0),
	(19,'7d0f16a3022d','2018-10-03 12:20:23.000000','2018-10-03 11:55:03.386500','2018-10-03 15:20:12.360400','2018-10-03 15:20:12.360400',0),
	(20,'60a5870daff0','2018-10-03 19:48:23.000000','2018-10-03 15:20:12.206500','2018-10-04 20:57:36.664400','2018-10-04 20:57:36.664400',0),
	(21,'f244134aa0de','2018-10-05 00:32:09.000000','2018-10-04 20:57:36.507700','2018-10-05 07:06:00.223900','2018-10-05 07:06:00.223900',0),
	(22,'5367c23e3a52','2018-10-05 07:13:05.000000','2018-10-05 07:06:00.063500','2018-10-05 07:08:05.322500',NULL,0);

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
	('2018_08_22_213625_introduceConferenceAttachments',72),
	('2018_08_27_212925_eventsTable',72),
	('2018_08_27_213627_assignmentGroups',72),
	('2018_08_28_221755_courseGradeScaleColumn',72),
	('2018_08_31_180443_restrictRoster',72),
	('2018_09_04_215631_addLoggedoutIndex',72),
	('2018_08_13_000738_createDiscussionVisibility',73),
	('2018_08_24_180902_attachment_related',73),
	('2018_09_06_210420_observerTabPermissions',73),
	('2018_09_11_030527_gradesIndex',73),
	('2018_09_25_071324_addMachineQueue',73),
	('2018_10_02_155505_addCommentsOwner',74),
	('2018_10_03_094005_addCommentsRelated',75);

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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4;

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
	(1,'App\\Models\\Attachment','recommend_apple_link','N;',NULL,'2018-08-28 00:05:20.901500','2018-08-28 00:05:20.901500',10,NULL),
	(2,'App\\Models\\Attachment','sort_value','N;',NULL,'2018-09-26 10:31:37.065500','2018-09-26 10:31:37.065500',11,NULL),
	(2,'App\\Models\\Attachment','thumbnail_url','s:70:\"https://cdn-images-1.medium.com/max/2000/1*cR4zJueh_V4wqgoQq_ZIdA.jpeg\";',NULL,'2018-09-26 10:31:37.085200','2018-09-26 10:31:37.085200',12,NULL),
	(2,'App\\Models\\Attachment','title','s:43:\"How Companies Thrive By Making You Obsessed\";',NULL,'2018-09-26 10:31:37.089100','2018-09-26 10:31:37.089100',13,NULL),
	(2,'App\\Models\\Attachment','description','s:122:\"Sephora provides an excellent case study in how companies can grow by making the experience more pleasant for the customer\";',NULL,'2018-09-26 10:31:37.092600','2018-09-26 10:31:37.092600',14,NULL),
	(2,'App\\Models\\Attachment','domain','s:6:\"Medium\";',NULL,'2018-09-26 10:31:37.094900','2018-09-26 10:31:37.094900',15,NULL),
	(3,'App\\Models\\Attachment','sort_value','N;',NULL,'2018-10-04 22:37:15.667000','2018-10-04 22:37:15.667000',16,NULL),
	(3,'App\\Models\\Attachment','file_id','s:64:\"ve98b146c620d45538d4ebcce299cd107c689d617e7fe4f528a0424099dee242\";',NULL,'2018-10-04 22:37:15.678700','2018-10-04 22:37:15.678700',17,NULL),
	(4,'App\\Models\\Attachment','sort_value','N;',NULL,'2018-10-05 02:07:50.757800','2018-10-05 02:07:50.757800',18,NULL),
	(4,'App\\Models\\Attachment','file_id','s:64:\"ve2402f8e63fd4b239ae912e3da5f69d34f675086ccc74e07abe3d1eee712a2c\";',NULL,'2018-10-05 02:07:50.760200','2018-10-05 02:07:50.760200',19,NULL),
	(5,'App\\Models\\Attachment','sort_value','N;',NULL,'2018-10-05 02:16:51.811300','2018-10-05 02:16:51.811300',20,NULL),
	(5,'App\\Models\\Attachment','file_id','s:64:\"we437c6fbb61641399088a8acdf9a8971b25e8eda5875478983814cd0746b8b4\";',NULL,'2018-10-05 02:16:51.823600','2018-10-05 02:16:51.823600',21,NULL);

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
) ENGINE=InnoDB AUTO_INCREMENT=207 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `model_user_properties` WRITE;
/*!40000 ALTER TABLE `model_user_properties` DISABLE KEYS */;

INSERT INTO `model_user_properties` (`id`, `user_id`, `parent_id`, `parent_type`, `key`, `value`, `created_at`, `updated_at`, `deleted_at`)
VALUES
	(1,1,1,'App\\Models\\Post','collapsed','N;','2018-08-28 00:21:09','2018-08-28 00:21:09',NULL),
	(2,14,2,'App\\Models\\Post','collapsed','N;','2018-08-28 00:22:53','2018-08-28 00:22:53',NULL),
	(3,11,3,'App\\Models\\Post','collapsed','N;','2018-08-28 00:24:44','2018-08-28 00:24:44',NULL),
	(4,2,4,'App\\Models\\Post','collapsed','N;','2018-08-28 00:25:20','2018-08-28 00:25:20',NULL),
	(5,3,5,'App\\Models\\Post','collapsed','N;','2018-08-28 00:27:58','2018-08-28 00:27:58',NULL),
	(6,3,6,'App\\Models\\Post','collapsed','N;','2018-08-28 00:35:54','2018-08-28 00:35:54',NULL),
	(7,3,7,'App\\Models\\Post','collapsed','N;','2018-09-26 10:29:50','2018-09-26 10:29:50',NULL),
	(8,19,8,'App\\Models\\Post','collapsed','N;','2018-09-26 10:38:31','2018-09-26 10:38:31',NULL),
	(9,19,1,'App\\Models\\Notification','text','s:91:\"Andrew Chaifetz liked your comment in American History: The Role of Politics and Government\";','2018-09-26 19:49:10','2018-09-26 19:49:10',NULL),
	(10,19,2,'App\\Models\\Notification','text','s:89:\"Andrew Chaifetz updated your grade on Intro to Astronomy Exam in Exploring Time and Space\";','2018-09-26 19:50:50','2018-09-26 19:50:50',NULL),
	(11,19,3,'App\\Models\\Notification','text','s:91:\"Andrew Chaifetz updated your grade on Group Overnight Starwatch in Exploring Time and Space\";','2018-09-26 19:51:00','2018-09-26 19:51:00',NULL),
	(12,10,4,'App\\Models\\Notification','text','s:75:\"Notebowl User updated Group Overnight Starwatch in Exploring Time and Space\";','2018-09-26 19:51:30','2018-09-26 19:51:30',NULL),
	(13,2,4,'App\\Models\\Notification','text','s:75:\"Notebowl User updated Group Overnight Starwatch in Exploring Time and Space\";','2018-09-26 19:51:30','2018-09-26 19:51:30',NULL),
	(14,14,4,'App\\Models\\Notification','text','s:75:\"Notebowl User updated Group Overnight Starwatch in Exploring Time and Space\";','2018-09-26 19:51:30','2018-09-26 19:51:30',NULL),
	(15,11,4,'App\\Models\\Notification','text','s:75:\"Notebowl User updated Group Overnight Starwatch in Exploring Time and Space\";','2018-09-26 19:51:30','2018-09-26 19:51:30',NULL),
	(16,19,4,'App\\Models\\Notification','text','s:75:\"Notebowl User updated Group Overnight Starwatch in Exploring Time and Space\";','2018-09-26 19:51:30','2018-09-26 19:51:30',NULL),
	(17,1,5,'App\\Models\\Notification','text','s:79:\"Andrew Chaifetz created a new assignment, Discussion Post #1, in Honors English\";','2018-09-26 19:53:22','2018-09-26 19:53:22',NULL),
	(18,2,5,'App\\Models\\Notification','text','s:79:\"Andrew Chaifetz created a new assignment, Discussion Post #1, in Honors English\";','2018-09-26 19:53:22','2018-09-26 19:53:22',NULL),
	(19,16,5,'App\\Models\\Notification','text','s:79:\"Andrew Chaifetz created a new assignment, Discussion Post #1, in Honors English\";','2018-09-26 19:53:22','2018-09-26 19:53:22',NULL),
	(20,19,5,'App\\Models\\Notification','text','s:79:\"Andrew Chaifetz created a new assignment, Discussion Post #1, in Honors English\";','2018-09-26 19:53:22','2018-09-26 19:53:22',NULL),
	(21,10,6,'App\\Models\\Notification','text','s:136:\"Andrew Chaifetz created a new assignment, American History Quiz on Chapter 1&2, in American History: The Role of Politics and Government\";','2018-09-26 19:54:05','2018-09-26 19:54:05',NULL),
	(22,19,6,'App\\Models\\Notification','text','s:136:\"Andrew Chaifetz created a new assignment, American History Quiz on Chapter 1&2, in American History: The Role of Politics and Government\";','2018-09-26 19:54:05','2018-09-26 19:54:05',NULL),
	(23,19,7,'App\\Models\\Notification','text','s:122:\"Andrew Chaifetz commented on a post in American History: The Role of Politics and Government: Exactly! It works perfectly!\";','2018-09-26 19:54:32','2018-09-26 19:54:32',NULL),
	(24,10,7,'App\\Models\\Notification','text','s:104:\"Andrew Chaifetz and 1 other commented on a post in American History: The Role of Politics and Government\";','2018-09-26 19:54:32','2018-09-26 19:54:32',NULL),
	(25,19,7,'App\\Models\\Notification','text','s:122:\"Andrew Chaifetz commented on a post in American History: The Role of Politics and Government: Exactly! It works perfectly!\";','2018-09-26 19:54:32','2018-09-26 19:54:32',NULL),
	(26,1,8,'App\\Models\\Notification','text','s:93:\"Andrew Chaifetz created a new assignment, discussz boarsze 2p 2c w/ counts, in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(27,2,8,'App\\Models\\Notification','text','s:93:\"Andrew Chaifetz created a new assignment, discussz boarsze 2p 2c w/ counts, in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(28,16,8,'App\\Models\\Notification','text','s:93:\"Andrew Chaifetz created a new assignment, discussz boarsze 2p 2c w/ counts, in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(29,19,8,'App\\Models\\Notification','text','s:93:\"Andrew Chaifetz created a new assignment, discussz boarsze 2p 2c w/ counts, in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(30,1,9,'App\\Models\\Notification','text','s:60:\"Andrew Chaifetz updated Discussion Post #1 in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(31,2,9,'App\\Models\\Notification','text','s:60:\"Andrew Chaifetz updated Discussion Post #1 in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(32,16,9,'App\\Models\\Notification','text','s:60:\"Andrew Chaifetz updated Discussion Post #1 in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(33,19,9,'App\\Models\\Notification','text','s:60:\"Andrew Chaifetz updated Discussion Post #1 in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(34,1,10,'App\\Models\\Notification','text','s:60:\"Andrew Chaifetz deleted Discussion Post #1 in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(35,2,10,'App\\Models\\Notification','text','s:60:\"Andrew Chaifetz deleted Discussion Post #1 in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(36,16,10,'App\\Models\\Notification','text','s:60:\"Andrew Chaifetz deleted Discussion Post #1 in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(37,19,10,'App\\Models\\Notification','text','s:60:\"Andrew Chaifetz deleted Discussion Post #1 in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(38,1,12,'App\\Models\\Notification','text','s:55:\"Andrew Chaifetz deleted not published in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(39,2,12,'App\\Models\\Notification','text','s:55:\"Andrew Chaifetz deleted not published in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(40,16,12,'App\\Models\\Notification','text','s:55:\"Andrew Chaifetz deleted not published in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(41,19,12,'App\\Models\\Notification','text','s:55:\"Andrew Chaifetz deleted not published in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(42,1,13,'App\\Models\\Notification','text','s:84:\"Andrew Chaifetz created a new assignment, discussz boarsze 2 coms, in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(43,2,13,'App\\Models\\Notification','text','s:84:\"Andrew Chaifetz created a new assignment, discussz boarsze 2 coms, in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(44,16,13,'App\\Models\\Notification','text','s:84:\"Andrew Chaifetz created a new assignment, discussz boarsze 2 coms, in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(45,19,13,'App\\Models\\Notification','text','s:84:\"Andrew Chaifetz created a new assignment, discussz boarsze 2 coms, in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(46,1,14,'App\\Models\\Notification','text','s:89:\"Andrew Chaifetz created a new assignment, discussz boarsze only 1 post, in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(47,2,14,'App\\Models\\Notification','text','s:89:\"Andrew Chaifetz created a new assignment, discussz boarsze only 1 post, in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(48,16,14,'App\\Models\\Notification','text','s:89:\"Andrew Chaifetz created a new assignment, discussz boarsze only 1 post, in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(49,19,14,'App\\Models\\Notification','text','s:89:\"Andrew Chaifetz created a new assignment, discussz boarsze only 1 post, in Honors English\";','2018-10-03 08:11:38','2018-10-03 08:11:38',NULL),
	(50,1,15,'App\\Models\\Notification','text','s:85:\"Andrew Chaifetz created a new assignment, discussz boarsze no reqs, in Honors English\";','2018-10-03 08:11:39','2018-10-03 08:11:39',NULL),
	(51,2,15,'App\\Models\\Notification','text','s:85:\"Andrew Chaifetz created a new assignment, discussz boarsze no reqs, in Honors English\";','2018-10-03 08:11:39','2018-10-03 08:11:39',NULL),
	(52,16,15,'App\\Models\\Notification','text','s:85:\"Andrew Chaifetz created a new assignment, discussz boarsze no reqs, in Honors English\";','2018-10-03 08:11:39','2018-10-03 08:11:39',NULL),
	(53,19,15,'App\\Models\\Notification','text','s:85:\"Andrew Chaifetz created a new assignment, discussz boarsze no reqs, in Honors English\";','2018-10-03 08:11:39','2018-10-03 08:11:39',NULL),
	(54,1,16,'App\\Models\\Notification','text','s:74:\"Andrew Chaifetz updated discussz boarsze 2p 2c w/ counts in Honors English\";','2018-10-03 08:11:39','2018-10-03 08:11:39',NULL),
	(55,2,16,'App\\Models\\Notification','text','s:74:\"Andrew Chaifetz updated discussz boarsze 2p 2c w/ counts in Honors English\";','2018-10-03 08:11:39','2018-10-03 08:11:39',NULL),
	(56,16,16,'App\\Models\\Notification','text','s:74:\"Andrew Chaifetz updated discussz boarsze 2p 2c w/ counts in Honors English\";','2018-10-03 08:11:39','2018-10-03 08:11:39',NULL),
	(57,19,16,'App\\Models\\Notification','text','s:74:\"Andrew Chaifetz updated discussz boarsze 2p 2c w/ counts in Honors English\";','2018-10-03 08:11:39','2018-10-03 08:11:39',NULL),
	(58,1,17,'App\\Models\\Notification','text','s:65:\"Andrew Chaifetz updated discussz boarsze 2 coms in Honors English\";','2018-10-03 08:11:39','2018-10-03 08:11:39',NULL),
	(59,2,17,'App\\Models\\Notification','text','s:65:\"Andrew Chaifetz updated discussz boarsze 2 coms in Honors English\";','2018-10-03 08:11:39','2018-10-03 08:11:39',NULL),
	(60,16,17,'App\\Models\\Notification','text','s:65:\"Andrew Chaifetz updated discussz boarsze 2 coms in Honors English\";','2018-10-03 08:11:39','2018-10-03 08:11:39',NULL),
	(61,19,17,'App\\Models\\Notification','text','s:65:\"Andrew Chaifetz updated discussz boarsze 2 coms in Honors English\";','2018-10-03 08:11:39','2018-10-03 08:11:39',NULL),
	(62,1,18,'App\\Models\\Notification','text','s:86:\"Andrew Chaifetz created a new assignment, discussz boarsze 2 postsz, in Honors English\";','2018-10-03 08:11:39','2018-10-03 08:11:39',NULL),
	(63,2,18,'App\\Models\\Notification','text','s:86:\"Andrew Chaifetz created a new assignment, discussz boarsze 2 postsz, in Honors English\";','2018-10-03 08:11:39','2018-10-03 08:11:39',NULL),
	(64,16,18,'App\\Models\\Notification','text','s:86:\"Andrew Chaifetz created a new assignment, discussz boarsze 2 postsz, in Honors English\";','2018-10-03 08:11:39','2018-10-03 08:11:39',NULL),
	(65,19,18,'App\\Models\\Notification','text','s:86:\"Andrew Chaifetz created a new assignment, discussz boarsze 2 postsz, in Honors English\";','2018-10-03 08:11:39','2018-10-03 08:11:39',NULL),
	(66,19,9,'App\\Models\\Post','collapsed','N;','2018-10-03 08:15:27','2018-10-03 08:15:27',NULL),
	(67,3,19,'App\\Models\\Notification','text','s:76:\"Conner Owen posted in discussz boarsze 2 coms: this post donetne matter ahah\";','2018-10-03 08:15:29','2018-10-03 08:15:29',NULL),
	(68,9,19,'App\\Models\\Notification','text','s:76:\"Conner Owen posted in discussz boarsze 2 coms: this post donetne matter ahah\";','2018-10-03 08:15:29','2018-10-03 08:15:29',NULL),
	(69,10,19,'App\\Models\\Notification','text','s:76:\"Conner Owen posted in discussz boarsze 2 coms: this post donetne matter ahah\";','2018-10-03 08:15:29','2018-10-03 08:15:29',NULL),
	(70,14,10,'App\\Models\\Post','collapsed','N;','2018-10-03 08:18:56','2018-10-03 08:18:56',NULL),
	(71,14,11,'App\\Models\\Post','collapsed','N;','2018-10-03 08:20:10','2018-10-03 08:20:10',NULL),
	(72,14,12,'App\\Models\\Post','collapsed','N;','2018-10-03 08:20:19','2018-10-03 08:20:19',NULL),
	(73,14,13,'App\\Models\\Post','collapsed','N;','2018-10-03 08:21:06','2018-10-03 08:21:06',NULL),
	(74,14,14,'App\\Models\\Post','collapsed','N;','2018-10-03 08:21:41','2018-10-03 08:21:41',NULL),
	(75,14,15,'App\\Models\\Post','collapsed','N;','2018-10-03 08:22:39','2018-10-03 08:22:39',NULL),
	(76,14,16,'App\\Models\\Post','collapsed','N;','2018-10-03 08:22:55','2018-10-03 08:22:55',NULL),
	(77,14,17,'App\\Models\\Post','collapsed','N;','2018-10-03 08:23:39','2018-10-03 08:23:39',NULL),
	(78,19,18,'App\\Models\\Post','collapsed','N;','2018-10-03 08:46:20','2018-10-03 08:46:20',NULL),
	(79,19,19,'App\\Models\\Post','collapsed','N;','2018-10-03 08:46:44','2018-10-03 08:46:44',NULL),
	(80,19,20,'App\\Models\\Post','collapsed','N;','2018-10-03 08:46:53','2018-10-03 08:46:53',NULL),
	(81,19,21,'App\\Models\\Post','collapsed','N;','2018-10-03 08:47:15','2018-10-03 08:47:15',NULL),
	(82,19,22,'App\\Models\\Post','collapsed','N;','2018-10-03 08:54:41','2018-10-03 08:54:41',NULL),
	(83,3,23,'App\\Models\\Post','collapsed','N;','2018-10-03 08:57:55','2018-10-03 08:57:55',NULL),
	(84,14,20,'App\\Models\\Notification','text','s:55:\"Andrew Chaifetz added you to the course: Honors English\";','2018-10-03 08:58:53','2018-10-03 08:58:53',NULL),
	(85,19,21,'App\\Models\\Notification','text','s:77:\"Keith Taylor posted in discussz boarsze 2 coms: oh hi hello it me and my post\";','2018-10-03 08:58:55','2018-10-03 08:58:55',NULL),
	(86,19,21,'App\\Models\\Notification','text','s:77:\"Keith Taylor posted in discussz boarsze 2 coms: oh hi hello it me and my post\";','2018-10-03 08:58:55','2018-10-03 08:58:55',NULL),
	(87,3,21,'App\\Models\\Notification','text','s:77:\"Keith Taylor posted in discussz boarsze 2 coms: oh hi hello it me and my post\";','2018-10-03 08:58:55','2018-10-03 08:58:55',NULL),
	(88,9,21,'App\\Models\\Notification','text','s:77:\"Keith Taylor posted in discussz boarsze 2 coms: oh hi hello it me and my post\";','2018-10-03 08:58:55','2018-10-03 08:58:55',NULL),
	(89,10,21,'App\\Models\\Notification','text','s:77:\"Keith Taylor posted in discussz boarsze 2 coms: oh hi hello it me and my post\";','2018-10-03 08:58:55','2018-10-03 08:58:55',NULL),
	(90,19,22,'App\\Models\\Notification','text','s:35:\"Keith Taylor liked your comment in \";','2018-10-03 08:58:55','2018-10-03 08:58:55',NULL),
	(91,19,23,'App\\Models\\Notification','text','s:32:\"Keith Taylor liked your post in \";','2018-10-03 08:58:55','2018-10-03 08:58:55',NULL),
	(92,19,24,'App\\Models\\Notification','text','s:121:\"Keith Taylor commented on a post in discussz boarsze 2 coms: look it a different users comment on a discussion board post\";','2018-10-03 08:58:55','2018-10-03 08:58:55',NULL),
	(93,19,24,'App\\Models\\Notification','text','s:121:\"Keith Taylor commented on a post in discussz boarsze 2 coms: look it a different users comment on a discussion board post\";','2018-10-03 08:58:55','2018-10-03 08:58:55',NULL),
	(94,19,25,'App\\Models\\Notification','text','s:83:\"Keith Taylor commented on a post in discussz boarsze 2 coms: let\'s complete this yo\";','2018-10-03 08:58:56','2018-10-03 08:58:56',NULL),
	(95,19,25,'App\\Models\\Notification','text','s:83:\"Keith Taylor commented on a post in discussz boarsze 2 coms: let\'s complete this yo\";','2018-10-03 08:58:56','2018-10-03 08:58:56',NULL),
	(96,3,26,'App\\Models\\Notification','text','s:351:\"Keith Taylor posted in discussz boarsze no reqs: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut porttitor velit metus, at consequat eros interdum quis. Vivamus pharetra, arcu eu pretium dapibus, leo mauris egestas neque, ac consectetur arcu orci eu magna. Sed vitae interdum velit. Aliquam nec sem feugiat, dapibus ipsum ac, pretium orci.\";','2018-10-03 08:58:56','2018-10-03 08:58:56',NULL),
	(97,9,26,'App\\Models\\Notification','text','s:351:\"Keith Taylor posted in discussz boarsze no reqs: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut porttitor velit metus, at consequat eros interdum quis. Vivamus pharetra, arcu eu pretium dapibus, leo mauris egestas neque, ac consectetur arcu orci eu magna. Sed vitae interdum velit. Aliquam nec sem feugiat, dapibus ipsum ac, pretium orci.\";','2018-10-03 08:58:56','2018-10-03 08:58:56',NULL),
	(98,10,26,'App\\Models\\Notification','text','s:351:\"Keith Taylor posted in discussz boarsze no reqs: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut porttitor velit metus, at consequat eros interdum quis. Vivamus pharetra, arcu eu pretium dapibus, leo mauris egestas neque, ac consectetur arcu orci eu magna. Sed vitae interdum velit. Aliquam nec sem feugiat, dapibus ipsum ac, pretium orci.\";','2018-10-03 08:58:56','2018-10-03 08:58:56',NULL),
	(99,3,27,'App\\Models\\Notification','text','s:359:\"Keith Taylor posted in discussz boarsze no reqs: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut porttitor velit metus, at consequat eros interdum quis. Vivamus pharetra, arcu eu pretium dapibus, leo mauris egestas neque, ac consectetur arcu orci eu magna. Sed vitae interdum velit. Aliquam nec sem feugiat, dapibus ipsum ac, pretium orci. TWICE!!\";','2018-10-03 08:58:56','2018-10-03 08:58:56',NULL),
	(100,9,27,'App\\Models\\Notification','text','s:359:\"Keith Taylor posted in discussz boarsze no reqs: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut porttitor velit metus, at consequat eros interdum quis. Vivamus pharetra, arcu eu pretium dapibus, leo mauris egestas neque, ac consectetur arcu orci eu magna. Sed vitae interdum velit. Aliquam nec sem feugiat, dapibus ipsum ac, pretium orci. TWICE!!\";','2018-10-03 08:58:56','2018-10-03 08:58:56',NULL),
	(101,10,27,'App\\Models\\Notification','text','s:359:\"Keith Taylor posted in discussz boarsze no reqs: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut porttitor velit metus, at consequat eros interdum quis. Vivamus pharetra, arcu eu pretium dapibus, leo mauris egestas neque, ac consectetur arcu orci eu magna. Sed vitae interdum velit. Aliquam nec sem feugiat, dapibus ipsum ac, pretium orci. TWICE!!\";','2018-10-03 08:58:56','2018-10-03 08:58:56',NULL),
	(102,3,28,'App\\Models\\Notification','text','s:2313:\"Keith Taylor posted in discussz boarsze 2p 2c w/ counts: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut porttitor velit metus, at consequat eros interdum quis. Vivamus pharetra, arcu eu pretium dapibus, leo mauris egestas neque, ac consectetur arcu orci eu magna. Sed vitae interdum velit. Aliquam nec sem feugiat, dapibus ipsum ac, pretium orci.\n\nNunc convallis id massa sit amet posuere. Integer quis arcu id nulla bibendum efficitur. Fusce convallis ex tellus, ut sollicitudin urna dignissim et. Mauris gravida interdum tellus sed lacinia. Suspendisse fermentum mauris luctus metus venenatis facilisis. Sed erat justo, pellentesque at viverra vel, laoreet eget libero.\n\nAenean eu metus laoreet, feugiat mauris eget, vulputate purus. Curabitur lacinia sed arcu auctor molestie. Cras in finibus velit, at vestibulum quam. Aenean urna lacus, ultricies vel erat sit amet, pellentesque viverra massa. Phasellus ut sapien eu nisl pellentesque semper. Cras volutpat turpis elit. Morbi vel eros sapien. Donec nulla quam, tincidunt eget dapibus vel, fermentum eu purus. Nullam ac convallis augue. Cras viverra efficitur feugiat. Vivamus eget libero eu purus feugiat blandit. Sed dignissim dictum fringilla. Integer lobortis erat in orci cursus, id pulvinar sem feugiat. Sed et turpis felis. Pellentesque nec odio sit amet purus eleifend condimentum.\n\nInterdum et malesuada fames ac ante ipsum primis in faucibus. Praesent consequat enim at ligula semper bibendum. Sed iaculis elit sit amet consectetur gravida. Fusce quis est mollis, viverra enim a, imperdiet augue. Curabitur id dui eu sapien posuere tincidunt scelerisque id tortor. Praesent condimentum molestie urna, in iaculis lectus facilisis nec. Pellentesque finibus non ante vel dignissim. Aenean pharetra mollis leo eu vulputate. Vivamus eleifend, tellus id efficitur volutpat, massa ligula gravida eros, vulputate eleifend eros neque feugiat leo. Quisque eleifend, enim non mattis aliquam, ipsum dolor ullamcorper dui, ut pharetra urna odio ut ipsum. Etiam tempor felis a scelerisque molestie. Maecenas efficitur ex vitae odio viverra, in tristique augue facilisis. Quisque porttitor gravida viverra. Curabitur blandit lobortis nulla, at mollis ante tempus vel. Duis tincidunt dui vel urna maximus placerat. Vivamus volutpat et purus eu aliquet.\";','2018-10-03 08:58:56','2018-10-03 08:58:56',NULL),
	(103,9,28,'App\\Models\\Notification','text','s:2313:\"Keith Taylor posted in discussz boarsze 2p 2c w/ counts: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut porttitor velit metus, at consequat eros interdum quis. Vivamus pharetra, arcu eu pretium dapibus, leo mauris egestas neque, ac consectetur arcu orci eu magna. Sed vitae interdum velit. Aliquam nec sem feugiat, dapibus ipsum ac, pretium orci.\n\nNunc convallis id massa sit amet posuere. Integer quis arcu id nulla bibendum efficitur. Fusce convallis ex tellus, ut sollicitudin urna dignissim et. Mauris gravida interdum tellus sed lacinia. Suspendisse fermentum mauris luctus metus venenatis facilisis. Sed erat justo, pellentesque at viverra vel, laoreet eget libero.\n\nAenean eu metus laoreet, feugiat mauris eget, vulputate purus. Curabitur lacinia sed arcu auctor molestie. Cras in finibus velit, at vestibulum quam. Aenean urna lacus, ultricies vel erat sit amet, pellentesque viverra massa. Phasellus ut sapien eu nisl pellentesque semper. Cras volutpat turpis elit. Morbi vel eros sapien. Donec nulla quam, tincidunt eget dapibus vel, fermentum eu purus. Nullam ac convallis augue. Cras viverra efficitur feugiat. Vivamus eget libero eu purus feugiat blandit. Sed dignissim dictum fringilla. Integer lobortis erat in orci cursus, id pulvinar sem feugiat. Sed et turpis felis. Pellentesque nec odio sit amet purus eleifend condimentum.\n\nInterdum et malesuada fames ac ante ipsum primis in faucibus. Praesent consequat enim at ligula semper bibendum. Sed iaculis elit sit amet consectetur gravida. Fusce quis est mollis, viverra enim a, imperdiet augue. Curabitur id dui eu sapien posuere tincidunt scelerisque id tortor. Praesent condimentum molestie urna, in iaculis lectus facilisis nec. Pellentesque finibus non ante vel dignissim. Aenean pharetra mollis leo eu vulputate. Vivamus eleifend, tellus id efficitur volutpat, massa ligula gravida eros, vulputate eleifend eros neque feugiat leo. Quisque eleifend, enim non mattis aliquam, ipsum dolor ullamcorper dui, ut pharetra urna odio ut ipsum. Etiam tempor felis a scelerisque molestie. Maecenas efficitur ex vitae odio viverra, in tristique augue facilisis. Quisque porttitor gravida viverra. Curabitur blandit lobortis nulla, at mollis ante tempus vel. Duis tincidunt dui vel urna maximus placerat. Vivamus volutpat et purus eu aliquet.\";','2018-10-03 08:58:56','2018-10-03 08:58:56',NULL),
	(104,10,28,'App\\Models\\Notification','text','s:2313:\"Keith Taylor posted in discussz boarsze 2p 2c w/ counts: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut porttitor velit metus, at consequat eros interdum quis. Vivamus pharetra, arcu eu pretium dapibus, leo mauris egestas neque, ac consectetur arcu orci eu magna. Sed vitae interdum velit. Aliquam nec sem feugiat, dapibus ipsum ac, pretium orci.\n\nNunc convallis id massa sit amet posuere. Integer quis arcu id nulla bibendum efficitur. Fusce convallis ex tellus, ut sollicitudin urna dignissim et. Mauris gravida interdum tellus sed lacinia. Suspendisse fermentum mauris luctus metus venenatis facilisis. Sed erat justo, pellentesque at viverra vel, laoreet eget libero.\n\nAenean eu metus laoreet, feugiat mauris eget, vulputate purus. Curabitur lacinia sed arcu auctor molestie. Cras in finibus velit, at vestibulum quam. Aenean urna lacus, ultricies vel erat sit amet, pellentesque viverra massa. Phasellus ut sapien eu nisl pellentesque semper. Cras volutpat turpis elit. Morbi vel eros sapien. Donec nulla quam, tincidunt eget dapibus vel, fermentum eu purus. Nullam ac convallis augue. Cras viverra efficitur feugiat. Vivamus eget libero eu purus feugiat blandit. Sed dignissim dictum fringilla. Integer lobortis erat in orci cursus, id pulvinar sem feugiat. Sed et turpis felis. Pellentesque nec odio sit amet purus eleifend condimentum.\n\nInterdum et malesuada fames ac ante ipsum primis in faucibus. Praesent consequat enim at ligula semper bibendum. Sed iaculis elit sit amet consectetur gravida. Fusce quis est mollis, viverra enim a, imperdiet augue. Curabitur id dui eu sapien posuere tincidunt scelerisque id tortor. Praesent condimentum molestie urna, in iaculis lectus facilisis nec. Pellentesque finibus non ante vel dignissim. Aenean pharetra mollis leo eu vulputate. Vivamus eleifend, tellus id efficitur volutpat, massa ligula gravida eros, vulputate eleifend eros neque feugiat leo. Quisque eleifend, enim non mattis aliquam, ipsum dolor ullamcorper dui, ut pharetra urna odio ut ipsum. Etiam tempor felis a scelerisque molestie. Maecenas efficitur ex vitae odio viverra, in tristique augue facilisis. Quisque porttitor gravida viverra. Curabitur blandit lobortis nulla, at mollis ante tempus vel. Duis tincidunt dui vel urna maximus placerat. Vivamus volutpat et purus eu aliquet.\";','2018-10-03 08:58:56','2018-10-03 08:58:56',NULL),
	(105,3,29,'App\\Models\\Notification','text','s:706:\"Keith Taylor posted in discussz boarsze 2p 2c w/ counts: Lorem ipsum dolor sit amet, consectetur adipiscing elit. In sagittis vitae turpis non aliquet. Nunc ac vehicula leo. Ut placerat efficitur posuere. Nunc lorem velit, ultricies volutpat justo ut, consequat ultrices nisi. Quisque sit amet feugiat mi. Nullam viverra lobortis faucibus. Sed volutpat placerat lorem et congue. Nunc fermentum iaculis lorem, sed facilisis mi efficitur consequat. Sed magna elit, facilisis nec elit non, gravida egestas justo. Ut eleifend sem a turpis posuere, ut varius est vulputate. Proin et rhoncus augue. Praesent vel ante lacus. Pellentesque ultrices et tellus nec dignissim. Vivamus ac aliquam massa, a tempus lorem.\";','2018-10-03 08:58:56','2018-10-03 08:58:56',NULL),
	(106,9,29,'App\\Models\\Notification','text','s:706:\"Keith Taylor posted in discussz boarsze 2p 2c w/ counts: Lorem ipsum dolor sit amet, consectetur adipiscing elit. In sagittis vitae turpis non aliquet. Nunc ac vehicula leo. Ut placerat efficitur posuere. Nunc lorem velit, ultricies volutpat justo ut, consequat ultrices nisi. Quisque sit amet feugiat mi. Nullam viverra lobortis faucibus. Sed volutpat placerat lorem et congue. Nunc fermentum iaculis lorem, sed facilisis mi efficitur consequat. Sed magna elit, facilisis nec elit non, gravida egestas justo. Ut eleifend sem a turpis posuere, ut varius est vulputate. Proin et rhoncus augue. Praesent vel ante lacus. Pellentesque ultrices et tellus nec dignissim. Vivamus ac aliquam massa, a tempus lorem.\";','2018-10-03 08:58:56','2018-10-03 08:58:56',NULL),
	(107,10,29,'App\\Models\\Notification','text','s:706:\"Keith Taylor posted in discussz boarsze 2p 2c w/ counts: Lorem ipsum dolor sit amet, consectetur adipiscing elit. In sagittis vitae turpis non aliquet. Nunc ac vehicula leo. Ut placerat efficitur posuere. Nunc lorem velit, ultricies volutpat justo ut, consequat ultrices nisi. Quisque sit amet feugiat mi. Nullam viverra lobortis faucibus. Sed volutpat placerat lorem et congue. Nunc fermentum iaculis lorem, sed facilisis mi efficitur consequat. Sed magna elit, facilisis nec elit non, gravida egestas justo. Ut eleifend sem a turpis posuere, ut varius est vulputate. Proin et rhoncus augue. Praesent vel ante lacus. Pellentesque ultrices et tellus nec dignissim. Vivamus ac aliquam massa, a tempus lorem.\";','2018-10-03 08:58:56','2018-10-03 08:58:56',NULL),
	(108,3,30,'App\\Models\\Notification','text','s:350:\"Keith Taylor posted in discussz boarsze 2 postsz: ullable column means that you can insert Null for the columns value. If it\'s not a nullable column, you have to insert some value of that data type. So, for existing records, Null will be inserted in them and in new records, your default value will be inserted unless otherwise specified. Make sense?\";','2018-10-03 08:58:57','2018-10-03 08:58:57',NULL),
	(109,9,30,'App\\Models\\Notification','text','s:350:\"Keith Taylor posted in discussz boarsze 2 postsz: ullable column means that you can insert Null for the columns value. If it\'s not a nullable column, you have to insert some value of that data type. So, for existing records, Null will be inserted in them and in new records, your default value will be inserted unless otherwise specified. Make sense?\";','2018-10-03 08:58:57','2018-10-03 08:58:57',NULL),
	(110,10,30,'App\\Models\\Notification','text','s:350:\"Keith Taylor posted in discussz boarsze 2 postsz: ullable column means that you can insert Null for the columns value. If it\'s not a nullable column, you have to insert some value of that data type. So, for existing records, Null will be inserted in them and in new records, your default value will be inserted unless otherwise specified. Make sense?\";','2018-10-03 08:58:57','2018-10-03 08:58:57',NULL),
	(111,3,31,'App\\Models\\Notification','text','s:314:\"Keith Taylor posted in discussz boarsze 2 postsz: I like this answer a little better than dbugger\'s because it explicitly names the default constraint. A default constraint is still created using dbugger\'s syntax, except its name is auto-generated. Knowing the exact name is handy when writing DROP-CREATE scripts.\";','2018-10-03 08:58:57','2018-10-03 08:58:57',NULL),
	(112,9,31,'App\\Models\\Notification','text','s:314:\"Keith Taylor posted in discussz boarsze 2 postsz: I like this answer a little better than dbugger\'s because it explicitly names the default constraint. A default constraint is still created using dbugger\'s syntax, except its name is auto-generated. Knowing the exact name is handy when writing DROP-CREATE scripts.\";','2018-10-03 08:58:57','2018-10-03 08:58:57',NULL),
	(113,10,31,'App\\Models\\Notification','text','s:314:\"Keith Taylor posted in discussz boarsze 2 postsz: I like this answer a little better than dbugger\'s because it explicitly names the default constraint. A default constraint is still created using dbugger\'s syntax, except its name is auto-generated. Knowing the exact name is handy when writing DROP-CREATE scripts.\";','2018-10-03 08:58:57','2018-10-03 08:58:57',NULL),
	(114,3,32,'App\\Models\\Notification','text','s:417:\"Keith Taylor posted in discussz boarsze only 1 post: This query will give us John, Sam, Tom, Tom because they all have the same email.\n\nHowever, what I want is to get duplicates with the same email and name.\n\nThat is, I want to get \"Tom\", \"Tom\".\n\nThe reason I need this: I made a mistake, and allowed to insert duplicate name and email values. Now I need to remove/change the duplicates, so I need to find them first.\";','2018-10-03 08:58:58','2018-10-03 08:58:58',NULL),
	(115,3,32,'App\\Models\\Notification','text','s:417:\"Keith Taylor posted in discussz boarsze only 1 post: This query will give us John, Sam, Tom, Tom because they all have the same email.\n\nHowever, what I want is to get duplicates with the same email and name.\n\nThat is, I want to get \"Tom\", \"Tom\".\n\nThe reason I need this: I made a mistake, and allowed to insert duplicate name and email values. Now I need to remove/change the duplicates, so I need to find them first.\";','2018-10-03 08:58:58','2018-10-03 08:58:58',NULL),
	(116,9,32,'App\\Models\\Notification','text','s:417:\"Keith Taylor posted in discussz boarsze only 1 post: This query will give us John, Sam, Tom, Tom because they all have the same email.\n\nHowever, what I want is to get duplicates with the same email and name.\n\nThat is, I want to get \"Tom\", \"Tom\".\n\nThe reason I need this: I made a mistake, and allowed to insert duplicate name and email values. Now I need to remove/change the duplicates, so I need to find them first.\";','2018-10-03 08:58:58','2018-10-03 08:58:58',NULL),
	(117,10,32,'App\\Models\\Notification','text','s:417:\"Keith Taylor posted in discussz boarsze only 1 post: This query will give us John, Sam, Tom, Tom because they all have the same email.\n\nHowever, what I want is to get duplicates with the same email and name.\n\nThat is, I want to get \"Tom\", \"Tom\".\n\nThe reason I need this: I made a mistake, and allowed to insert duplicate name and email values. Now I need to remove/change the duplicates, so I need to find them first.\";','2018-10-03 08:58:58','2018-10-03 08:58:58',NULL),
	(118,3,33,'App\\Models\\Notification','text','s:93:\"Keith Taylor commented on a post in discussz boarsze only 1 post: surprise unexpected comment\";','2018-10-03 08:58:58','2018-10-03 08:58:58',NULL),
	(119,14,34,'App\\Models\\Notification','text','s:34:\"Conner Owen liked your comment in \";','2018-10-03 08:58:58','2018-10-03 08:58:58',NULL),
	(120,14,35,'App\\Models\\Notification','text','s:69:\"Conner Owen commented on a post in discussz boarsze 2 coms: finisshed\";','2018-10-03 08:58:59','2018-10-03 08:58:59',NULL),
	(121,14,35,'App\\Models\\Notification','text','s:69:\"Conner Owen commented on a post in discussz boarsze 2 coms: finisshed\";','2018-10-03 08:58:59','2018-10-03 08:58:59',NULL),
	(122,3,36,'App\\Models\\Notification','text','s:75:\"Conner Owen posted in discussz boarsze 2 postsz: it onkly one one goeje eoe\";','2018-10-03 08:58:59','2018-10-03 08:58:59',NULL),
	(123,9,36,'App\\Models\\Notification','text','s:75:\"Conner Owen posted in discussz boarsze 2 postsz: it onkly one one goeje eoe\";','2018-10-03 08:58:59','2018-10-03 08:58:59',NULL),
	(124,10,36,'App\\Models\\Notification','text','s:75:\"Conner Owen posted in discussz boarsze 2 postsz: it onkly one one goeje eoe\";','2018-10-03 08:58:59','2018-10-03 08:58:59',NULL),
	(125,3,37,'App\\Models\\Notification','text','s:1603:\"Conner Owen posted in discussz boarsze 2p 2c w/ counts: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas porttitor, lectus eu scelerisque gravida, tortor elit dapibus diam, non rhoncus felis eros et sapien. Donec id arcu ut quam posuere pharetra in eget ipsum. Vivamus et fermentum nibh. Ut tristique leo lorem. Morbi at nulla vitae sapien auctor venenatis eget ut quam. Maecenas mollis sagittis hendrerit. Phasellus et sapien et urna tincidunt aliquet. Aliquam non viverra orci, at placerat purus. Fusce bibendum dignissim nisl, eget ultricies augue maximus vitae. Ut iaculis justo porttitor enim vulputate, quis porttitor arcu tincidunt. Suspendisse potenti. Quisque viverra felis id tellus dignissim sodales. Fusce molestie blandit sodales. Pellentesque ut nisi vitae orci laoreet tempus a in turpis. Pellentesque at risus sed turpis porta tincidunt vitae id sem.\n\nUt bibendum magna id ullamcorper sodales. Maecenas pretium eget massa vitae gravida. Duis aliquam risus sit amet semper volutpat. Ut finibus leo mi, ut interdum dolor egestas sit amet. Praesent eget congue libero. Mauris dignissim lacus sed massa finibus, in mattis ligula commodo. Donec sagittis lacus et leo ultricies eleifend.\n\nNullam varius nulla metus, quis porta elit viverra et. Pellentesque congue mattis leo. Fusce efficitur risus eu magna iaculis fermentum. Mauris non accumsan augue. Curabitur sit amet tincidunt ante. Donec viverra tempor lorem a fermentum. Donec semper, dui ut gravida dictum, eros lacus euismod dui, nec placerat elit lacus non tortor. Lorem ipsum dolor sit amet, consectetur adipiscing.\";','2018-10-03 08:58:59','2018-10-03 08:58:59',NULL),
	(126,9,37,'App\\Models\\Notification','text','s:1603:\"Conner Owen posted in discussz boarsze 2p 2c w/ counts: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas porttitor, lectus eu scelerisque gravida, tortor elit dapibus diam, non rhoncus felis eros et sapien. Donec id arcu ut quam posuere pharetra in eget ipsum. Vivamus et fermentum nibh. Ut tristique leo lorem. Morbi at nulla vitae sapien auctor venenatis eget ut quam. Maecenas mollis sagittis hendrerit. Phasellus et sapien et urna tincidunt aliquet. Aliquam non viverra orci, at placerat purus. Fusce bibendum dignissim nisl, eget ultricies augue maximus vitae. Ut iaculis justo porttitor enim vulputate, quis porttitor arcu tincidunt. Suspendisse potenti. Quisque viverra felis id tellus dignissim sodales. Fusce molestie blandit sodales. Pellentesque ut nisi vitae orci laoreet tempus a in turpis. Pellentesque at risus sed turpis porta tincidunt vitae id sem.\n\nUt bibendum magna id ullamcorper sodales. Maecenas pretium eget massa vitae gravida. Duis aliquam risus sit amet semper volutpat. Ut finibus leo mi, ut interdum dolor egestas sit amet. Praesent eget congue libero. Mauris dignissim lacus sed massa finibus, in mattis ligula commodo. Donec sagittis lacus et leo ultricies eleifend.\n\nNullam varius nulla metus, quis porta elit viverra et. Pellentesque congue mattis leo. Fusce efficitur risus eu magna iaculis fermentum. Mauris non accumsan augue. Curabitur sit amet tincidunt ante. Donec viverra tempor lorem a fermentum. Donec semper, dui ut gravida dictum, eros lacus euismod dui, nec placerat elit lacus non tortor. Lorem ipsum dolor sit amet, consectetur adipiscing.\";','2018-10-03 08:58:59','2018-10-03 08:58:59',NULL),
	(127,10,37,'App\\Models\\Notification','text','s:1603:\"Conner Owen posted in discussz boarsze 2p 2c w/ counts: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas porttitor, lectus eu scelerisque gravida, tortor elit dapibus diam, non rhoncus felis eros et sapien. Donec id arcu ut quam posuere pharetra in eget ipsum. Vivamus et fermentum nibh. Ut tristique leo lorem. Morbi at nulla vitae sapien auctor venenatis eget ut quam. Maecenas mollis sagittis hendrerit. Phasellus et sapien et urna tincidunt aliquet. Aliquam non viverra orci, at placerat purus. Fusce bibendum dignissim nisl, eget ultricies augue maximus vitae. Ut iaculis justo porttitor enim vulputate, quis porttitor arcu tincidunt. Suspendisse potenti. Quisque viverra felis id tellus dignissim sodales. Fusce molestie blandit sodales. Pellentesque ut nisi vitae orci laoreet tempus a in turpis. Pellentesque at risus sed turpis porta tincidunt vitae id sem.\n\nUt bibendum magna id ullamcorper sodales. Maecenas pretium eget massa vitae gravida. Duis aliquam risus sit amet semper volutpat. Ut finibus leo mi, ut interdum dolor egestas sit amet. Praesent eget congue libero. Mauris dignissim lacus sed massa finibus, in mattis ligula commodo. Donec sagittis lacus et leo ultricies eleifend.\n\nNullam varius nulla metus, quis porta elit viverra et. Pellentesque congue mattis leo. Fusce efficitur risus eu magna iaculis fermentum. Mauris non accumsan augue. Curabitur sit amet tincidunt ante. Donec viverra tempor lorem a fermentum. Donec semper, dui ut gravida dictum, eros lacus euismod dui, nec placerat elit lacus non tortor. Lorem ipsum dolor sit amet, consectetur adipiscing.\";','2018-10-03 08:58:59','2018-10-03 08:58:59',NULL),
	(128,3,38,'App\\Models\\Notification','text','s:883:\"Conner Owen posted in discussz boarsze 2p 2c w/ counts: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas porttitor, lectus eu scelerisque gravida, tortor elit dapibus diam, non rhoncus felis eros et sapien. Donec id arcu ut quam posuere pharetra in eget ipsum. Vivamus et fermentum nibh. Ut tristique leo lorem. Morbi at nulla vitae sapien auctor venenatis eget ut quam. Maecenas mollis sagittis hendrerit. Phasellus et sapien et urna tincidunt aliquet. Aliquam non viverra orci, at placerat purus. Fusce bibendum dignissim nisl, eget ultricies augue maximus vitae. Ut iaculis justo porttitor enim vulputate, quis porttitor arcu tincidunt. Suspendisse potenti. Quisque viverra felis id tellus dignissim sodales. Fusce molestie blandit sodales. Pellentesque ut nisi vitae orci laoreet tempus a in turpis. Pellentesque at risus sed turpis porta tincidunt vitae id sem.\";','2018-10-03 08:58:59','2018-10-03 08:58:59',NULL),
	(129,3,38,'App\\Models\\Notification','text','s:883:\"Conner Owen posted in discussz boarsze 2p 2c w/ counts: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas porttitor, lectus eu scelerisque gravida, tortor elit dapibus diam, non rhoncus felis eros et sapien. Donec id arcu ut quam posuere pharetra in eget ipsum. Vivamus et fermentum nibh. Ut tristique leo lorem. Morbi at nulla vitae sapien auctor venenatis eget ut quam. Maecenas mollis sagittis hendrerit. Phasellus et sapien et urna tincidunt aliquet. Aliquam non viverra orci, at placerat purus. Fusce bibendum dignissim nisl, eget ultricies augue maximus vitae. Ut iaculis justo porttitor enim vulputate, quis porttitor arcu tincidunt. Suspendisse potenti. Quisque viverra felis id tellus dignissim sodales. Fusce molestie blandit sodales. Pellentesque ut nisi vitae orci laoreet tempus a in turpis. Pellentesque at risus sed turpis porta tincidunt vitae id sem.\";','2018-10-03 08:58:59','2018-10-03 08:58:59',NULL),
	(130,9,38,'App\\Models\\Notification','text','s:883:\"Conner Owen posted in discussz boarsze 2p 2c w/ counts: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas porttitor, lectus eu scelerisque gravida, tortor elit dapibus diam, non rhoncus felis eros et sapien. Donec id arcu ut quam posuere pharetra in eget ipsum. Vivamus et fermentum nibh. Ut tristique leo lorem. Morbi at nulla vitae sapien auctor venenatis eget ut quam. Maecenas mollis sagittis hendrerit. Phasellus et sapien et urna tincidunt aliquet. Aliquam non viverra orci, at placerat purus. Fusce bibendum dignissim nisl, eget ultricies augue maximus vitae. Ut iaculis justo porttitor enim vulputate, quis porttitor arcu tincidunt. Suspendisse potenti. Quisque viverra felis id tellus dignissim sodales. Fusce molestie blandit sodales. Pellentesque ut nisi vitae orci laoreet tempus a in turpis. Pellentesque at risus sed turpis porta tincidunt vitae id sem.\";','2018-10-03 08:58:59','2018-10-03 08:58:59',NULL),
	(131,10,38,'App\\Models\\Notification','text','s:883:\"Conner Owen posted in discussz boarsze 2p 2c w/ counts: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas porttitor, lectus eu scelerisque gravida, tortor elit dapibus diam, non rhoncus felis eros et sapien. Donec id arcu ut quam posuere pharetra in eget ipsum. Vivamus et fermentum nibh. Ut tristique leo lorem. Morbi at nulla vitae sapien auctor venenatis eget ut quam. Maecenas mollis sagittis hendrerit. Phasellus et sapien et urna tincidunt aliquet. Aliquam non viverra orci, at placerat purus. Fusce bibendum dignissim nisl, eget ultricies augue maximus vitae. Ut iaculis justo porttitor enim vulputate, quis porttitor arcu tincidunt. Suspendisse potenti. Quisque viverra felis id tellus dignissim sodales. Fusce molestie blandit sodales. Pellentesque ut nisi vitae orci laoreet tempus a in turpis. Pellentesque at risus sed turpis porta tincidunt vitae id sem.\";','2018-10-03 08:58:59','2018-10-03 08:58:59',NULL),
	(132,3,39,'App\\Models\\Notification','text','s:69:\"Conner Owen posted in discussz boarsze no reqs: sure why nrteo hahaah\";','2018-10-03 08:59:00','2018-10-03 08:59:00',NULL),
	(133,9,39,'App\\Models\\Notification','text','s:69:\"Conner Owen posted in discussz boarsze no reqs: sure why nrteo hahaah\";','2018-10-03 08:59:00','2018-10-03 08:59:00',NULL),
	(134,10,39,'App\\Models\\Notification','text','s:69:\"Conner Owen posted in discussz boarsze no reqs: sure why nrteo hahaah\";','2018-10-03 08:59:00','2018-10-03 08:59:00',NULL),
	(135,3,40,'App\\Models\\Notification','text','s:70:\"Conner Owen posted in discussz boarsze only 1 post: ok fine ifien fine\";','2018-10-03 08:59:00','2018-10-03 08:59:00',NULL),
	(136,3,40,'App\\Models\\Notification','text','s:70:\"Conner Owen posted in discussz boarsze only 1 post: ok fine ifien fine\";','2018-10-03 08:59:00','2018-10-03 08:59:00',NULL),
	(137,9,40,'App\\Models\\Notification','text','s:70:\"Conner Owen posted in discussz boarsze only 1 post: ok fine ifien fine\";','2018-10-03 08:59:00','2018-10-03 08:59:00',NULL),
	(138,10,40,'App\\Models\\Notification','text','s:70:\"Conner Owen posted in discussz boarsze only 1 post: ok fine ifien fine\";','2018-10-03 08:59:00','2018-10-03 08:59:00',NULL),
	(139,19,41,'App\\Models\\Notification','text','s:77:\"Andrew Chaifetz commented on a post in discussz boarsze only 1 post: nah dude\";','2018-10-03 08:59:01','2018-10-03 08:59:01',NULL),
	(140,14,42,'App\\Models\\Notification','text','s:82:\"Andrew Chaifetz commented on a post in discussz boarsze only 1 post: fam bae goals\";','2018-10-03 08:59:01','2018-10-03 08:59:01',NULL),
	(141,14,42,'App\\Models\\Notification','text','s:82:\"Andrew Chaifetz commented on a post in discussz boarsze only 1 post: fam bae goals\";','2018-10-03 08:59:01','2018-10-03 08:59:01',NULL),
	(142,19,43,'App\\Models\\Notification','text','s:69:\"Andrew Chaifetz graded discussz boarsze only 1 post in Honors English\";','2018-10-03 08:59:01','2018-10-03 08:59:01',NULL),
	(143,14,44,'App\\Models\\Notification','text','s:69:\"Andrew Chaifetz graded discussz boarsze only 1 post in Honors English\";','2018-10-03 08:59:01','2018-10-03 08:59:01',NULL),
	(144,14,45,'App\\Models\\Notification','text','s:66:\"Andrew Chaifetz graded discussz boarsze 2 postsz in Honors English\";','2018-10-03 08:59:02','2018-10-03 08:59:02',NULL),
	(145,1,46,'App\\Models\\Notification','text','s:77:\"Andrew Chaifetz posted in discussz boarsze 2p 2c w/ counts: come on now boyos\";','2018-10-03 08:59:02','2018-10-03 08:59:02',NULL),
	(146,2,46,'App\\Models\\Notification','text','s:77:\"Andrew Chaifetz posted in discussz boarsze 2p 2c w/ counts: come on now boyos\";','2018-10-03 08:59:02','2018-10-03 08:59:02',NULL),
	(147,16,46,'App\\Models\\Notification','text','s:77:\"Andrew Chaifetz posted in discussz boarsze 2p 2c w/ counts: come on now boyos\";','2018-10-03 08:59:02','2018-10-03 08:59:02',NULL),
	(148,9,46,'App\\Models\\Notification','text','s:77:\"Andrew Chaifetz posted in discussz boarsze 2p 2c w/ counts: come on now boyos\";','2018-10-03 08:59:02','2018-10-03 08:59:02',NULL),
	(149,10,46,'App\\Models\\Notification','text','s:77:\"Andrew Chaifetz posted in discussz boarsze 2p 2c w/ counts: come on now boyos\";','2018-10-03 08:59:02','2018-10-03 08:59:02',NULL),
	(150,19,46,'App\\Models\\Notification','text','s:77:\"Andrew Chaifetz posted in discussz boarsze 2p 2c w/ counts: come on now boyos\";','2018-10-03 08:59:02','2018-10-03 08:59:02',NULL),
	(151,14,46,'App\\Models\\Notification','text','s:77:\"Andrew Chaifetz posted in discussz boarsze 2p 2c w/ counts: come on now boyos\";','2018-10-03 08:59:02','2018-10-03 08:59:02',NULL),
	(152,19,47,'App\\Models\\Notification','text','s:35:\"Andrew Chaifetz liked your post in \";','2018-10-03 08:59:02','2018-10-03 08:59:02',NULL),
	(153,14,48,'App\\Models\\Notification','text','s:85:\"Conner Owen commented on a post in discussz boarsze 2p 2c w/ counts: jesus christ wtf\";','2018-10-03 11:57:22','2018-10-03 11:57:22',NULL),
	(154,14,48,'App\\Models\\Notification','text','s:85:\"Conner Owen commented on a post in discussz boarsze 2p 2c w/ counts: jesus christ wtf\";','2018-10-03 11:57:22','2018-10-03 11:57:22',NULL),
	(155,14,49,'App\\Models\\Notification','text','s:66:\"Conner Owen liked your comment in discussz boarsze 2p 2c w/ counts\";','2018-10-03 11:58:01','2018-10-03 11:58:01',NULL),
	(156,14,50,'App\\Models\\Notification','text','s:63:\"Conner Owen liked your post in discussz boarsze 2p 2c w/ counts\";','2018-10-03 11:58:01','2018-10-03 11:58:01',NULL),
	(157,14,51,'App\\Models\\Notification','text','s:66:\"Conner Owen liked your comment in discussz boarsze 2p 2c w/ counts\";','2018-10-03 11:58:08','2018-10-03 11:58:08',NULL),
	(158,3,52,'App\\Models\\Notification','text','s:64:\"Keith Taylor liked your post in discussz boarsze 2p 2c w/ counts\";','2018-10-03 11:59:14','2018-10-03 11:59:14',NULL),
	(159,19,53,'App\\Models\\Notification','text','s:67:\"Keith Taylor liked your comment in discussz boarsze 2p 2c w/ counts\";','2018-10-03 11:59:18','2018-10-03 11:59:18',NULL),
	(160,19,54,'App\\Models\\Notification','text','s:64:\"Keith Taylor liked your post in discussz boarsze 2p 2c w/ counts\";','2018-10-03 11:59:21','2018-10-03 11:59:21',NULL),
	(161,14,4,'App\\Models\\Notification','status','s:4:\"seen\";','2018-10-03 12:03:12','2018-10-03 12:03:12',NULL),
	(162,14,20,'App\\Models\\Notification','status','s:4:\"seen\";','2018-10-03 12:03:12','2018-10-03 12:03:12',NULL),
	(163,14,34,'App\\Models\\Notification','status','s:4:\"seen\";','2018-10-03 12:03:12','2018-10-03 12:03:12',NULL),
	(164,14,35,'App\\Models\\Notification','status','s:4:\"seen\";','2018-10-03 12:03:12','2018-10-03 12:03:12',NULL),
	(165,14,42,'App\\Models\\Notification','status','s:4:\"seen\";','2018-10-03 12:03:12','2018-10-03 12:03:12',NULL),
	(166,14,44,'App\\Models\\Notification','status','s:4:\"seen\";','2018-10-03 12:03:12','2018-10-03 12:03:12',NULL),
	(167,14,45,'App\\Models\\Notification','status','s:4:\"seen\";','2018-10-03 12:03:12','2018-10-03 12:03:12',NULL),
	(168,14,46,'App\\Models\\Notification','status','s:4:\"seen\";','2018-10-03 12:03:12','2018-10-03 12:03:12',NULL),
	(169,14,48,'App\\Models\\Notification','status','s:4:\"seen\";','2018-10-03 12:03:12','2018-10-03 12:03:12',NULL),
	(170,14,49,'App\\Models\\Notification','status','s:4:\"seen\";','2018-10-03 12:03:12','2018-10-03 12:03:12',NULL),
	(171,14,50,'App\\Models\\Notification','status','s:4:\"seen\";','2018-10-03 12:03:12','2018-10-03 12:03:12',NULL),
	(172,14,51,'App\\Models\\Notification','status','s:4:\"seen\";','2018-10-03 12:03:12','2018-10-03 12:03:12',NULL),
	(173,3,55,'App\\Models\\Notification','text','s:75:\"Conner Owen and 1 other liked your post in discussz boarsze 2p 2c w/ counts\";','2018-10-03 12:15:25','2018-10-03 12:15:25',NULL),
	(174,19,56,'App\\Models\\Notification','text','s:63:\"Andrew Chaifetz liked your post in discussz boarsze only 1 post\";','2018-10-03 15:33:08','2018-10-03 15:33:08',NULL),
	(175,14,57,'App\\Models\\Notification','text','s:63:\"Andrew Chaifetz liked your post in discussz boarsze only 1 post\";','2018-10-03 15:33:08','2018-10-03 15:33:08',NULL),
	(176,3,58,'App\\Models\\Notification','text','s:79:\"Conner Owen commented on a post in The Role of Politics and Government: it a me\";','2018-10-03 17:28:07','2018-10-03 17:28:07',NULL),
	(177,3,58,'App\\Models\\Notification','text','s:79:\"Conner Owen commented on a post in The Role of Politics and Government: it a me\";','2018-10-03 17:28:07','2018-10-03 17:28:07',NULL),
	(178,3,58,'App\\Models\\Notification','text','s:79:\"Conner Owen commented on a post in The Role of Politics and Government: it a me\";','2018-10-03 17:28:07','2018-10-03 17:28:07',NULL),
	(179,10,58,'App\\Models\\Notification','text','s:82:\"Conner Owen and 1 other commented on a post in The Role of Politics and Government\";','2018-10-03 17:28:07','2018-10-03 17:28:07',NULL),
	(180,3,58,'App\\Models\\Notification','text','s:79:\"Conner Owen commented on a post in The Role of Politics and Government: it a me\";','2018-10-03 17:28:07','2018-10-03 17:28:07',NULL),
	(181,3,59,'App\\Models\\Notification','text','s:78:\"Conner Owen commented on a post in The Role of Politics and Government: hey hi\";','2018-10-03 17:28:34','2018-10-03 17:28:34',NULL),
	(182,3,59,'App\\Models\\Notification','text','s:78:\"Conner Owen commented on a post in The Role of Politics and Government: hey hi\";','2018-10-03 17:28:34','2018-10-03 17:28:34',NULL),
	(183,3,59,'App\\Models\\Notification','text','s:78:\"Conner Owen commented on a post in The Role of Politics and Government: hey hi\";','2018-10-03 17:28:34','2018-10-03 17:28:34',NULL),
	(184,10,59,'App\\Models\\Notification','text','s:82:\"Conner Owen and 1 other commented on a post in The Role of Politics and Government\";','2018-10-03 17:28:34','2018-10-03 17:28:34',NULL),
	(185,3,59,'App\\Models\\Notification','text','s:78:\"Conner Owen commented on a post in The Role of Politics and Government: hey hi\";','2018-10-03 17:28:34','2018-10-03 17:28:34',NULL),
	(186,14,60,'App\\Models\\Notification','text','s:80:\"Conner Owen commented on a post in discussz boarsze 2p 2c w/ counts: heloo lhigi\";','2018-10-03 17:30:29','2018-10-03 17:30:29',NULL),
	(187,2,61,'App\\Models\\Notification','text','s:72:\"Andrew Chaifetz and 3 others liked your post in Exploring Time and Space\";','2018-10-03 18:17:51','2018-10-03 18:17:51',NULL),
	(188,14,24,'App\\Models\\Post','collapsed','N;','2018-10-03 18:22:21','2018-10-03 18:22:21',NULL),
	(189,3,62,'App\\Models\\Notification','text','s:106:\"Keith Taylor posted in discussz boarsze 2p 2c w/ counts: this is a post that does not have enough words ok\";','2018-10-03 18:22:23','2018-10-03 18:22:23',NULL),
	(190,9,62,'App\\Models\\Notification','text','s:106:\"Keith Taylor posted in discussz boarsze 2p 2c w/ counts: this is a post that does not have enough words ok\";','2018-10-03 18:22:23','2018-10-03 18:22:23',NULL),
	(191,10,62,'App\\Models\\Notification','text','s:106:\"Keith Taylor posted in discussz boarsze 2p 2c w/ counts: this is a post that does not have enough words ok\";','2018-10-03 18:22:23','2018-10-03 18:22:23',NULL),
	(192,11,63,'App\\Models\\Notification','text','s:55:\"Andrew Chaifetz added you to the course: Honors English\";','2018-10-03 18:27:35','2018-10-03 18:27:35',NULL),
	(193,11,25,'App\\Models\\Post','collapsed','N;','2018-10-03 18:51:25','2018-10-03 18:51:25',NULL),
	(194,3,64,'App\\Models\\Notification','text','s:63:\"Nina Iarkova posted in discussz boarsze 2 postsz: suck it boyos\";','2018-10-03 18:51:28','2018-10-03 18:51:28',NULL),
	(195,9,64,'App\\Models\\Notification','text','s:63:\"Nina Iarkova posted in discussz boarsze 2 postsz: suck it boyos\";','2018-10-03 18:51:28','2018-10-03 18:51:28',NULL),
	(196,10,64,'App\\Models\\Notification','text','s:63:\"Nina Iarkova posted in discussz boarsze 2 postsz: suck it boyos\";','2018-10-03 18:51:28','2018-10-03 18:51:28',NULL),
	(197,11,26,'App\\Models\\Post','collapsed','N;','2018-10-03 19:24:56','2018-10-03 19:24:56',NULL),
	(198,3,65,'App\\Models\\Notification','text','s:66:\"Nina Iarkova posted in discussz boarsze 2 postsz: new post lest cl\";','2018-10-03 19:24:58','2018-10-03 19:24:58',NULL),
	(199,9,65,'App\\Models\\Notification','text','s:66:\"Nina Iarkova posted in discussz boarsze 2 postsz: new post lest cl\";','2018-10-03 19:24:58','2018-10-03 19:24:58',NULL),
	(200,10,65,'App\\Models\\Notification','text','s:66:\"Nina Iarkova posted in discussz boarsze 2 postsz: new post lest cl\";','2018-10-03 19:24:59','2018-10-03 19:24:59',NULL),
	(201,11,27,'App\\Models\\Post','collapsed','N;','2018-10-03 19:43:45','2018-10-03 19:43:45',NULL),
	(202,3,66,'App\\Models\\Notification','text','s:58:\"Nina Iarkova posted in discussz boarsze 2 postsz: new post\";','2018-10-03 19:43:47','2018-10-03 19:43:47',NULL),
	(203,9,66,'App\\Models\\Notification','text','s:58:\"Nina Iarkova posted in discussz boarsze 2 postsz: new post\";','2018-10-03 19:43:47','2018-10-03 19:43:47',NULL),
	(204,10,66,'App\\Models\\Notification','text','s:58:\"Nina Iarkova posted in discussz boarsze 2 postsz: new post\";','2018-10-03 19:43:47','2018-10-03 19:43:47',NULL),
	(205,19,28,'App\\Models\\Post','collapsed','N;','2018-10-04 22:22:07','2018-10-04 22:22:07',NULL),
	(206,19,29,'App\\Models\\Post','collapsed','N;','2018-10-04 22:23:27','2018-10-04 22:23:27',NULL);

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
) ENGINE=InnoDB AUTO_INCREMENT=166 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `notification_users` WRITE;
/*!40000 ALTER TABLE `notification_users` DISABLE KEYS */;

INSERT INTO `notification_users` (`id`, `user_id`, `notification_id`, `created_at`, `updated_at`, `deleted_at`)
VALUES
	(1,19,1,'2018-09-26 19:49:10.288600','2018-09-26 19:49:10.288600',NULL),
	(2,19,2,'2018-09-26 19:50:50.243400','2018-09-26 19:50:50.243400',NULL),
	(3,19,3,'2018-09-26 19:50:59.509700','2018-09-26 19:50:59.509700',NULL),
	(4,10,4,'2018-09-26 19:51:30.069900','2018-09-26 19:51:30.069900',NULL),
	(5,2,4,'2018-09-26 19:51:30.069900','2018-09-26 19:51:30.069900',NULL),
	(6,14,4,'2018-09-26 19:51:30.069900','2018-09-26 19:51:30.069900',NULL),
	(7,11,4,'2018-09-26 19:51:30.069900','2018-09-26 19:51:30.069900',NULL),
	(8,19,4,'2018-09-26 19:51:30.069900','2018-09-26 19:51:30.069900',NULL),
	(9,1,5,'2018-09-26 19:53:21.893900','2018-10-03 07:52:13.776000','2018-10-03 07:52:13.776000'),
	(10,2,5,'2018-09-26 19:53:21.893900','2018-10-03 07:52:13.777900','2018-10-03 07:52:13.777900'),
	(11,16,5,'2018-09-26 19:53:21.893900','2018-10-03 07:52:13.779000','2018-10-03 07:52:13.779000'),
	(12,19,5,'2018-09-26 19:53:21.893900','2018-10-03 07:52:13.780800','2018-10-03 07:52:13.780800'),
	(13,10,6,'2018-09-26 19:54:04.776100','2018-09-26 19:54:04.776100',NULL),
	(14,19,6,'2018-09-26 19:54:04.776100','2018-09-26 19:54:04.776100',NULL),
	(15,19,7,'2018-09-26 19:54:32.350400','2018-09-26 19:54:32.350400',NULL),
	(16,10,7,'2018-09-26 19:54:32.350400','2018-09-26 19:54:32.350400',NULL),
	(17,19,7,'2018-09-26 19:54:32.350400','2018-09-26 19:54:32.350400',NULL),
	(18,1,8,'2018-10-03 08:11:37.724700','2018-10-03 08:11:37.724700',NULL),
	(19,2,8,'2018-10-03 08:11:37.724700','2018-10-03 08:11:37.724700',NULL),
	(20,16,8,'2018-10-03 08:11:37.724700','2018-10-03 08:11:37.724700',NULL),
	(21,19,8,'2018-10-03 08:11:37.724700','2018-10-03 08:11:37.724700',NULL),
	(22,1,9,'2018-10-03 08:11:37.916400','2018-10-03 08:11:37.916400',NULL),
	(23,2,9,'2018-10-03 08:11:37.916400','2018-10-03 08:11:37.916400',NULL),
	(24,16,9,'2018-10-03 08:11:37.916400','2018-10-03 08:11:37.916400',NULL),
	(25,19,9,'2018-10-03 08:11:37.916400','2018-10-03 08:11:37.916400',NULL),
	(26,1,10,'2018-10-03 08:11:38.073000','2018-10-03 08:11:38.073000',NULL),
	(27,2,10,'2018-10-03 08:11:38.073000','2018-10-03 08:11:38.073000',NULL),
	(28,16,10,'2018-10-03 08:11:38.073000','2018-10-03 08:11:38.073000',NULL),
	(29,19,10,'2018-10-03 08:11:38.073000','2018-10-03 08:11:38.073000',NULL),
	(30,1,12,'2018-10-03 08:11:38.226100','2018-10-03 08:11:38.226100',NULL),
	(31,2,12,'2018-10-03 08:11:38.226100','2018-10-03 08:11:38.226100',NULL),
	(32,16,12,'2018-10-03 08:11:38.226100','2018-10-03 08:11:38.226100',NULL),
	(33,19,12,'2018-10-03 08:11:38.226100','2018-10-03 08:11:38.226100',NULL),
	(34,1,13,'2018-10-03 08:11:38.360200','2018-10-03 08:11:38.360200',NULL),
	(35,2,13,'2018-10-03 08:11:38.360200','2018-10-03 08:11:38.360200',NULL),
	(36,16,13,'2018-10-03 08:11:38.360200','2018-10-03 08:11:38.360200',NULL),
	(37,19,13,'2018-10-03 08:11:38.360200','2018-10-03 08:11:38.360200',NULL),
	(38,1,14,'2018-10-03 08:11:38.475000','2018-10-03 08:11:38.475000',NULL),
	(39,2,14,'2018-10-03 08:11:38.475000','2018-10-03 08:11:38.475000',NULL),
	(40,16,14,'2018-10-03 08:11:38.475000','2018-10-03 08:11:38.475000',NULL),
	(41,19,14,'2018-10-03 08:11:38.475000','2018-10-03 08:11:38.475000',NULL),
	(42,1,15,'2018-10-03 08:11:38.602100','2018-10-03 08:11:38.602100',NULL),
	(43,2,15,'2018-10-03 08:11:38.602100','2018-10-03 08:11:38.602100',NULL),
	(44,16,15,'2018-10-03 08:11:38.602100','2018-10-03 08:11:38.602100',NULL),
	(45,19,15,'2018-10-03 08:11:38.602100','2018-10-03 08:11:38.602100',NULL),
	(46,1,16,'2018-10-03 08:11:38.747600','2018-10-03 08:11:38.747600',NULL),
	(47,2,16,'2018-10-03 08:11:38.747600','2018-10-03 08:11:38.747600',NULL),
	(48,16,16,'2018-10-03 08:11:38.747600','2018-10-03 08:11:38.747600',NULL),
	(49,19,16,'2018-10-03 08:11:38.747600','2018-10-03 08:11:38.747600',NULL),
	(50,1,17,'2018-10-03 08:11:38.900600','2018-10-03 08:11:38.900600',NULL),
	(51,2,17,'2018-10-03 08:11:38.900600','2018-10-03 08:11:38.900600',NULL),
	(52,16,17,'2018-10-03 08:11:38.900600','2018-10-03 08:11:38.900600',NULL),
	(53,19,17,'2018-10-03 08:11:38.900600','2018-10-03 08:11:38.900600',NULL),
	(54,1,18,'2018-10-03 08:11:39.034100','2018-10-03 08:11:39.034100',NULL),
	(55,2,18,'2018-10-03 08:11:39.034100','2018-10-03 08:11:39.034100',NULL),
	(56,16,18,'2018-10-03 08:11:39.034100','2018-10-03 08:11:39.034100',NULL),
	(57,19,18,'2018-10-03 08:11:39.034100','2018-10-03 08:11:39.034100',NULL),
	(58,3,19,'2018-10-03 08:15:28.555000','2018-10-03 08:15:28.555000',NULL),
	(59,9,19,'2018-10-03 08:15:28.555000','2018-10-03 08:15:28.555000',NULL),
	(60,10,19,'2018-10-03 08:15:28.555000','2018-10-03 08:15:28.555000',NULL),
	(61,14,20,'2018-10-03 08:58:53.005200','2018-10-03 08:58:53.005200',NULL),
	(62,19,21,'2018-10-03 08:58:54.931300','2018-10-03 08:58:54.931300',NULL),
	(63,19,21,'2018-10-03 08:58:54.931300','2018-10-03 08:58:54.931300',NULL),
	(64,3,21,'2018-10-03 08:58:54.931300','2018-10-03 08:58:54.931300',NULL),
	(65,9,21,'2018-10-03 08:58:54.931300','2018-10-03 08:58:54.931300',NULL),
	(66,10,21,'2018-10-03 08:58:54.931300','2018-10-03 08:58:54.931300',NULL),
	(67,19,22,'2018-10-03 08:58:55.130000','2018-10-03 08:58:55.130000',NULL),
	(68,19,23,'2018-10-03 08:58:55.258199','2018-10-03 08:58:55.258199',NULL),
	(69,19,24,'2018-10-03 08:58:55.401800','2018-10-03 08:58:55.401800',NULL),
	(70,19,24,'2018-10-03 08:58:55.401800','2018-10-03 08:58:55.401800',NULL),
	(71,19,25,'2018-10-03 08:58:55.571800','2018-10-03 08:58:55.571800',NULL),
	(72,19,25,'2018-10-03 08:58:55.571800','2018-10-03 08:58:55.571800',NULL),
	(73,3,26,'2018-10-03 08:58:55.818400','2018-10-03 08:58:55.818400',NULL),
	(74,9,26,'2018-10-03 08:58:55.818400','2018-10-03 08:58:55.818400',NULL),
	(75,10,26,'2018-10-03 08:58:55.818400','2018-10-03 08:58:55.818400',NULL),
	(76,3,27,'2018-10-03 08:58:55.975500','2018-10-03 08:58:55.975500',NULL),
	(77,9,27,'2018-10-03 08:58:55.975500','2018-10-03 08:58:55.975500',NULL),
	(78,10,27,'2018-10-03 08:58:55.975500','2018-10-03 08:58:55.975500',NULL),
	(79,3,28,'2018-10-03 08:58:56.256199','2018-10-03 08:58:56.256199',NULL),
	(80,9,28,'2018-10-03 08:58:56.256199','2018-10-03 08:58:56.256199',NULL),
	(81,10,28,'2018-10-03 08:58:56.256199','2018-10-03 08:58:56.256199',NULL),
	(82,3,29,'2018-10-03 08:58:56.439600','2018-10-03 08:58:56.439600',NULL),
	(83,9,29,'2018-10-03 08:58:56.439600','2018-10-03 08:58:56.439600',NULL),
	(84,10,29,'2018-10-03 08:58:56.439600','2018-10-03 08:58:56.439600',NULL),
	(85,3,30,'2018-10-03 08:58:56.874800','2018-10-03 08:58:56.874800',NULL),
	(86,9,30,'2018-10-03 08:58:56.874800','2018-10-03 08:58:56.874800',NULL),
	(87,10,30,'2018-10-03 08:58:56.874800','2018-10-03 08:58:56.874800',NULL),
	(88,3,31,'2018-10-03 08:58:57.163000','2018-10-03 08:58:57.163000',NULL),
	(89,9,31,'2018-10-03 08:58:57.163000','2018-10-03 08:58:57.163000',NULL),
	(90,10,31,'2018-10-03 08:58:57.163000','2018-10-03 08:58:57.163000',NULL),
	(91,3,32,'2018-10-03 08:58:57.600200','2018-10-03 08:58:57.600200',NULL),
	(92,3,32,'2018-10-03 08:58:57.600200','2018-10-03 08:58:57.600200',NULL),
	(93,9,32,'2018-10-03 08:58:57.600200','2018-10-03 08:58:57.600200',NULL),
	(94,10,32,'2018-10-03 08:58:57.600200','2018-10-03 08:58:57.600200',NULL),
	(95,3,33,'2018-10-03 08:58:57.992900','2018-10-03 08:58:57.992900',NULL),
	(96,14,34,'2018-10-03 08:58:58.347100','2018-10-03 08:58:58.347100',NULL),
	(97,14,35,'2018-10-03 08:58:58.627000','2018-10-03 08:58:58.627000',NULL),
	(98,14,35,'2018-10-03 08:58:58.627000','2018-10-03 08:58:58.627000',NULL),
	(99,3,36,'2018-10-03 08:58:58.900000','2018-10-03 08:58:58.900000',NULL),
	(100,9,36,'2018-10-03 08:58:58.900000','2018-10-03 08:58:58.900000',NULL),
	(101,10,36,'2018-10-03 08:58:58.900000','2018-10-03 08:58:58.900000',NULL),
	(102,3,37,'2018-10-03 08:58:59.156100','2018-10-03 08:58:59.156100',NULL),
	(103,9,37,'2018-10-03 08:58:59.156100','2018-10-03 08:58:59.156100',NULL),
	(104,10,37,'2018-10-03 08:58:59.156100','2018-10-03 08:58:59.156100',NULL),
	(105,3,38,'2018-10-03 08:58:59.330500','2018-10-03 08:58:59.330500',NULL),
	(106,3,38,'2018-10-03 08:58:59.330500','2018-10-03 08:58:59.330500',NULL),
	(107,9,38,'2018-10-03 08:58:59.330500','2018-10-03 08:58:59.330500',NULL),
	(108,10,38,'2018-10-03 08:58:59.330500','2018-10-03 08:58:59.330500',NULL),
	(109,3,39,'2018-10-03 08:58:59.593900','2018-10-03 08:58:59.593900',NULL),
	(110,9,39,'2018-10-03 08:58:59.593900','2018-10-03 08:58:59.593900',NULL),
	(111,10,39,'2018-10-03 08:58:59.593900','2018-10-03 08:58:59.593900',NULL),
	(112,3,40,'2018-10-03 08:58:59.964300','2018-10-03 08:58:59.964300',NULL),
	(113,3,40,'2018-10-03 08:58:59.964300','2018-10-03 08:58:59.964300',NULL),
	(114,9,40,'2018-10-03 08:58:59.964300','2018-10-03 08:58:59.964300',NULL),
	(115,10,40,'2018-10-03 08:58:59.964300','2018-10-03 08:58:59.964300',NULL),
	(116,19,41,'2018-10-03 08:59:00.484500','2018-10-03 08:59:00.484500',NULL),
	(117,14,42,'2018-10-03 08:59:00.659000','2018-10-03 08:59:00.659000',NULL),
	(118,14,42,'2018-10-03 08:59:00.659000','2018-10-03 08:59:00.659000',NULL),
	(119,19,43,'2018-10-03 08:59:00.844000','2018-10-03 08:59:00.844000',NULL),
	(120,14,44,'2018-10-03 08:59:00.989600','2018-10-03 08:59:00.989600',NULL),
	(121,14,45,'2018-10-03 08:59:01.600200','2018-10-03 08:59:01.600200',NULL),
	(122,1,46,'2018-10-03 08:59:01.808500','2018-10-03 08:59:01.808500',NULL),
	(123,2,46,'2018-10-03 08:59:01.808500','2018-10-03 08:59:01.808500',NULL),
	(124,16,46,'2018-10-03 08:59:01.808500','2018-10-03 08:59:01.808500',NULL),
	(125,9,46,'2018-10-03 08:59:01.808500','2018-10-03 08:59:01.808500',NULL),
	(126,10,46,'2018-10-03 08:59:01.808500','2018-10-03 08:59:01.808500',NULL),
	(127,19,46,'2018-10-03 08:59:01.808500','2018-10-03 08:59:01.808500',NULL),
	(128,14,46,'2018-10-03 08:59:01.808500','2018-10-03 08:59:01.808500',NULL),
	(129,19,47,'2018-10-03 08:59:01.958600','2018-10-03 08:59:01.958600',NULL),
	(130,14,48,'2018-10-03 11:57:21.751900','2018-10-03 11:57:21.751900',NULL),
	(131,14,48,'2018-10-03 11:57:21.751900','2018-10-03 11:57:21.751900',NULL),
	(132,14,49,'2018-10-03 11:58:01.234800','2018-10-03 11:58:01.234800',NULL),
	(133,14,50,'2018-10-03 11:58:01.466800','2018-10-03 11:58:01.466800',NULL),
	(134,14,51,'2018-10-03 11:58:07.675200','2018-10-03 11:58:07.675200',NULL),
	(135,3,52,'2018-10-03 11:59:14.419400','2018-10-03 11:59:14.419400',NULL),
	(136,19,53,'2018-10-03 11:59:17.648900','2018-10-03 11:59:17.648900',NULL),
	(137,19,54,'2018-10-03 11:59:20.846800','2018-10-03 11:59:20.846800',NULL),
	(138,3,55,'2018-10-03 12:15:24.554700','2018-10-03 12:15:24.554700',NULL),
	(139,19,56,'2018-10-03 15:33:07.939600','2018-10-03 15:33:07.939600',NULL),
	(140,14,57,'2018-10-03 15:33:08.102900','2018-10-03 15:33:08.102900',NULL),
	(141,3,58,'2018-10-03 17:28:06.482200','2018-10-03 17:28:06.482200',NULL),
	(142,3,58,'2018-10-03 17:28:06.482200','2018-10-03 17:28:06.482200',NULL),
	(143,3,58,'2018-10-03 17:28:06.482200','2018-10-03 17:28:06.482200',NULL),
	(144,10,58,'2018-10-03 17:28:06.482200','2018-10-03 17:28:06.482200',NULL),
	(145,3,58,'2018-10-03 17:28:06.482200','2018-10-03 17:28:06.482200',NULL),
	(146,3,59,'2018-10-03 17:28:33.805900','2018-10-03 17:28:33.805900',NULL),
	(147,3,59,'2018-10-03 17:28:33.805900','2018-10-03 17:28:33.805900',NULL),
	(148,3,59,'2018-10-03 17:28:33.805900','2018-10-03 17:28:33.805900',NULL),
	(149,10,59,'2018-10-03 17:28:33.805900','2018-10-03 17:28:33.805900',NULL),
	(150,3,59,'2018-10-03 17:28:33.805900','2018-10-03 17:28:33.805900',NULL),
	(151,14,60,'2018-10-03 17:30:28.718100','2018-10-03 17:30:28.718100',NULL),
	(152,2,61,'2018-10-03 18:17:50.915500','2018-10-03 18:17:50.915500',NULL),
	(153,3,62,'2018-10-03 18:22:22.842400','2018-10-03 18:22:22.842400',NULL),
	(154,9,62,'2018-10-03 18:22:22.842400','2018-10-03 18:22:22.842400',NULL),
	(155,10,62,'2018-10-03 18:22:22.842400','2018-10-03 18:22:22.842400',NULL),
	(156,11,63,'2018-10-03 18:27:34.795500','2018-10-03 18:27:34.795500',NULL),
	(157,3,64,'2018-10-03 18:51:27.519000','2018-10-03 18:51:27.519000',NULL),
	(158,9,64,'2018-10-03 18:51:27.519000','2018-10-03 18:51:27.519000',NULL),
	(159,10,64,'2018-10-03 18:51:27.519000','2018-10-03 18:51:27.519000',NULL),
	(160,3,65,'2018-10-03 19:24:58.469100','2018-10-03 19:24:58.469100',NULL),
	(161,9,65,'2018-10-03 19:24:58.469100','2018-10-03 19:24:58.469100',NULL),
	(162,10,65,'2018-10-03 19:24:58.469100','2018-10-03 19:24:58.469100',NULL),
	(163,3,66,'2018-10-03 19:43:46.736200','2018-10-03 19:43:46.736200',NULL),
	(164,9,66,'2018-10-03 19:43:46.736200','2018-10-03 19:43:46.736200',NULL),
	(165,10,66,'2018-10-03 19:43:46.736200','2018-10-03 19:43:46.736200',NULL);

/*!40000 ALTER TABLE `notification_users` ENABLE KEYS */;
UNLOCK TABLES;


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
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;

INSERT INTO `notifications` (`id`, `created_at`, `updated_at`, `resource_key`, `type`, `parent_type`, `deleted_at`, `parent_id`, `owner_id`, `owner_type`, `creator_id`)
VALUES
	(1,'2018-09-26 19:49:10.189500','2018-09-26 19:49:10.189500','z017c38cd04a84fdd9097b1dbe667bff','created','App\\Models\\Comment',NULL,11,33,'App\\Models\\Like',3),
	(2,'2018-09-26 19:50:50.218600','2018-09-26 19:50:50.218600','k07344dc4a5d441bfb5e95c3abe4c592','updated','App\\Models\\Grade',NULL,1,1,'App\\Models\\Grade',3),
	(3,'2018-09-26 19:50:59.485600','2018-09-26 19:50:59.485600','ed2dcaf3bdd1348e3a8a8dd50a8a1d68','updated','App\\Models\\Grade',NULL,3,3,'App\\Models\\Grade',3),
	(4,'2018-09-26 19:51:30.045200','2018-09-26 19:51:30.045200','h57dac006f51140e7ac4b57b2568cb77','updated','App\\Models\\Assignment',NULL,4,4,'App\\Models\\Assignment',3),
	(5,'2018-09-26 19:53:21.869400','2018-10-03 07:52:13.793600','rd2a805567e8045efa1349de50e24c95','created','App\\Models\\Assignment','2018-10-03 07:52:13.793600',8,8,'App\\Models\\Assignment',3),
	(6,'2018-09-26 19:54:04.753100','2018-09-26 19:54:04.753100','ne494d6d305a4413db0e66ee93df8466','created','App\\Models\\Assignment',NULL,9,9,'App\\Models\\Assignment',3),
	(7,'2018-09-26 19:54:32.336700','2018-09-26 19:54:32.336700','xd3acd7d6addf43a690552f08a1a329b','created','App\\Models\\Post',NULL,6,12,'App\\Models\\Comment',3),
	(8,'2018-10-03 08:11:37.652800','2018-10-03 08:11:37.652800','g5c9b6add9d4d4b5f8535a2537968ad6','created','App\\Models\\Assignment',NULL,12,12,'App\\Models\\Assignment',3),
	(9,'2018-10-03 08:11:37.909700','2018-10-03 08:11:37.909700','v736297ce45ce47bd83ce4a08b8853f6','updated','App\\Models\\Assignment',NULL,8,8,'App\\Models\\Assignment',3),
	(10,'2018-10-03 08:11:38.064297','2018-10-03 08:11:38.064297','t03858378a1494213aadb8d978e5bec4','deleted','App\\Models\\Assignment',NULL,8,8,'App\\Models\\Assignment',3),
	(11,'2018-10-03 08:11:38.159400','2018-10-03 08:11:38.159400','b9be45f402dd9449190109b88075178f','deleted','App\\Models\\Assignment',NULL,11,11,'App\\Models\\Assignment',3),
	(12,'2018-10-03 08:11:38.217800','2018-10-03 08:11:38.217800','o340525a34536499dbc3b4bb0e6253ae','deleted','App\\Models\\Assignment',NULL,10,10,'App\\Models\\Assignment',3),
	(13,'2018-10-03 08:11:38.353100','2018-10-03 08:11:38.353100','y4da5bd0a7c2144068c34f7e2d74b2e8','created','App\\Models\\Assignment',NULL,13,13,'App\\Models\\Assignment',3),
	(14,'2018-10-03 08:11:38.467200','2018-10-03 08:11:38.467200','be48355d463124bd2a167856c7381ff4','created','App\\Models\\Assignment',NULL,14,14,'App\\Models\\Assignment',3),
	(15,'2018-10-03 08:11:38.592000','2018-10-03 08:11:38.592000','ed2660cf94f7f4eb6ab31294143fb672','created','App\\Models\\Assignment',NULL,15,15,'App\\Models\\Assignment',3),
	(16,'2018-10-03 08:11:38.739700','2018-10-03 08:11:38.739700','bcb76dcb8f87c4cee94bc6c952e6d622','updated','App\\Models\\Assignment',NULL,12,12,'App\\Models\\Assignment',3),
	(17,'2018-10-03 08:11:38.889800','2018-10-03 08:11:38.889800','i9891d6bf40534e51a357c36b1c3ad9e','updated','App\\Models\\Assignment',NULL,13,13,'App\\Models\\Assignment',3),
	(18,'2018-10-03 08:11:39.027100','2018-10-03 08:11:39.027100','m689643fb002440b69c9b76b39620260','created','App\\Models\\Assignment',NULL,16,16,'App\\Models\\Assignment',3),
	(19,'2018-10-03 08:15:28.545200','2018-10-03 08:15:28.545200','o5b046b548f2c43e5aabc81161b9c023','created','App\\Models\\Post',NULL,9,9,'App\\Models\\Post',19),
	(20,'2018-10-03 08:58:52.983600','2018-10-03 08:58:52.983600','t50cea16d02a6491b9ef265cccf93528','created','App\\Models\\Enrollment',NULL,43,43,'App\\Models\\Enrollment',3),
	(21,'2018-10-03 08:58:54.921900','2018-10-03 08:58:54.921900','id360ca939155479ba1b7200e258aeb7','created','App\\Models\\Post',NULL,10,10,'App\\Models\\Post',14),
	(22,'2018-10-03 08:58:55.114700','2018-10-03 08:58:55.114700','n8c66f746b86b4f8e80b4a4532dfa1c6','created','App\\Models\\Comment',NULL,13,34,'App\\Models\\Like',14),
	(23,'2018-10-03 08:58:55.242900','2018-10-03 08:58:55.242900','nc36031ae02b0426e91206c0747a2ca3','created','App\\Models\\Post',NULL,9,35,'App\\Models\\Like',14),
	(24,'2018-10-03 08:58:55.393700','2018-10-03 08:58:55.393700','gf22cce3f2d4b43e596e4249944d70e8','created','App\\Models\\Post',NULL,9,14,'App\\Models\\Comment',14),
	(25,'2018-10-03 08:58:55.557300','2018-10-03 08:58:55.557300','pf0399b81b9df424aa3ad1489f475702','created','App\\Models\\Post',NULL,10,15,'App\\Models\\Comment',14),
	(26,'2018-10-03 08:58:55.806400','2018-10-03 08:58:55.806400','ia3df63179b6f4a35aae99c3b89b7996','created','App\\Models\\Post',NULL,11,11,'App\\Models\\Post',14),
	(27,'2018-10-03 08:58:55.962400','2018-10-03 08:58:55.962400','a65980ab832f643e49ea8ef7fa51f483','created','App\\Models\\Post',NULL,12,12,'App\\Models\\Post',14),
	(28,'2018-10-03 08:58:56.247900','2018-10-03 08:58:56.247900','cec190241eba4486ca72a2a76db2d789','created','App\\Models\\Post',NULL,13,13,'App\\Models\\Post',14),
	(29,'2018-10-03 08:58:56.430800','2018-10-03 08:58:56.430800','oc5d9bed86fad4fde9ba2486edb676b5','created','App\\Models\\Post',NULL,14,14,'App\\Models\\Post',14),
	(30,'2018-10-03 08:58:56.860000','2018-10-03 08:58:56.860000','pd2df8228274d47118a19e575149b64e','created','App\\Models\\Post',NULL,15,15,'App\\Models\\Post',14),
	(31,'2018-10-03 08:58:57.140900','2018-10-03 08:58:57.140900','b813a10ff8ba1491b9cbc67f1dd7c890','created','App\\Models\\Post',NULL,16,16,'App\\Models\\Post',14),
	(32,'2018-10-03 08:58:57.575700','2018-10-03 08:58:57.575700','l2cd5ae8f750c4108b4786b5782ee7a5','created','App\\Models\\Post',NULL,17,17,'App\\Models\\Post',14),
	(33,'2018-10-03 08:58:57.982100','2018-10-03 08:58:57.982100','se75d07daa09140bc8387aef742595d2','created','App\\Models\\Post',NULL,17,19,'App\\Models\\Comment',14),
	(34,'2018-10-03 08:58:58.331100','2018-10-03 08:58:58.331100','c3db8e37e361042b7803c9b3d6561318','created','App\\Models\\Comment',NULL,15,36,'App\\Models\\Like',19),
	(35,'2018-10-03 08:58:58.613600','2018-10-03 08:58:58.613600','ga87d7a93eeb749878cc3e2b247c5c81','created','App\\Models\\Post',NULL,10,20,'App\\Models\\Comment',19),
	(36,'2018-10-03 08:58:58.888900','2018-10-03 08:58:58.888900','m9d681f541a814f00a5f9d66151c4ec5','created','App\\Models\\Post',NULL,18,18,'App\\Models\\Post',19),
	(37,'2018-10-03 08:58:59.142900','2018-10-03 08:58:59.142900','c83d0ffd6c89a45349b93e24c173e5ec','created','App\\Models\\Post',NULL,19,19,'App\\Models\\Post',19),
	(38,'2018-10-03 08:58:59.318700','2018-10-03 08:58:59.318700','sac5477d5bfab437dab3e867c3c946d5','created','App\\Models\\Post',NULL,20,20,'App\\Models\\Post',19),
	(39,'2018-10-03 08:58:59.580600','2018-10-03 08:58:59.580600','jc08b65301d4f49ffad9558eefe32610','created','App\\Models\\Post',NULL,21,21,'App\\Models\\Post',19),
	(40,'2018-10-03 08:58:59.947600','2018-10-03 08:58:59.947600','i0892655221434b0daab8d164f7d6644','created','App\\Models\\Post',NULL,22,22,'App\\Models\\Post',19),
	(41,'2018-10-03 08:59:00.467200','2018-10-03 08:59:00.467200','f3a95b9f314474d809d2b027646d40c5','created','App\\Models\\Post',NULL,22,21,'App\\Models\\Comment',3),
	(42,'2018-10-03 08:59:00.644700','2018-10-03 08:59:00.644700','i1ff5a9fe3e664805a36f0a2a0ab3b0c','created','App\\Models\\Post',NULL,17,22,'App\\Models\\Comment',3),
	(43,'2018-10-03 08:59:00.830500','2018-10-03 08:59:00.830500','n945d340fbd25487c96150a8a1406a27','created','App\\Models\\Grade',NULL,8,8,'App\\Models\\Grade',3),
	(44,'2018-10-03 08:59:00.976000','2018-10-03 08:59:00.976000','ha598d30d62094deebe94529cc692824','created','App\\Models\\Grade',NULL,9,9,'App\\Models\\Grade',3),
	(45,'2018-10-03 08:59:01.586500','2018-10-03 08:59:01.586500','ab6a562c1a2c740a9a092e2eaf5ea6d2','created','App\\Models\\Grade',NULL,10,10,'App\\Models\\Grade',3),
	(46,'2018-10-03 08:59:01.800900','2018-10-03 08:59:01.800900','ea85de55ca95e42bbbe54a0a9b2bd0d1','created','App\\Models\\Post',NULL,23,23,'App\\Models\\Post',3),
	(47,'2018-10-03 08:59:01.947200','2018-10-03 08:59:01.947200','d0c8b8bffcd744b2491f7be9167fb524','created','App\\Models\\Post',NULL,20,37,'App\\Models\\Like',3),
	(48,'2018-10-03 11:57:21.587700','2018-10-03 11:57:21.587700','j868c14817a544621843881d47fbb370','created','App\\Models\\Post',NULL,13,23,'App\\Models\\Comment',19),
	(49,'2018-10-03 11:58:01.214000','2018-10-03 11:58:01.214000','fa0465b0642dd4cb98ea8ba510879040','created','App\\Models\\Comment',NULL,17,38,'App\\Models\\Like',19),
	(50,'2018-10-03 11:58:01.446000','2018-10-03 11:58:01.446000','p9d19f6ab882c436da04da63cf811959','created','App\\Models\\Post',NULL,13,39,'App\\Models\\Like',19),
	(51,'2018-10-03 11:58:07.659500','2018-10-03 11:58:07.659500','wa00428283d564cb08bb3ca47771a9e5','created','App\\Models\\Comment',NULL,18,40,'App\\Models\\Like',19),
	(52,'2018-10-03 11:59:14.400400','2018-10-03 11:59:14.400400','j1b52e3980665465a99172ff7d6e9030','created','App\\Models\\Post',NULL,23,41,'App\\Models\\Like',14),
	(53,'2018-10-03 11:59:17.637400','2018-10-03 11:59:17.637400','rd132c927a5be40d5bc3bc388fa81f5d','created','App\\Models\\Comment',NULL,23,42,'App\\Models\\Like',14),
	(54,'2018-10-03 11:59:20.830600','2018-10-03 11:59:20.830600','mccd4160a4caa4a7ba0f6ca141c75f9a','created','App\\Models\\Post',NULL,19,43,'App\\Models\\Like',14),
	(55,'2018-10-03 12:15:24.531300','2018-10-03 12:15:24.531300','ecdd054183f4747b1b62fc3efe354dbe','created','App\\Models\\Post',NULL,23,44,'App\\Models\\Like',19),
	(56,'2018-10-03 15:33:07.842200','2018-10-03 15:33:07.842200','h4cb048c3679d43d9b19702017c383c9','created','App\\Models\\Post',NULL,22,45,'App\\Models\\Like',3),
	(57,'2018-10-03 15:33:08.091000','2018-10-03 15:33:08.091000','af6ed71c1b4f24abeb367ae67b20260a','created','App\\Models\\Post',NULL,17,46,'App\\Models\\Like',3),
	(58,'2018-10-03 17:28:06.454300','2018-10-03 17:28:06.454300','hee8f82930c5a48cc958c8cc2a880720','created','App\\Models\\Post',NULL,6,24,'App\\Models\\Comment',19),
	(59,'2018-10-03 17:28:33.786900','2018-10-03 17:28:33.786900','w8c8306bb2a464b5491aa797209470da','created','App\\Models\\Post',NULL,6,25,'App\\Models\\Comment',19),
	(60,'2018-10-03 17:30:28.687100','2018-10-03 17:30:28.687100','y00f534f21f164da3b81714abd44858c','created','App\\Models\\Post',NULL,19,26,'App\\Models\\Comment',19),
	(61,'2018-10-03 18:17:50.903500','2018-10-03 18:17:50.903500','f6f659b34bbf649aaa7f804877c04b1c','created','App\\Models\\Post',NULL,4,47,'App\\Models\\Like',3),
	(62,'2018-10-03 18:22:22.822700','2018-10-03 18:22:22.822700','k66fd194b31ce41c3b553ab8c839f557','created','App\\Models\\Post',NULL,24,24,'App\\Models\\Post',14),
	(63,'2018-10-03 18:27:34.787900','2018-10-03 18:27:34.787900','s4e8f9682f86d4d04bb4416d37dd4122','created','App\\Models\\Enrollment',NULL,44,44,'App\\Models\\Enrollment',3),
	(64,'2018-10-03 18:51:27.509100','2018-10-03 18:51:27.509100','x6b54709825d941c88b3aaefe6657dd1','created','App\\Models\\Post',NULL,25,25,'App\\Models\\Post',11),
	(65,'2018-10-03 19:24:58.453100','2018-10-03 19:24:58.453100','t58fb1df5238a4bc7aeb0f72458d5f4b','created','App\\Models\\Post',NULL,26,26,'App\\Models\\Post',11),
	(66,'2018-10-03 19:43:46.687000','2018-10-03 19:43:46.687000','pdab966db3f8542d8a05dc8280e28fd6','created','App\\Models\\Post',NULL,27,27,'App\\Models\\Post',11);

/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;


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
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;

INSERT INTO `posts` (`id`, `text`, `user_id`, `parent_id`, `parent_type`, `anonymous`, `created_at`, `updated_at`, `resource_key`, `deleted_at`, `edited_at`, `pinned`, `available_date`, `owner_id`, `owner_type`, `related_id`, `related_type`)
VALUES
	(1,'Elon Musk knows how to market space technology with sending a rocket with a \"Starman\" on a Tesla Roadster. A must see!',1,3,'App\\Models\\Course',0,'2018-08-28 00:21:09.203400','2018-08-28 00:21:13.836300','a94879b1c3b8e482babd7d8141d0d269',NULL,NULL,1,'2018-08-28 00:21:07',3,'App\\Models\\Course',3,'App\\Models\\Course'),
	(2,'I\'m having trouble understanding the different types of radiation. Can we go over that Monday?',14,3,'App\\Models\\Course',0,'2018-08-28 00:22:52.530000','2018-08-28 00:22:52.530000','jf4547db62c1e4a309a85db18fbaf4a8',NULL,NULL,0,'2018-08-28 00:22:50',3,'App\\Models\\Course',3,'App\\Models\\Course'),
	(3,'I need help with yesterday\'s lecture. Can someone please share their notes?',11,3,'App\\Models\\Course',0,'2018-08-28 00:24:44.315100','2018-08-28 00:24:44.315100','oba9021da33144e3aa35ea346c95a083',NULL,NULL,0,'2018-08-28 00:24:42',3,'App\\Models\\Course',3,'App\\Models\\Course'),
	(4,'Hey class - I am having trouble digesting the content in chapter 3 on what black hole formation looks like in Newtonian gravitation theory and how that differs from the relativistic case, can anyone help explain what this means?',2,3,'App\\Models\\Course',0,'2018-08-28 00:25:20.376000','2018-08-28 00:25:20.376000','re1ac9f174d0c4febb2d48e4075ce4cf',NULL,NULL,0,'2018-08-28 00:25:18',3,'App\\Models\\Course',3,'App\\Models\\Course'),
	(5,'Remember: make sure to check the assignment for tomorrow and ask questions below here.',3,3,'App\\Models\\Course',0,'2018-08-28 00:27:57.996600','2018-08-28 00:35:09.211300','c0c0908f08fb24edaa443172b7d8ff10','2018-08-28 00:35:09.211300','2018-08-28 00:28:25.367000',0,'2018-08-28 00:27:55',3,'App\\Models\\Course',3,'App\\Models\\Course'),
	(6,'Hi Class! Let\'s expand on our lecture from earlier today, how does social media impact politics and the news? What\'s a great example of this?',3,4,'App\\Models\\Course',0,'2018-08-28 00:35:54.170800','2018-08-28 00:35:54.170800','tcc103f3018c9471caae122e1b4630c0',NULL,NULL,0,'2018-08-28 00:35:52',4,'App\\Models\\Course',4,'App\\Models\\Course'),
	(7,'Hi Class! Check out this article that discusses the issues with the U.S. leaving the Human Rights Council. The article talks about many of the concepts from today\'s lecture!\nhttps://medium.com/s/story/why-a-great-customer-experience-can-be-even-more-important-than-the-product-d347e4dd3f6e',3,4,'App\\Models\\Course',0,'2018-09-26 10:29:49.888100','2018-09-26 10:33:29.435900','l4f54b6e284274e5fb76d3fc027b5f7f','2018-09-26 10:33:29.435900','2018-09-26 10:31:54.830900',0,'2018-09-26 10:29:47',4,'App\\Models\\Course',4,'App\\Models\\Course'),
	(8,'I\'m having trouble understanding the different types of radiation. Can we go over that Monday?',19,3,'App\\Models\\Course',0,'2018-09-26 10:38:30.627700','2018-09-26 10:39:09.087200','y1253bbcd5d1b48ecb3fd62dbdbd8725','2018-09-26 10:39:09.087200',NULL,0,'2018-09-26 10:38:28',3,'App\\Models\\Course',3,'App\\Models\\Course'),
	(9,'this post donetne matter ahah',19,13,'App\\Models\\Assignment',0,'2018-10-03 08:15:26.688000','2018-10-03 08:15:26.688000','la4a8b592a1214505a46cac4f4a93bc6',NULL,NULL,0,'2018-10-03 08:15:24',2,'App\\Models\\Course',13,'App\\Models\\Assignment'),
	(10,'oh hi hello it me and my post',14,13,'App\\Models\\Assignment',0,'2018-10-03 08:18:55.924400','2018-10-03 08:18:55.924400','b471ef224491b49818395a80dbc892ea',NULL,NULL,0,'2018-10-03 08:18:53',2,'App\\Models\\Course',13,'App\\Models\\Assignment'),
	(11,'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut porttitor velit metus, at consequat eros interdum quis. Vivamus pharetra, arcu eu pretium dapibus, leo mauris egestas neque, ac consectetur arcu orci eu magna. Sed vitae interdum velit. Aliquam nec sem feugiat, dapibus ipsum ac, pretium orci.',14,15,'App\\Models\\Assignment',0,'2018-10-03 08:20:10.360100','2018-10-03 08:20:10.360100','ib4869468b8d14647bf1abd1747f88da',NULL,NULL,0,'2018-10-03 08:20:08',2,'App\\Models\\Course',15,'App\\Models\\Assignment'),
	(12,'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut porttitor velit metus, at consequat eros interdum quis. Vivamus pharetra, arcu eu pretium dapibus, leo mauris egestas neque, ac consectetur arcu orci eu magna. Sed vitae interdum velit. Aliquam nec sem feugiat, dapibus ipsum ac, pretium orci. TWICE!!',14,15,'App\\Models\\Assignment',0,'2018-10-03 08:20:18.664400','2018-10-03 08:20:18.664400','g1eb5de69453e474eaf8c4b3db311079',NULL,NULL,0,'2018-10-03 08:20:16',2,'App\\Models\\Course',15,'App\\Models\\Assignment'),
	(13,'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut porttitor velit metus, at consequat eros interdum quis. Vivamus pharetra, arcu eu pretium dapibus, leo mauris egestas neque, ac consectetur arcu orci eu magna. Sed vitae interdum velit. Aliquam nec sem feugiat, dapibus ipsum ac, pretium orci.\n\nNunc convallis id massa sit amet posuere. Integer quis arcu id nulla bibendum efficitur. Fusce convallis ex tellus, ut sollicitudin urna dignissim et. Mauris gravida interdum tellus sed lacinia. Suspendisse fermentum mauris luctus metus venenatis facilisis. Sed erat justo, pellentesque at viverra vel, laoreet eget libero.\n\nAenean eu metus laoreet, feugiat mauris eget, vulputate purus. Curabitur lacinia sed arcu auctor molestie. Cras in finibus velit, at vestibulum quam. Aenean urna lacus, ultricies vel erat sit amet, pellentesque viverra massa. Phasellus ut sapien eu nisl pellentesque semper. Cras volutpat turpis elit. Morbi vel eros sapien. Donec nulla quam, tincidunt eget dapibus vel, fermentum eu purus. Nullam ac convallis augue. Cras viverra efficitur feugiat. Vivamus eget libero eu purus feugiat blandit. Sed dignissim dictum fringilla. Integer lobortis erat in orci cursus, id pulvinar sem feugiat. Sed et turpis felis. Pellentesque nec odio sit amet purus eleifend condimentum.\n\nInterdum et malesuada fames ac ante ipsum primis in faucibus. Praesent consequat enim at ligula semper bibendum. Sed iaculis elit sit amet consectetur gravida. Fusce quis est mollis, viverra enim a, imperdiet augue. Curabitur id dui eu sapien posuere tincidunt scelerisque id tortor. Praesent condimentum molestie urna, in iaculis lectus facilisis nec. Pellentesque finibus non ante vel dignissim. Aenean pharetra mollis leo eu vulputate. Vivamus eleifend, tellus id efficitur volutpat, massa ligula gravida eros, vulputate eleifend eros neque feugiat leo. Quisque eleifend, enim non mattis aliquam, ipsum dolor ullamcorper dui, ut pharetra urna odio ut ipsum. Etiam tempor felis a scelerisque molestie. Maecenas efficitur ex vitae odio viverra, in tristique augue facilisis. Quisque porttitor gravida viverra. Curabitur blandit lobortis nulla, at mollis ante tempus vel. Duis tincidunt dui vel urna maximus placerat. Vivamus volutpat et purus eu aliquet.',14,12,'App\\Models\\Assignment',0,'2018-10-03 08:21:06.117500','2018-10-03 08:21:06.117500','wb4c92544c20049dfa6e41391c520ce8',NULL,NULL,0,'2018-10-03 08:21:04',2,'App\\Models\\Course',12,'App\\Models\\Assignment'),
	(14,'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In sagittis vitae turpis non aliquet. Nunc ac vehicula leo. Ut placerat efficitur posuere. Nunc lorem velit, ultricies volutpat justo ut, consequat ultrices nisi. Quisque sit amet feugiat mi. Nullam viverra lobortis faucibus. Sed volutpat placerat lorem et congue. Nunc fermentum iaculis lorem, sed facilisis mi efficitur consequat. Sed magna elit, facilisis nec elit non, gravida egestas justo. Ut eleifend sem a turpis posuere, ut varius est vulputate. Proin et rhoncus augue. Praesent vel ante lacus. Pellentesque ultrices et tellus nec dignissim. Vivamus ac aliquam massa, a tempus lorem.',14,12,'App\\Models\\Assignment',0,'2018-10-03 08:21:41.095600','2018-10-03 08:21:41.095600','qa4ee0d181b90496f8f267c1f8cc66c0',NULL,NULL,0,'2018-10-03 08:21:39',2,'App\\Models\\Course',12,'App\\Models\\Assignment'),
	(15,'ullable column means that you can insert Null for the columns value. If it\'s not a nullable column, you have to insert some value of that data type. So, for existing records, Null will be inserted in them and in new records, your default value will be inserted unless otherwise specified. Make sense?',14,16,'App\\Models\\Assignment',0,'2018-10-03 08:22:39.248500','2018-10-03 08:22:39.248500','v840785128e5948afa3204442b9d9f93',NULL,NULL,0,'2018-10-03 08:22:37',2,'App\\Models\\Course',16,'App\\Models\\Assignment'),
	(16,'I like this answer a little better than dbugger\'s because it explicitly names the default constraint. A default constraint is still created using dbugger\'s syntax, except its name is auto-generated. Knowing the exact name is handy when writing DROP-CREATE scripts.',14,16,'App\\Models\\Assignment',0,'2018-10-03 08:22:54.600800','2018-10-03 08:22:54.600800','v002d541dc31b4b85897615151e8a466',NULL,NULL,0,'2018-10-03 08:22:52',2,'App\\Models\\Course',16,'App\\Models\\Assignment'),
	(17,'This query will give us John, Sam, Tom, Tom because they all have the same email.\n\nHowever, what I want is to get duplicates with the same email and name.\n\nThat is, I want to get \"Tom\", \"Tom\".\n\nThe reason I need this: I made a mistake, and allowed to insert duplicate name and email values. Now I need to remove/change the duplicates, so I need to find them first.',14,14,'App\\Models\\Assignment',0,'2018-10-03 08:23:38.889400','2018-10-03 08:23:38.889400','ze99ca9d1df0049c3af0f1a740861284',NULL,NULL,0,'2018-10-03 08:23:36',2,'App\\Models\\Course',14,'App\\Models\\Assignment'),
	(18,'it onkly one one goeje eoe',19,16,'App\\Models\\Assignment',0,'2018-10-03 08:46:20.298100','2018-10-03 08:46:20.298100','q750dedae2d4e4cd89b342a551cac99e',NULL,NULL,0,'2018-10-03 08:46:18',2,'App\\Models\\Course',16,'App\\Models\\Assignment'),
	(19,'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas porttitor, lectus eu scelerisque gravida, tortor elit dapibus diam, non rhoncus felis eros et sapien. Donec id arcu ut quam posuere pharetra in eget ipsum. Vivamus et fermentum nibh. Ut tristique leo lorem. Morbi at nulla vitae sapien auctor venenatis eget ut quam. Maecenas mollis sagittis hendrerit. Phasellus et sapien et urna tincidunt aliquet. Aliquam non viverra orci, at placerat purus. Fusce bibendum dignissim nisl, eget ultricies augue maximus vitae. Ut iaculis justo porttitor enim vulputate, quis porttitor arcu tincidunt. Suspendisse potenti. Quisque viverra felis id tellus dignissim sodales. Fusce molestie blandit sodales. Pellentesque ut nisi vitae orci laoreet tempus a in turpis. Pellentesque at risus sed turpis porta tincidunt vitae id sem.\n\nUt bibendum magna id ullamcorper sodales. Maecenas pretium eget massa vitae gravida. Duis aliquam risus sit amet semper volutpat. Ut finibus leo mi, ut interdum dolor egestas sit amet. Praesent eget congue libero. Mauris dignissim lacus sed massa finibus, in mattis ligula commodo. Donec sagittis lacus et leo ultricies eleifend.\n\nNullam varius nulla metus, quis porta elit viverra et. Pellentesque congue mattis leo. Fusce efficitur risus eu magna iaculis fermentum. Mauris non accumsan augue. Curabitur sit amet tincidunt ante. Donec viverra tempor lorem a fermentum. Donec semper, dui ut gravida dictum, eros lacus euismod dui, nec placerat elit lacus non tortor. Lorem ipsum dolor sit amet, consectetur adipiscing.',19,12,'App\\Models\\Assignment',0,'2018-10-03 08:46:43.622200','2018-10-03 08:46:43.622200','bb2fa14d4450d4a39ba977b0187e224e',NULL,NULL,0,'2018-10-03 08:46:41',2,'App\\Models\\Course',12,'App\\Models\\Assignment'),
	(20,'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas porttitor, lectus eu scelerisque gravida, tortor elit dapibus diam, non rhoncus felis eros et sapien. Donec id arcu ut quam posuere pharetra in eget ipsum. Vivamus et fermentum nibh. Ut tristique leo lorem. Morbi at nulla vitae sapien auctor venenatis eget ut quam. Maecenas mollis sagittis hendrerit. Phasellus et sapien et urna tincidunt aliquet. Aliquam non viverra orci, at placerat purus. Fusce bibendum dignissim nisl, eget ultricies augue maximus vitae. Ut iaculis justo porttitor enim vulputate, quis porttitor arcu tincidunt. Suspendisse potenti. Quisque viverra felis id tellus dignissim sodales. Fusce molestie blandit sodales. Pellentesque ut nisi vitae orci laoreet tempus a in turpis. Pellentesque at risus sed turpis porta tincidunt vitae id sem.',19,12,'App\\Models\\Assignment',0,'2018-10-03 08:46:52.760700','2018-10-03 08:46:52.760700','rf48cf881710a46b68792e72cfabe073',NULL,NULL,0,'2018-10-03 08:46:50',2,'App\\Models\\Course',12,'App\\Models\\Assignment'),
	(21,'sure why nrteo hahaah',19,15,'App\\Models\\Assignment',0,'2018-10-03 08:47:14.510399','2018-10-03 08:47:14.510399','wd5f97e46b2d84e5c8454b4ca66667d8',NULL,NULL,0,'2018-10-03 08:47:12',2,'App\\Models\\Course',15,'App\\Models\\Assignment'),
	(22,'ok fine ifien fine',19,14,'App\\Models\\Assignment',0,'2018-10-03 08:54:41.424400','2018-10-03 08:54:41.424400','s4d74c0bc98944e1dafa017653e2a0ac',NULL,NULL,0,'2018-10-03 08:54:39',2,'App\\Models\\Course',14,'App\\Models\\Assignment'),
	(23,'come on now boyos',3,12,'App\\Models\\Assignment',0,'2018-10-03 08:57:55.265100','2018-10-03 08:57:55.265100','f5e2a386483504ebf9851c9999ca9299',NULL,NULL,0,'2018-10-03 08:57:53',2,'App\\Models\\Course',12,'App\\Models\\Assignment'),
	(24,'this is a post that does not have enough words ok',14,12,'App\\Models\\Assignment',0,'2018-10-03 18:22:21.312800','2018-10-03 18:22:21.312800','z41e97a81645f46029d2f368d09d0fca',NULL,NULL,0,'2018-10-03 18:22:19',2,'App\\Models\\Course',12,'App\\Models\\Assignment'),
	(25,'suck it boyos',11,16,'App\\Models\\Assignment',0,'2018-10-03 18:51:24.734100','2018-10-03 18:51:24.734100','g89b359cee3a445f9a50cd694231c302',NULL,NULL,0,'2018-10-03 18:51:22',2,'App\\Models\\Course',16,'App\\Models\\Assignment'),
	(26,'new post lest cl',11,16,'App\\Models\\Assignment',0,'2018-10-03 19:24:55.943300','2018-10-03 19:24:55.943300','a178c731c32f548dabfa9edae945c44e',NULL,NULL,0,'2018-10-03 19:24:53',2,'App\\Models\\Course',16,'App\\Models\\Assignment'),
	(27,'new post',11,16,'App\\Models\\Assignment',0,'2018-10-03 19:43:44.725000','2018-10-03 19:43:44.725000','yea3f76ac328d4c14a13b71d0ed295ed',NULL,NULL,0,'2018-10-03 19:43:42',2,'App\\Models\\Course',16,'App\\Models\\Assignment'),
	(28,'ok let\'s-a go',19,12,'App\\Models\\Assignment',0,'2018-10-04 22:22:06.681000','2018-10-04 22:22:06.681000','h4e5ff8df0e4940768703e6741577777',NULL,NULL,0,'2018-10-04 22:22:04',2,'App\\Models\\Course',12,'App\\Models\\Assignment'),
	(29,'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In sagittis vitae turpis non aliquet. Nunc ac vehicula leo. Ut placerat efficitur posuere. Nunc lorem velit, ultricies volutpat justo ut, consequat ultrices nisi. Quisque sit amet feugiat mi. Nullam viverra lobortis faucibus. Sed volutpat placerat lorem et congue. Nunc fermentum iaculis lorem, sed facilisis mi efficitur consequat. Sed magna elit, facilisis nec elit non, gravida egestas justo. Ut eleifend sem a turpis posuere, ut varius est vulputate. Proin et rhoncus augue. Praesent vel ante lacus. Pellentesque ultrices et tellus nec dignissim. Vivamus ac aliquam massa, a tempus lorem.\n\nUt sed varius erat. Aenean quis turpis a metus tristique hendrerit ut sed ipsum. Suspendisse ac arcu gravida, tempus libero lacinia, sollicitudin ex. In ut tortor dignissim, mattis elit quis, volutpat risus. Donec id nulla diam. Curabitur nec ex sit amet leo malesuada mattis in in sem. Sed aliquam molestie tellus in faucibus. Suspendisse scelerisque arcu dui, non tincidunt nibh imperdiet volutpat. Morbi interdum quis nibh a interdum. Duis ullamcorper arcu sed ex viverra, eget scelerisque orci malesuada. Phasellus a cursus velit. Proin mi arcu, tincidunt sed sagittis nec, semper nec turpis. Etiam quis eros eu lorem luctus sodales. Aliquam nec nulla ullamcorper, semper urna pretium, tristique massa.\n\nInteger eget vehicula metus. Nam mollis, nulla nec finibus tempor, magna dolor accumsan massa, et facilisis lorem quam eleifend nibh. Phasellus dolor enim, efficitur sit.',19,12,'App\\Models\\Assignment',0,'2018-10-04 22:23:27.429900','2018-10-04 22:23:27.429900','ldbaf20ab122d466eb75eed64f9f571e',NULL,NULL,0,'2018-10-04 22:23:25',2,'App\\Models\\Course',12,'App\\Models\\Assignment');

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `resource_aliases` WRITE;
/*!40000 ALTER TABLE `resource_aliases` DISABLE KEYS */;

INSERT INTO `resource_aliases` (`id`, `resource_id`, `resource_type`, `resource_key`, `created_at`, `updated_at`, `deleted_at`)
VALUES
	(1,2,'App\\Models\\Course','k71c7530b59c04ab3b9eccca9b553aa5','2018-10-03 08:58:52.451400','2018-10-03 08:58:52.451400',NULL);

/*!40000 ALTER TABLE `resource_aliases` ENABLE KEYS */;
UNLOCK TABLES;


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
) ENGINE=InnoDB AUTO_INCREMENT=2162 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
	(88,3,'App\\Models\\Course','lc70cff6d40844d52b9927fa9a406a13','2018-08-28 00:04:20','2018-08-28 00:04:20'),
	(89,11,'App\\Models\\Category','v46402c7b431a4aea80ae220eec5263f','2018-08-28 00:04:20','2018-08-28 00:04:20'),
	(90,12,'App\\Models\\Category','ebaa086f7065d4c3c86781403b3aab5f','2018-08-28 00:04:20','2018-08-28 00:04:20'),
	(91,13,'App\\Models\\Category','m9fb083f87d3941f987253b40638c738','2018-08-28 00:04:20','2018-08-28 00:04:20'),
	(92,14,'App\\Models\\Category','xc97a04a91e4e461c8bdaf1ee57397a9','2018-08-28 00:04:20','2018-08-28 00:04:20'),
	(95,1,'App\\Models\\Attachment','vfc60395a035d41069bf6f8263557350','2018-08-28 00:05:21','2018-08-28 00:05:21'),
	(97,26,'App\\Models\\Enrollment','v10654dbd44574da4a7fc36cbda7f976','2018-08-28 00:05:35','2018-08-28 00:05:35'),
	(99,27,'App\\Models\\Enrollment','y2dfd06aceeb94d648c36ee201dbad72','2018-08-28 00:06:02','2018-08-28 00:06:02'),
	(128,28,'App\\Models\\Enrollment','k4ee0d0024c6f408fbebb772b4ebf9b5','2018-08-28 00:14:03','2018-08-28 00:14:03'),
	(130,29,'App\\Models\\Enrollment','b4f4c2a8e695f4ecca11e7aca71b0a4d','2018-08-28 00:14:11','2018-08-28 00:14:11'),
	(132,30,'App\\Models\\Enrollment','g6a3da4f992d74e63bf73335a3d7f9b7','2018-08-28 00:14:32','2018-08-28 00:14:32'),
	(134,31,'App\\Models\\Enrollment','sba6718e290774e3f98feb07a51bd332','2018-08-28 00:14:38','2018-08-28 00:14:38'),
	(140,2,'App\\Models\\Assignment','zcda01b14200644a79a16126992f807a','2018-08-28 00:15:59','2018-08-28 00:15:59'),
	(147,3,'App\\Models\\Assignment','h1e210e3ce3aa43a5b3fde8547648cce','2018-08-28 00:16:47','2018-08-28 00:16:47'),
	(154,4,'App\\Models\\Assignment','d74943de54eef49108523c16ac493e86','2018-08-28 00:18:19','2018-08-28 00:18:19'),
	(155,1,'App\\Models\\AssignmentGroup','u7129256ba9ac406bab45cb471a1ec48','2018-08-28 00:18:19','2018-08-28 00:18:19'),
	(156,2,'App\\Models\\AssignmentGroup','xe4f2cc7ff1024db0b94ba891fa0319d','2018-08-28 00:18:19','2018-08-28 00:18:19'),
	(163,5,'App\\Models\\Assignment','ud7c1186e1a44432a963cdacd4368e4d','2018-08-28 00:19:01','2018-08-28 00:19:01'),
	(170,6,'App\\Models\\Assignment','c40d8a7ce79894a879ee92d410052626','2018-08-28 00:19:56','2018-08-28 00:19:56'),
	(177,7,'App\\Models\\Assignment','lf1f97d5feb6746769401727a7d7988e','2018-08-28 00:20:30','2018-08-28 00:20:30'),
	(190,1,'App\\Models\\Post','a94879b1c3b8e482babd7d8141d0d269','2018-08-28 00:21:09','2018-08-28 00:21:09'),
	(194,2,'App\\Models\\Post','jf4547db62c1e4a309a85db18fbaf4a8','2018-08-28 00:22:53','2018-08-28 00:22:53'),
	(196,1,'App\\Models\\Like','we313ecb37dba45f599960437c86c59a','2018-08-28 00:22:56','2018-08-28 00:22:56'),
	(197,1,'App\\Models\\Comment','jf1833e8545654e0abdbd81b7a422d4b','2018-08-28 00:23:09','2018-08-28 00:23:09'),
	(200,2,'App\\Models\\Like','w8f15d0da416e44018a06451e4f2d64a','2018-08-28 00:23:44','2018-08-28 00:23:44'),
	(201,2,'App\\Models\\Comment','ff9c7c33fcb5d4d49b66cc8d2f9cdff6','2018-08-28 00:23:51','2018-08-28 00:23:51'),
	(204,3,'App\\Models\\Comment','aece9a9845f6b47d481c171b95cba06e','2018-08-28 00:24:25','2018-08-28 00:24:25'),
	(206,3,'App\\Models\\Like','v4248ce55a97f46918d4e9a338b7d336','2018-08-28 00:24:28','2018-08-28 00:24:28'),
	(207,4,'App\\Models\\Like','fb3acf4cd02b44e23b0f931dd2547e72','2018-08-28 00:24:30','2018-08-28 00:24:30'),
	(208,5,'App\\Models\\Like','m6811f0cfd7294d6bbe57d7eb74eac50','2018-08-28 00:24:32','2018-08-28 00:24:32'),
	(209,3,'App\\Models\\Post','oba9021da33144e3aa35ea346c95a083','2018-08-28 00:24:44','2018-08-28 00:24:44'),
	(212,4,'App\\Models\\Post','re1ac9f174d0c4febb2d48e4075ce4cf','2018-08-28 00:25:20','2018-08-28 00:25:20'),
	(214,6,'App\\Models\\Like','s16f0d5641c1749e38f2530f246d9589','2018-08-28 00:25:24','2018-08-28 00:25:24'),
	(215,7,'App\\Models\\Like','d12c3122259d746978548c90418301df','2018-08-28 00:25:27','2018-08-28 00:25:27'),
	(216,4,'App\\Models\\Comment','sf822f7043fd3412cb1c32b818ac8258','2018-08-28 00:25:36','2018-08-28 00:25:36'),
	(219,5,'App\\Models\\Comment','k65fbc2e78d884ff8bed9cd133115b8c','2018-08-28 00:26:13','2018-08-28 00:26:13'),
	(221,8,'App\\Models\\Like','ve75e4fd429ff4f0e89b77edbca60f74','2018-08-28 00:26:19','2018-08-28 00:26:19'),
	(222,9,'App\\Models\\Like','u305eee9ec87e47c596b5da8bff38131','2018-08-28 00:26:20','2018-08-28 00:26:20'),
	(223,6,'App\\Models\\Comment','t937f86900159428eb470f6b13be8d09','2018-08-28 00:26:30','2018-08-28 00:26:30'),
	(226,7,'App\\Models\\Comment','zb0f9f713f87c4daf995245fbe004f92','2018-08-28 00:27:36','2018-08-28 00:27:36'),
	(228,5,'App\\Models\\Post','c0c0908f08fb24edaa443172b7d8ff10','2018-08-28 00:27:58','2018-08-28 00:27:58'),
	(232,8,'App\\Models\\Comment','hc16cc4a29bdf4ed79838367aa4b5aec','2018-08-28 00:29:04','2018-08-28 00:29:04'),
	(235,10,'App\\Models\\Like','e89718922b5da4afb894199de6f90968','2018-08-28 00:29:16','2018-08-28 00:29:16'),
	(236,11,'App\\Models\\Like','lb3091d6f103d46e4bdd565a6f530e7a','2018-08-28 00:29:17','2018-08-28 00:29:17'),
	(237,12,'App\\Models\\Like','p760b01cadbab4b61a9355b58b0299e4','2018-08-28 00:29:30','2018-08-28 00:29:30'),
	(239,4,'App\\Models\\Course','le4acf50aaacc4d86a8ad041040cfa3d','2018-08-28 00:31:37','2018-08-28 00:31:37'),
	(240,15,'App\\Models\\Category','h9dd69f4d0f374a988c721ce9b7b4427','2018-08-28 00:31:37','2018-08-28 00:31:37'),
	(241,16,'App\\Models\\Category','t0b78731421654b3fa51ad176e3595e4','2018-08-28 00:31:37','2018-08-28 00:31:37'),
	(242,17,'App\\Models\\Category','p9c0b53a782d14343a0f8b807b750310','2018-08-28 00:31:37','2018-08-28 00:31:37'),
	(243,18,'App\\Models\\Category','ba577b1d62d4c4c0aac86e3bea5572e6','2018-08-28 00:31:37','2018-08-28 00:31:37'),
	(245,32,'App\\Models\\Enrollment','j521e4337397c4b2484eabf265e314cd','2018-08-28 00:31:52','2018-08-28 00:31:52'),
	(247,5,'App\\Models\\Course','s5802ee9570f642b28342df283d297af','2018-08-28 00:32:18','2018-08-28 00:32:18'),
	(248,19,'App\\Models\\Category','k6070cceae4dd487c8ccbf97ac266c4a','2018-08-28 00:32:18','2018-08-28 00:32:18'),
	(249,20,'App\\Models\\Category','x1e7bb8906106448f8c310cd19a05aa4','2018-08-28 00:32:18','2018-08-28 00:32:18'),
	(250,21,'App\\Models\\Category','s0b455be6df484204ba56cfc9ad68cca','2018-08-28 00:32:18','2018-08-28 00:32:18'),
	(251,22,'App\\Models\\Category','idc8a7cbf118a41d8af1ca4af4fda1cb','2018-08-28 00:32:18','2018-08-28 00:32:18'),
	(254,33,'App\\Models\\Enrollment','obd58aaaf121440c8afa9b47d25522af','2018-08-28 00:32:38','2018-08-28 00:32:38'),
	(256,6,'App\\Models\\Course','d4f7a84149dff4e92a9180d8d97bdd1c','2018-08-28 00:33:06','2018-08-28 00:33:06'),
	(257,23,'App\\Models\\Category','f1e675f1084df446f8f7a1344c6fbf30','2018-08-28 00:33:06','2018-08-28 00:33:06'),
	(258,24,'App\\Models\\Category','e50df2b1949cf40af859f69b12352c47','2018-08-28 00:33:06','2018-08-28 00:33:06'),
	(259,25,'App\\Models\\Category','w20b91ea07ab04205b22718aae7aab2c','2018-08-28 00:33:06','2018-08-28 00:33:06'),
	(260,26,'App\\Models\\Category','x6b36728ae84d480b88f5b23de0684e2','2018-08-28 00:33:06','2018-08-28 00:33:06'),
	(262,34,'App\\Models\\Enrollment','yb1f56e05de0b4d0fa9947708cafb791','2018-08-28 00:33:19','2018-08-28 00:33:19'),
	(264,35,'App\\Models\\Enrollment','h8c1d469106224e308f0704c03ab98ac','2018-08-28 00:34:25','2018-08-28 00:34:25'),
	(325,6,'App\\Models\\Post','tcc103f3018c9471caae122e1b4630c0','2018-08-28 00:35:54','2018-08-28 00:35:54'),
	(327,13,'App\\Models\\Like','df07e6e27dceb4b04b2071840ab5d00d','2018-08-28 00:36:31','2018-08-28 00:36:31'),
	(329,14,'App\\Models\\Like','o620f30c116314db088f1fb59e8a5f87','2018-08-28 00:36:50','2018-08-28 00:36:50'),
	(330,15,'App\\Models\\Like','a54c46e4cef0b4183ac9a2fc6bece1ac','2018-08-28 00:36:53','2018-08-28 00:36:53'),
	(331,16,'App\\Models\\Like','l8d32c7e41a3d450b89caeb30f9746e0','2018-08-28 00:37:02','2018-08-28 00:37:02'),
	(332,17,'App\\Models\\Like','o5478dbd4913645fd894f8077beb5821','2018-08-28 00:37:06','2018-08-28 00:37:06'),
	(335,18,'App\\Models\\Like','g8a90658e9e004ef2844fd02c01e6a57','2018-08-28 00:39:54','2018-08-28 00:39:54'),
	(336,19,'App\\Models\\Like','r8930f48279a541b1a09b3da22a6dbf3','2018-08-28 00:39:56','2018-08-28 00:39:56'),
	(337,20,'App\\Models\\Like','z4f38a1260ec441da86d3fa5c4ab219f','2018-08-28 00:39:58','2018-08-28 00:39:58'),
	(351,19,'App\\Models\\User','wf8be385309224b6c86e04323fa4a28d','2018-09-26 10:11:31','2018-09-26 10:11:31'),
	(358,36,'App\\Models\\Enrollment','c743abe115b3f461b941e0663793dabe','2018-09-26 10:13:11','2018-09-26 10:13:11'),
	(360,37,'App\\Models\\Enrollment','o18f7bc6aa08a48c88193d81c5711297','2018-09-26 10:13:18','2018-09-26 10:13:18'),
	(362,38,'App\\Models\\Enrollment','fd57a22fac4504224aca1f3f35d2bed3','2018-09-26 10:13:32','2018-09-26 10:13:32'),
	(364,39,'App\\Models\\Enrollment','tcf0c892941ac47f2a5cb5a53f2e370c','2018-09-26 10:13:40','2018-09-26 10:13:40'),
	(366,40,'App\\Models\\Enrollment','oce9884d9693b43da8e1338d7d30a7f2','2018-09-26 10:13:50','2018-09-26 10:13:50'),
	(368,41,'App\\Models\\Enrollment','pc672a14c4b3342b9a1260a09f063223','2018-09-26 10:14:01','2018-09-26 10:14:01'),
	(370,42,'App\\Models\\Enrollment','xd3d0cead258c43eb8580b75eec2a04f','2018-09-26 10:14:11','2018-09-26 10:14:11'),
	(384,7,'App\\Models\\Post','l4f54b6e284274e5fb76d3fc027b5f7f','2018-09-26 10:29:50','2018-09-26 10:29:50'),
	(391,2,'App\\Models\\Attachment','o3dc3c351a35e48d9833efe240cdf63a','2018-09-26 10:31:37','2018-09-26 10:31:37'),
	(394,9,'App\\Models\\Comment','uceefd7ae300741839fb0e6a888c1209','2018-09-26 10:33:14','2018-09-26 10:33:14'),
	(402,10,'App\\Models\\Comment','if1705eef7d8c487587f2a5f947f4c53','2018-09-26 10:37:26','2018-09-26 10:37:26'),
	(404,21,'App\\Models\\Like','y2722f35e784948a986c9de554f1bda9','2018-09-26 10:37:29','2018-09-26 10:37:29'),
	(406,11,'App\\Models\\Comment','e028722bd85ce4ae5b9330e0d709a998','2018-09-26 10:37:57','2018-09-26 10:37:57'),
	(408,8,'App\\Models\\Post','y1253bbcd5d1b48ecb3fd62dbdbd8725','2018-09-26 10:38:31','2018-09-26 10:38:31'),
	(410,22,'App\\Models\\Like','s592a4de118b340c98a5a3deacaa1b87','2018-09-26 10:38:54','2018-09-26 10:38:54'),
	(411,23,'App\\Models\\Like','lc183695e9e6a46ea9d64c00612565a7','2018-09-26 10:39:00','2018-09-26 10:39:00'),
	(413,24,'App\\Models\\Like','i49940a3bcf24405da5dee496498a349','2018-09-26 10:39:13','2018-09-26 10:39:13'),
	(414,25,'App\\Models\\Like','k3839c8b3ab48438daf54ba19029d650','2018-09-26 10:39:15','2018-09-26 10:39:15'),
	(417,26,'App\\Models\\Like','o061be9a99dd748ac9b01ee8714c724d','2018-09-26 10:42:13','2018-09-26 10:42:13'),
	(418,27,'App\\Models\\Like','c838e3c43230b410485127d1785e5ec9','2018-09-26 10:42:16','2018-09-26 10:42:16'),
	(423,28,'App\\Models\\Like','qf5a5c43068864b3f861624075f0816d','2018-09-26 10:44:46','2018-09-26 10:44:46'),
	(424,29,'App\\Models\\Like','bd68b8e4c99e147c2b135c4b1081bdaa','2018-09-26 10:44:48','2018-09-26 10:44:48'),
	(425,30,'App\\Models\\Like','z538a0040c5af4784b8a2264b43600d6','2018-09-26 10:44:52','2018-09-26 10:44:52'),
	(503,1,'App\\Models\\Grade','k686eed2e071b4aec80916f80bf13945','2018-09-26 10:49:33','2018-09-26 10:49:33'),
	(505,2,'App\\Models\\Grade','s0508c40eac7041f3af03e45eb4b337d','2018-09-26 10:49:47','2018-09-26 10:49:47'),
	(518,1,'App\\Models\\Submission','tadcbd55243e04a2a95304d5f2aaad82','2018-09-26 10:52:30','2018-09-26 10:52:30'),
	(525,1,'App\\Models\\AssignmentGroupUser','a5f0b21877203401995a8166a7edfb80','2018-09-26 10:52:42','2018-09-26 10:52:42'),
	(531,2,'App\\Models\\Submission','re79098faf34d49adbef3cdcf53471af','2018-09-26 10:52:53','2018-09-26 10:52:53'),
	(543,3,'App\\Models\\Submission','j995cdb2ae0f2435eb47c78a5409885a','2018-09-26 10:53:20','2018-09-26 10:53:20'),
	(557,3,'App\\Models\\Grade','iff26558edd9f4dc5b791d314d176c31','2018-09-26 10:54:47','2018-09-26 10:54:47'),
	(570,4,'App\\Models\\Grade','z76b4f5782c574048ae656d14361fedc','2018-09-26 10:55:16','2018-09-26 10:55:16'),
	(581,5,'App\\Models\\Grade','b2df00d7170b3438abd59aec5447cb13','2018-09-26 10:55:34','2018-09-26 10:55:34'),
	(592,1,'App\\Models\\Setting','p7fb866eda92742ab82e454f2d3893b4','2018-09-26 10:56:26','2018-09-26 10:56:26'),
	(594,2,'App\\Models\\Setting','g1431d419ba0c478184512dd33ebc8f0','2018-09-26 10:56:59','2018-09-26 10:56:59'),
	(596,31,'App\\Models\\Like','bebaebbb75739479e88092e7e1e364ef','2018-09-26 10:58:32','2018-09-26 10:58:32'),
	(603,32,'App\\Models\\Like','r408199180eec4ab28cccb48991ca702','2018-09-26 10:59:06','2018-09-26 10:59:06'),
	(734,1,'App\\Models\\Assessment','o15e7d4535b8146ac90a7b1ed6d33b18','2018-09-26 12:34:58','2018-09-26 12:34:58'),
	(735,1,'App\\Models\\AssessmentQuestion','jcf15cee17720464d9bed0f21bec0855','2018-09-26 12:34:59','2018-09-26 12:34:59'),
	(737,2,'App\\Models\\AssessmentQuestion','l8adc1c73e05446639ac701a9f0759cb','2018-09-26 12:34:59','2018-09-26 12:34:59'),
	(743,1,'App\\Models\\AssessmentAnswer','l194867ea15ba47ac99648d28086a95e','2018-09-26 12:35:05','2018-09-26 12:35:05'),
	(747,2,'App\\Models\\AssessmentAnswer','l1e4e00b7ac404976bd2f2c92787fd87','2018-09-26 12:35:09','2018-09-26 12:35:09'),
	(759,1,'App\\Models\\AssessmentSubmission','c2be94e00f7ba4d1b983c890498999c5','2018-09-26 12:36:20','2018-09-26 12:36:20'),
	(761,1,'App\\Models\\AssessmentResponse','x1dd38a211aef4d1f9a2e19ecc9fe03a','2018-09-26 12:36:22','2018-09-26 12:36:22'),
	(763,6,'App\\Models\\Grade','ff3e118205b06457f9a8a3b9ce5bca4f','2018-09-26 12:36:22','2018-09-26 12:36:22'),
	(765,7,'App\\Models\\Grade','z173bdab11e484eb584360abd65e326f','2018-09-26 12:36:22','2018-09-26 12:36:22'),
	(910,33,'App\\Models\\Like','zf823070d830a4faf884e947f3f681df','2018-09-26 19:49:08','2018-09-26 19:49:08'),
	(911,1,'App\\Models\\Notification','z017c38cd04a84fdd9097b1dbe667bff','2018-09-26 19:49:10','2018-09-26 19:49:10'),
	(923,2,'App\\Models\\Notification','k07344dc4a5d441bfb5e95c3abe4c592','2018-09-26 19:50:50','2018-09-26 19:50:50'),
	(925,3,'App\\Models\\Notification','ed2dcaf3bdd1348e3a8a8dd50a8a1d68','2018-09-26 19:50:59','2018-09-26 19:50:59'),
	(932,4,'App\\Models\\Notification','h57dac006f51140e7ac4b57b2568cb77','2018-09-26 19:51:30','2018-09-26 19:51:30'),
	(939,8,'App\\Models\\Assignment','oc845a1e5fc944b82ac6bdc91d7b7155','2018-09-26 19:53:21','2018-09-26 19:53:21'),
	(943,5,'App\\Models\\Notification','rd2a805567e8045efa1349de50e24c95','2018-09-26 19:53:22','2018-09-26 19:53:22'),
	(949,9,'App\\Models\\Assignment','h2c18ba321e834175838d08ef18f5573','2018-09-26 19:54:02','2018-09-26 19:54:02'),
	(954,6,'App\\Models\\Notification','ne494d6d305a4413db0e66ee93df8466','2018-09-26 19:54:05','2018-09-26 19:54:05'),
	(959,12,'App\\Models\\Comment','v01b4ab8266dd46e39558b1728a37c33','2018-09-26 19:54:31','2018-09-26 19:54:31'),
	(961,7,'App\\Models\\Notification','xd3acd7d6addf43a690552f08a1a329b','2018-09-26 19:54:32','2018-09-26 19:54:32'),
	(1059,10,'App\\Models\\Assignment','z51235fd8ecd340949043e24b101c449','2018-09-26 21:14:20','2018-09-26 21:14:20'),
	(1072,11,'App\\Models\\Assignment','iddef06c406e74b9ea41a067887638f8','2018-09-26 21:14:57','2018-09-26 21:14:57'),
	(1086,2,'App\\Models\\Assessment','r35c03c2c16b4420d89db80a448d720f','2018-09-26 21:17:14','2018-09-26 21:17:14'),
	(1087,3,'App\\Models\\AssessmentQuestion','abc3982a59b994cb58ccc7dc89c15511','2018-09-26 21:17:14','2018-09-26 21:17:14'),
	(1089,4,'App\\Models\\AssessmentQuestion','me4869d78c32044a9a32eea49146a144','2018-09-26 21:17:14','2018-09-26 21:17:14'),
	(1121,12,'App\\Models\\Assignment','b1c2b15eb6a08475abad26157eec08bb','2018-10-03 07:49:03','2018-10-03 07:49:03'),
	(1144,13,'App\\Models\\Assignment','pa835c2a277fc47bc9b711b946d6347c','2018-10-03 07:57:51','2018-10-03 07:57:51'),
	(1149,14,'App\\Models\\Assignment','dbef7c72a5f5847bb8bf5408b656a22e','2018-10-03 08:01:45','2018-10-03 08:01:45'),
	(1154,15,'App\\Models\\Assignment','d57244187ffb74ab6ad9ae2de335906a','2018-10-03 08:02:40','2018-10-03 08:02:40'),
	(1171,16,'App\\Models\\Assignment','h1c82abfa37ba4d89a5470658c61df9d','2018-10-03 08:05:01','2018-10-03 08:05:01'),
	(1214,8,'App\\Models\\Notification','g5c9b6add9d4d4b5f8535a2537968ad6','2018-10-03 08:11:38','2018-10-03 08:11:38'),
	(1215,9,'App\\Models\\Notification','v736297ce45ce47bd83ce4a08b8853f6','2018-10-03 08:11:38','2018-10-03 08:11:38'),
	(1216,10,'App\\Models\\Notification','t03858378a1494213aadb8d978e5bec4','2018-10-03 08:11:38','2018-10-03 08:11:38'),
	(1217,11,'App\\Models\\Notification','b9be45f402dd9449190109b88075178f','2018-10-03 08:11:38','2018-10-03 08:11:38'),
	(1218,12,'App\\Models\\Notification','o340525a34536499dbc3b4bb0e6253ae','2018-10-03 08:11:38','2018-10-03 08:11:38'),
	(1219,13,'App\\Models\\Notification','y4da5bd0a7c2144068c34f7e2d74b2e8','2018-10-03 08:11:38','2018-10-03 08:11:38'),
	(1220,14,'App\\Models\\Notification','be48355d463124bd2a167856c7381ff4','2018-10-03 08:11:38','2018-10-03 08:11:38'),
	(1221,15,'App\\Models\\Notification','ed2660cf94f7f4eb6ab31294143fb672','2018-10-03 08:11:39','2018-10-03 08:11:39'),
	(1222,16,'App\\Models\\Notification','bcb76dcb8f87c4cee94bc6c952e6d622','2018-10-03 08:11:39','2018-10-03 08:11:39'),
	(1223,17,'App\\Models\\Notification','i9891d6bf40534e51a357c36b1c3ad9e','2018-10-03 08:11:39','2018-10-03 08:11:39'),
	(1224,18,'App\\Models\\Notification','m689643fb002440b69c9b76b39620260','2018-10-03 08:11:39','2018-10-03 08:11:39'),
	(1235,9,'App\\Models\\Post','la4a8b592a1214505a46cac4f4a93bc6','2018-10-03 08:15:27','2018-10-03 08:15:27'),
	(1237,19,'App\\Models\\Notification','o5b046b548f2c43e5aabc81161b9c023','2018-10-03 08:15:29','2018-10-03 08:15:29'),
	(1243,13,'App\\Models\\Comment','j7ea86c3ae0094a15886de7c9fdc859f','2018-10-03 08:17:03','2018-10-03 08:17:03'),
	(1256,43,'App\\Models\\Enrollment','x31227ec0689f4c50a19759c64cb22c2','2018-10-03 08:18:18','2018-10-03 08:18:18'),
	(1266,10,'App\\Models\\Post','b471ef224491b49818395a80dbc892ea','2018-10-03 08:18:56','2018-10-03 08:18:56'),
	(1268,34,'App\\Models\\Like','q64b87fb772b5481ca40a864db341d9a','2018-10-03 08:19:00','2018-10-03 08:19:00'),
	(1269,35,'App\\Models\\Like','q189e32d9a86444d49ad10ec939d2c02','2018-10-03 08:19:02','2018-10-03 08:19:02'),
	(1270,14,'App\\Models\\Comment','s1ed0fb8f0b75463ba1f8320ea83fffd','2018-10-03 08:19:22','2018-10-03 08:19:22'),
	(1272,15,'App\\Models\\Comment','k14ee90fac6af48ceb250e9413e76c36','2018-10-03 08:19:46','2018-10-03 08:19:46'),
	(1279,11,'App\\Models\\Post','ib4869468b8d14647bf1abd1747f88da','2018-10-03 08:20:10','2018-10-03 08:20:10'),
	(1281,12,'App\\Models\\Post','g1eb5de69453e474eaf8c4b3db311079','2018-10-03 08:20:19','2018-10-03 08:20:19'),
	(1283,16,'App\\Models\\Comment','oa148da70eb4c448c8237b5653ca089e','2018-10-03 08:20:31','2018-10-03 08:20:31'),
	(1290,13,'App\\Models\\Post','wb4c92544c20049dfa6e41391c520ce8','2018-10-03 08:21:06','2018-10-03 08:21:06'),
	(1292,14,'App\\Models\\Post','qa4ee0d181b90496f8f267c1f8cc66c0','2018-10-03 08:21:41','2018-10-03 08:21:41'),
	(1294,17,'App\\Models\\Comment','s42734c9c1b4f4b30b19dfd6f1c149ad','2018-10-03 08:21:50','2018-10-03 08:21:50'),
	(1296,18,'App\\Models\\Comment','i88c4cbbc552a4a53a86d251761aeaed','2018-10-03 08:21:57','2018-10-03 08:21:57'),
	(1303,15,'App\\Models\\Post','v840785128e5948afa3204442b9d9f93','2018-10-03 08:22:39','2018-10-03 08:22:39'),
	(1305,16,'App\\Models\\Post','v002d541dc31b4b85897615151e8a466','2018-10-03 08:22:55','2018-10-03 08:22:55'),
	(1312,17,'App\\Models\\Post','ze99ca9d1df0049c3af0f1a740861284','2018-10-03 08:23:39','2018-10-03 08:23:39'),
	(1319,19,'App\\Models\\Comment','hfd0441a00241495e9e0a20ed48217b2','2018-10-03 08:23:56','2018-10-03 08:23:56'),
	(1329,36,'App\\Models\\Like','j9807b7f46efb43f38be9c2e6b23b2b4','2018-10-03 08:26:21','2018-10-03 08:26:21'),
	(1335,20,'App\\Models\\Comment','q6e40af66d73444ecbfc1b54f7f73dd7','2018-10-03 08:46:04','2018-10-03 08:46:04'),
	(1342,18,'App\\Models\\Post','q750dedae2d4e4cd89b342a551cac99e','2018-10-03 08:46:20','2018-10-03 08:46:20'),
	(1349,19,'App\\Models\\Post','bb2fa14d4450d4a39ba977b0187e224e','2018-10-03 08:46:44','2018-10-03 08:46:44'),
	(1351,20,'App\\Models\\Post','rf48cf881710a46b68792e72cfabe073','2018-10-03 08:46:53','2018-10-03 08:46:53'),
	(1358,21,'App\\Models\\Post','wd5f97e46b2d84e5c8454b4ca66667d8','2018-10-03 08:47:15','2018-10-03 08:47:15'),
	(1370,22,'App\\Models\\Post','s4d74c0bc98944e1dafa017653e2a0ac','2018-10-03 08:54:41','2018-10-03 08:54:41'),
	(1390,21,'App\\Models\\Comment','q76ee6d64371d4d7492f0a65e0690b3c','2018-10-03 08:55:26','2018-10-03 08:55:26'),
	(1392,22,'App\\Models\\Comment','i4fda3093739147229470a584bfe3da2','2018-10-03 08:55:40','2018-10-03 08:55:40'),
	(1397,8,'App\\Models\\Grade','i2d317f3d494b443bb3d1fbae7a14694','2018-10-03 08:56:16','2018-10-03 08:56:16'),
	(1399,9,'App\\Models\\Grade','v01bf3bdb7bcc40a7ac45cc820cad90c','2018-10-03 08:56:24','2018-10-03 08:56:24'),
	(1449,10,'App\\Models\\Grade','m171b0beb042842d7a5fbefff0956221','2018-10-03 08:57:41','2018-10-03 08:57:41'),
	(1456,23,'App\\Models\\Post','f5e2a386483504ebf9851c9999ca9299','2018-10-03 08:57:55','2018-10-03 08:57:55'),
	(1458,37,'App\\Models\\Like','ab61d80fa3c4344288d9f71f90f791b4','2018-10-03 08:58:02','2018-10-03 08:58:02'),
	(1469,1,'App\\Models\\ResourceAlias','k71c7530b59c04ab3b9eccca9b553aa5','2018-10-03 08:58:52','2018-10-03 08:58:52'),
	(1470,20,'App\\Models\\Notification','t50cea16d02a6491b9ef265cccf93528','2018-10-03 08:58:53','2018-10-03 08:58:53'),
	(1471,21,'App\\Models\\Notification','id360ca939155479ba1b7200e258aeb7','2018-10-03 08:58:55','2018-10-03 08:58:55'),
	(1472,22,'App\\Models\\Notification','n8c66f746b86b4f8e80b4a4532dfa1c6','2018-10-03 08:58:55','2018-10-03 08:58:55'),
	(1473,23,'App\\Models\\Notification','nc36031ae02b0426e91206c0747a2ca3','2018-10-03 08:58:55','2018-10-03 08:58:55'),
	(1474,24,'App\\Models\\Notification','gf22cce3f2d4b43e596e4249944d70e8','2018-10-03 08:58:55','2018-10-03 08:58:55'),
	(1475,25,'App\\Models\\Notification','pf0399b81b9df424aa3ad1489f475702','2018-10-03 08:58:56','2018-10-03 08:58:56'),
	(1476,26,'App\\Models\\Notification','ia3df63179b6f4a35aae99c3b89b7996','2018-10-03 08:58:56','2018-10-03 08:58:56'),
	(1477,27,'App\\Models\\Notification','a65980ab832f643e49ea8ef7fa51f483','2018-10-03 08:58:56','2018-10-03 08:58:56'),
	(1478,28,'App\\Models\\Notification','cec190241eba4486ca72a2a76db2d789','2018-10-03 08:58:56','2018-10-03 08:58:56'),
	(1479,29,'App\\Models\\Notification','oc5d9bed86fad4fde9ba2486edb676b5','2018-10-03 08:58:56','2018-10-03 08:58:56'),
	(1480,30,'App\\Models\\Notification','pd2df8228274d47118a19e575149b64e','2018-10-03 08:58:57','2018-10-03 08:58:57'),
	(1481,31,'App\\Models\\Notification','b813a10ff8ba1491b9cbc67f1dd7c890','2018-10-03 08:58:57','2018-10-03 08:58:57'),
	(1482,32,'App\\Models\\Notification','l2cd5ae8f750c4108b4786b5782ee7a5','2018-10-03 08:58:58','2018-10-03 08:58:58'),
	(1483,33,'App\\Models\\Notification','se75d07daa09140bc8387aef742595d2','2018-10-03 08:58:58','2018-10-03 08:58:58'),
	(1484,34,'App\\Models\\Notification','c3db8e37e361042b7803c9b3d6561318','2018-10-03 08:58:58','2018-10-03 08:58:58'),
	(1485,35,'App\\Models\\Notification','ga87d7a93eeb749878cc3e2b247c5c81','2018-10-03 08:58:59','2018-10-03 08:58:59'),
	(1486,36,'App\\Models\\Notification','m9d681f541a814f00a5f9d66151c4ec5','2018-10-03 08:58:59','2018-10-03 08:58:59'),
	(1487,37,'App\\Models\\Notification','c83d0ffd6c89a45349b93e24c173e5ec','2018-10-03 08:58:59','2018-10-03 08:58:59'),
	(1488,38,'App\\Models\\Notification','sac5477d5bfab437dab3e867c3c946d5','2018-10-03 08:58:59','2018-10-03 08:58:59'),
	(1489,39,'App\\Models\\Notification','jc08b65301d4f49ffad9558eefe32610','2018-10-03 08:59:00','2018-10-03 08:59:00'),
	(1490,40,'App\\Models\\Notification','i0892655221434b0daab8d164f7d6644','2018-10-03 08:59:00','2018-10-03 08:59:00'),
	(1491,41,'App\\Models\\Notification','f3a95b9f314474d809d2b027646d40c5','2018-10-03 08:59:00','2018-10-03 08:59:00'),
	(1492,42,'App\\Models\\Notification','i1ff5a9fe3e664805a36f0a2a0ab3b0c','2018-10-03 08:59:01','2018-10-03 08:59:01'),
	(1493,43,'App\\Models\\Notification','n945d340fbd25487c96150a8a1406a27','2018-10-03 08:59:01','2018-10-03 08:59:01'),
	(1494,44,'App\\Models\\Notification','ha598d30d62094deebe94529cc692824','2018-10-03 08:59:01','2018-10-03 08:59:01'),
	(1495,45,'App\\Models\\Notification','ab6a562c1a2c740a9a092e2eaf5ea6d2','2018-10-03 08:59:02','2018-10-03 08:59:02'),
	(1496,46,'App\\Models\\Notification','ea85de55ca95e42bbbe54a0a9b2bd0d1','2018-10-03 08:59:02','2018-10-03 08:59:02'),
	(1497,47,'App\\Models\\Notification','d0c8b8bffcd744b2491f7be9167fb524','2018-10-03 08:59:02','2018-10-03 08:59:02'),
	(1513,23,'App\\Models\\Comment','re1bc14bbf9444cce88950c7ed211ca2','2018-10-03 11:57:21','2018-10-03 11:57:21'),
	(1515,48,'App\\Models\\Notification','j868c14817a544621843881d47fbb370','2018-10-03 11:57:22','2018-10-03 11:57:22'),
	(1516,38,'App\\Models\\Like','oc46be4facdea481aa39d6ab5007b030','2018-10-03 11:57:58','2018-10-03 11:57:58'),
	(1517,39,'App\\Models\\Like','v8140f8af61e1438bb6cabbf54206924','2018-10-03 11:58:00','2018-10-03 11:58:00'),
	(1518,49,'App\\Models\\Notification','fa0465b0642dd4cb98ea8ba510879040','2018-10-03 11:58:01','2018-10-03 11:58:01'),
	(1519,50,'App\\Models\\Notification','p9d19f6ab882c436da04da63cf811959','2018-10-03 11:58:01','2018-10-03 11:58:01'),
	(1520,40,'App\\Models\\Like','wa96e73dc280548268ecee534e5ca0e8','2018-10-03 11:58:05','2018-10-03 11:58:05'),
	(1521,51,'App\\Models\\Notification','wa00428283d564cb08bb3ca47771a9e5','2018-10-03 11:58:08','2018-10-03 11:58:08'),
	(1530,41,'App\\Models\\Like','q319cde4656b54be8b0ca0ed1a97aaec','2018-10-03 11:59:12','2018-10-03 11:59:12'),
	(1531,52,'App\\Models\\Notification','j1b52e3980665465a99172ff7d6e9030','2018-10-03 11:59:14','2018-10-03 11:59:14'),
	(1532,42,'App\\Models\\Like','qe49ec29fae2f42d4a3a06a2bdae4f31','2018-10-03 11:59:16','2018-10-03 11:59:16'),
	(1533,53,'App\\Models\\Notification','rd132c927a5be40d5bc3bc388fa81f5d','2018-10-03 11:59:18','2018-10-03 11:59:18'),
	(1534,43,'App\\Models\\Like','e256e89d8b33f43ee903288bbafc801b','2018-10-03 11:59:21','2018-10-03 11:59:21'),
	(1535,54,'App\\Models\\Notification','mccd4160a4caa4a7ba0f6ca141c75f9a','2018-10-03 11:59:21','2018-10-03 11:59:21'),
	(1544,44,'App\\Models\\Like','i2b3382f3a1ea49b0b2093c507464c3d','2018-10-03 12:08:59','2018-10-03 12:08:59'),
	(1550,55,'App\\Models\\Notification','ecdd054183f4747b1b62fc3efe354dbe','2018-10-03 12:15:25','2018-10-03 12:15:25'),
	(1570,45,'App\\Models\\Like','e435ce9c7c8b84d8ab9fad3805ce41ce','2018-10-03 15:30:36','2018-10-03 15:30:36'),
	(1571,46,'App\\Models\\Like','f24434b5da929460a9ee5ff274eb0a3a','2018-10-03 15:31:01','2018-10-03 15:31:01'),
	(1576,56,'App\\Models\\Notification','h4cb048c3679d43d9b19702017c383c9','2018-10-03 15:33:08','2018-10-03 15:33:08'),
	(1577,57,'App\\Models\\Notification','af6ed71c1b4f24abeb367ae67b20260a','2018-10-03 15:33:08','2018-10-03 15:33:08'),
	(1597,24,'App\\Models\\Comment','o97bcfdd8586b42ec9c923066439b2b0','2018-10-03 17:28:05','2018-10-03 17:28:05'),
	(1599,58,'App\\Models\\Notification','hee8f82930c5a48cc958c8cc2a880720','2018-10-03 17:28:06','2018-10-03 17:28:06'),
	(1600,25,'App\\Models\\Comment','bda0be87db45f45b2a08c9aa569058a3','2018-10-03 17:28:31','2018-10-03 17:28:31'),
	(1602,59,'App\\Models\\Notification','w8c8306bb2a464b5491aa797209470da','2018-10-03 17:28:34','2018-10-03 17:28:34'),
	(1610,26,'App\\Models\\Comment','t1d078f63f6594cadad7931b33e773d0','2018-10-03 17:30:28','2018-10-03 17:30:28'),
	(1612,60,'App\\Models\\Notification','y00f534f21f164da3b81714abd44858c','2018-10-03 17:30:29','2018-10-03 17:30:29'),
	(1631,47,'App\\Models\\Like','ydd7851c4b41a4914b3ca7553704d5c4','2018-10-03 18:17:51','2018-10-03 18:17:51'),
	(1632,61,'App\\Models\\Notification','f6f659b34bbf649aaa7f804877c04b1c','2018-10-03 18:17:51','2018-10-03 18:17:51'),
	(1647,24,'App\\Models\\Post','z41e97a81645f46029d2f368d09d0fca','2018-10-03 18:22:21','2018-10-03 18:22:21'),
	(1649,62,'App\\Models\\Notification','k66fd194b31ce41c3b553ab8c839f557','2018-10-03 18:22:23','2018-10-03 18:22:23'),
	(1655,27,'App\\Models\\Comment','aef78920f7d214f459af9696a0022094','2018-10-03 18:24:15','2018-10-03 18:24:15'),
	(1666,44,'App\\Models\\Enrollment','d48338062c71d455cae906eb4cb668d8','2018-10-03 18:27:32','2018-10-03 18:27:32'),
	(1668,63,'App\\Models\\Notification','s4e8f9682f86d4d04bb4416d37dd4122','2018-10-03 18:27:35','2018-10-03 18:27:35'),
	(1693,25,'App\\Models\\Post','g89b359cee3a445f9a50cd694231c302','2018-10-03 18:51:25','2018-10-03 18:51:25'),
	(1695,64,'App\\Models\\Notification','x6b54709825d941c88b3aaefe6657dd1','2018-10-03 18:51:28','2018-10-03 18:51:28'),
	(1715,26,'App\\Models\\Post','a178c731c32f548dabfa9edae945c44e','2018-10-03 19:24:56','2018-10-03 19:24:56'),
	(1717,65,'App\\Models\\Notification','t58fb1df5238a4bc7aeb0f72458d5f4b','2018-10-03 19:24:58','2018-10-03 19:24:58'),
	(1722,28,'App\\Models\\Comment','l57bf5ef0193e4867b2fe5416dadef3e','2018-10-03 19:43:31','2018-10-03 19:43:31'),
	(1724,27,'App\\Models\\Post','yea3f76ac328d4c14a13b71d0ed295ed','2018-10-03 19:43:45','2018-10-03 19:43:45'),
	(1726,66,'App\\Models\\Notification','pdab966db3f8542d8a05dc8280e28fd6','2018-10-03 19:43:47','2018-10-03 19:43:47'),
	(1770,1,'App\\Models\\Device','nfcef3f72759948108b3272ab33a4db4','2018-10-04 21:10:08','2018-10-04 21:10:08'),
	(1788,17,'App\\Models\\Assignment','k65dd75f16ec346a099862ce2ddf7267','2018-10-04 21:39:43','2018-10-04 21:39:43'),
	(1828,2,'App\\Models\\Device','r6876465e6270491e8a0add33c1192bc','2018-10-04 22:19:28','2018-10-04 22:19:28'),
	(1834,29,'App\\Models\\Comment','lf1453fefe0e64e8e96d50a6b6732d8d','2018-10-04 22:21:27','2018-10-04 22:21:27'),
	(1841,28,'App\\Models\\Post','h4e5ff8df0e4940768703e6741577777','2018-10-04 22:22:07','2018-10-04 22:22:07'),
	(1849,29,'App\\Models\\Post','ldbaf20ab122d466eb75eed64f9f571e','2018-10-04 22:23:27','2018-10-04 22:23:27'),
	(1851,30,'App\\Models\\Comment','u081d07c4125149be93cd134f746f1ad','2018-10-04 22:24:27','2018-10-04 22:24:27'),
	(1853,31,'App\\Models\\Comment','p1986d0643a624981b4a71a10aaea9f1','2018-10-04 22:24:36','2018-10-04 22:24:36'),
	(1855,32,'App\\Models\\Comment','r3760e807c50a4e61b863d4d6b67c8c4','2018-10-04 22:24:51','2018-10-04 22:24:51'),
	(1863,18,'App\\Models\\Assignment','k05314b60554f48e3b9ef6cff7400003','2018-10-04 22:36:07','2018-10-04 22:36:07'),
	(1876,4,'App\\Models\\Submission','m0457d120b91c43a58d103c74422e79b','2018-10-04 22:37:15','2018-10-04 22:37:15'),
	(1878,3,'App\\Models\\Attachment','af64e0f3983004e03a0af5f31839ee20','2018-10-04 22:37:16','2018-10-04 22:37:16'),
	(1880,5,'App\\Models\\Submission','z940541f5fa194642aa51dce12dd3f1c','2018-10-04 22:41:01','2018-10-04 22:41:01'),
	(1891,19,'App\\Models\\Assignment','sa1122383b4304145b0336aeb49d8e5d','2018-10-04 22:42:14','2018-10-04 22:42:14'),
	(1904,6,'App\\Models\\Submission','m3c7ef6dac210407a86a3004317adf48','2018-10-04 22:44:07','2018-10-04 22:44:07'),
	(1911,7,'App\\Models\\Submission','l7e4278a076e144e1b04bfb09dec0ba2','2018-10-04 22:45:29','2018-10-04 22:45:29'),
	(1944,3,'App\\Models\\Assessment','v2fbb38db1ac9479c80084721f160830','2018-10-05 00:35:35','2018-10-05 00:35:35'),
	(1945,5,'App\\Models\\AssessmentQuestion','v7f0bb97fdd6846c8986dfe74f7a099f','2018-10-05 00:35:36','2018-10-05 00:35:36'),
	(1947,6,'App\\Models\\AssessmentQuestion','hfbe63019705e4f51a0f32b1625c5806','2018-10-05 00:35:36','2018-10-05 00:35:36'),
	(1960,3,'App\\Models\\AssessmentAnswer','m5d789e798f4147a4b5bd719a55dfd83','2018-10-05 00:36:33','2018-10-05 00:36:33'),
	(1974,4,'App\\Models\\AssessmentAnswer','u3a36528c86ec43b9a15256076fca620','2018-10-05 00:37:19','2018-10-05 00:37:19'),
	(1976,5,'App\\Models\\AssessmentAnswer','d1b7356c76d1d453888562749cf809e8','2018-10-05 00:37:21','2018-10-05 00:37:21'),
	(1978,6,'App\\Models\\AssessmentAnswer','b449ecdbc17ac4515ba99a53138f29a7','2018-10-05 00:37:23','2018-10-05 00:37:23'),
	(1981,7,'App\\Models\\AssessmentQuestion','n6ff96591c0de46498d923a92f7a548c','2018-10-05 00:37:26','2018-10-05 00:37:26'),
	(2019,2,'App\\Models\\AssessmentSubmission','ma9d9efcd61fa430cacafae036fa063a','2018-10-05 01:56:26','2018-10-05 01:56:26'),
	(2021,2,'App\\Models\\AssessmentResponse','t52190bf373974933b917d0e9b231db8','2018-10-05 01:56:27','2018-10-05 01:56:27'),
	(2023,11,'App\\Models\\Grade','fdc24ea21b5754dbbbc3468db46282cc','2018-10-05 01:56:28','2018-10-05 01:56:28'),
	(2025,12,'App\\Models\\Grade','s1087a1d72bab416db2d049658d52e0d','2018-10-05 01:56:28','2018-10-05 01:56:28'),
	(2027,3,'App\\Models\\AssessmentResponse','b6815a6fe6bb245e1a25a33c8c802a9c','2018-10-05 01:57:03','2018-10-05 01:57:03'),
	(2029,13,'App\\Models\\Grade','u28e2b40785554f738af916ee04981fe','2018-10-05 01:57:03','2018-10-05 01:57:03'),
	(2032,4,'App\\Models\\AssessmentResponse','h3ffae4952ffc4b1ab64b654b172897b','2018-10-05 01:57:23','2018-10-05 01:57:23'),
	(2034,14,'App\\Models\\Grade','paf2f2ba1d0a84179816d8e7b6d6f04d','2018-10-05 01:57:23','2018-10-05 01:57:23'),
	(2036,5,'App\\Models\\AssessmentResponse','o8c3997348c4e4a97ba7a30815606dee','2018-10-05 01:57:25','2018-10-05 01:57:25'),
	(2053,8,'App\\Models\\Submission','ob03cc138fe184bd4af2059a3d1ef4ea','2018-10-05 02:07:50','2018-10-05 02:07:50'),
	(2055,4,'App\\Models\\Attachment','k7385d4f06a1b46f793b4ab844876692','2018-10-05 02:07:51','2018-10-05 02:07:51'),
	(2064,3,'App\\Models\\Device','re660349d2094488b87d1677402cd1da','2018-10-05 02:09:18','2018-10-05 02:09:18'),
	(2075,3,'App\\Models\\AssessmentSubmission','le7b4840f8dee4b93a9026013d84cd59','2018-10-05 02:16:20','2018-10-05 02:16:20'),
	(2077,6,'App\\Models\\AssessmentResponse','v33ad1bb7a1e0454e81036fa435df324','2018-10-05 02:16:21','2018-10-05 02:16:21'),
	(2079,15,'App\\Models\\Grade','mbba360313df94708aad3e47d9b30c87','2018-10-05 02:16:21','2018-10-05 02:16:21'),
	(2081,16,'App\\Models\\Grade','h9dbf78a826bb42c6bf14c42875ede99','2018-10-05 02:16:21','2018-10-05 02:16:21'),
	(2083,7,'App\\Models\\AssessmentResponse','i0e6afc5218fd43e6932243a35ce4f31','2018-10-05 02:16:32','2018-10-05 02:16:32'),
	(2085,17,'App\\Models\\Grade','s92809528e48842a297829aa84af1f70','2018-10-05 02:16:32','2018-10-05 02:16:32'),
	(2089,8,'App\\Models\\AssessmentResponse','b3050b90f923b49ef90aa46a711587a7','2018-10-05 02:16:43','2018-10-05 02:16:43'),
	(2091,18,'App\\Models\\Grade','t380ebdaa7f244935a100ba1519d94c5','2018-10-05 02:16:43','2018-10-05 02:16:43'),
	(2093,9,'App\\Models\\AssessmentResponse','k41d09c6a452b462192fde5f1a33bb1d','2018-10-05 02:16:44','2018-10-05 02:16:44'),
	(2095,5,'App\\Models\\Attachment','t304b9f9264484f07a3fe0f88bc9c860','2018-10-05 02:16:52','2018-10-05 02:16:52'),
	(2116,4,'App\\Models\\Device','kdb730a19d77b45b8b7c254691b01815','2018-10-05 02:26:39','2018-10-05 02:26:39'),
	(2121,4,'App\\Models\\Assessment','c8f0bc5d5fba14af08786b090b45454f','2018-10-05 02:28:42','2018-10-05 02:28:42'),
	(2125,8,'App\\Models\\AssessmentQuestion','i5953e67314b24c3cb2b487916bf05ae','2018-10-05 02:29:02','2018-10-05 02:29:02'),
	(2130,7,'App\\Models\\AssessmentAnswer','ude8075842b5540259d6dafd2ccc3fcb','2018-10-05 02:29:22','2018-10-05 02:29:22');

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;

INSERT INTO `settings` (`id`, `key`, `value`, `resource_key`, `created_at`, `updated_at`, `deleted_at`, `creator_id`)
VALUES
	(1,'courseProfessorAssignmentNotificationWeb','b:1;','p7fb866eda92742ab82e454f2d3893b4','2018-09-26 10:56:25.684300','2018-09-26 10:56:25.684300',NULL,19),
	(2,'courseProfessorPostNotificationMobile','b:1;','g1431d419ba0c478184512dd33ebc8f0','2018-09-26 10:56:58.987700','2018-09-26 10:56:58.987700',NULL,19);

/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;


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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `submissions` WRITE;
/*!40000 ALTER TABLE `submissions` DISABLE KEYS */;

INSERT INTO `submissions` (`id`, `owner_id`, `owner_type`, `creator_id`, `parent_id`, `created_at`, `updated_at`, `resource_key`, `deleted_at`, `text`)
VALUES
	(1,19,'App\\Models\\User',19,3,'2018-09-26 10:52:29.613400','2018-09-26 10:52:29.613400','tadcbd55243e04a2a95304d5f2aaad82',NULL,'fefe'),
	(2,1,'App\\Models\\AssignmentGroup',19,4,'2018-09-26 10:52:53.101600','2018-09-26 10:52:53.101600','re79098faf34d49adbef3cdcf53471af',NULL,'ewfewfew'),
	(3,19,'App\\Models\\User',19,7,'2018-09-26 10:53:20.367000','2018-09-26 10:53:20.367000','j995cdb2ae0f2435eb47c78a5409885a',NULL,'efwefe'),
	(4,19,'App\\Models\\User',19,18,'2018-10-04 22:37:14.846100','2018-10-04 22:37:14.846100','m0457d120b91c43a58d103c74422e79b',NULL,'poops'),
	(5,19,'App\\Models\\User',19,18,'2018-10-04 22:41:00.963400','2018-10-04 22:41:00.963400','z940541f5fa194642aa51dce12dd3f1c',NULL,'fxvfv'),
	(6,14,'App\\Models\\User',14,18,'2018-10-04 22:44:07.055400','2018-10-04 22:44:07.055400','m3c7ef6dac210407a86a3004317adf48',NULL,NULL),
	(7,14,'App\\Models\\User',14,19,'2018-10-04 22:45:29.149000','2018-10-04 22:45:29.149000','l7e4278a076e144e1b04bfb09dec0ba2',NULL,NULL),
	(8,19,'App\\Models\\User',19,19,'2018-10-05 02:07:49.993800','2018-10-05 02:07:49.993800','ob03cc138fe184bd4af2059a3d1ef4ea',NULL,NULL);

/*!40000 ALTER TABLE `submissions` ENABLE KEYS */;
UNLOCK TABLES;


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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `terms` WRITE;
/*!40000 ALTER TABLE `terms` DISABLE KEYS */;

INSERT INTO `terms` (`id`, `title`, `start_date`, `end_date`, `available_date`, `permalink`, `university_id`, `resource_key`, `created_at`, `updated_at`, `deleted_at`)
VALUES
	(1,'Fall 2018','2014-01-01 00:00:00','2050-01-01 00:00:00','2014-01-01 00:00:00','forever-term',1,'JwQlgcfCVRWjDkPiwonbMgGPIaF5WJ1S','2016-05-13 01:59:34.329759','2018-09-26 10:11:02.094000',NULL);

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
  `club_officer_date` datetime DEFAULT NULL,
  `club_reregister_open_date` datetime DEFAULT NULL,
  `club_reregister_close_date` datetime DEFAULT NULL,
  `lock_sis_courses` tinyint(1) NOT NULL DEFAULT '0',
  `intercom_key` varchar(255) DEFAULT NULL,
  `grade_scale` varchar(255) NOT NULL DEFAULT 'F,0,30;D,60,65;C,70,75;B,80,85;A,90,95',
  `restrict_roster` enum('none','student','all') NOT NULL DEFAULT 'none',
  PRIMARY KEY (`id`),
  UNIQUE KEY `universities_resource_key_unique` (`resource_key`),
  UNIQUE KEY `universities_permalink_deleted_at_unique` (`permalink`,`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `universities` WRITE;
/*!40000 ALTER TABLE `universities` DISABLE KEYS */;

INSERT INTO `universities` (`id`, `name`, `permalink`, `created_at`, `updated_at`, `zip`, `domain`, `state`, `resource_key`, `deleted_at`, `default_logo`, `profile_logo`, `group_create`, `accepted_domain`, `timezone`, `enroll_admins_courses`, `enroll_admins_groups`, `send_email_from_user`, `default_course_price`, `enable_google_convert_submissions`, `enable_grade_averages_assistant`, `clubs_contact`, `club_officer_date`, `club_reregister_open_date`, `club_reregister_close_date`, `lock_sis_courses`, `intercom_key`, `grade_scale`, `restrict_roster`)
VALUES
	(1,'University of Arizona','ua-az','2016-05-13 01:59:34.195980','2018-04-19 04:12:51.653700',0,'demo.notebowl.xyz',2,'i5bb990b3969342e5b815d64ac4d3893',NULL,NULL,NULL,1,NULL,'America/Phoenix',0,0,0,0.00,0,1,NULL,NULL,NULL,NULL,0,NULL,'F,0,30;D,60,65;C,70,75;B,80,85;A,90,95','none');

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
  KEY `user_sessions_session_id_index` (`session_id`),
  KEY `user_sessions_logged_out_index` (`logged_out`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`id`, `university_id`, `email`, `phone_number`, `password`, `profile_picture`, `created_at`, `updated_at`, `resource_key`, `admin`, `mode`, `reset_token`, `deleted_at`, `tos_verify`, `timezone`, `first_name`, `last_name`, `event_create`, `group_create`, `post_create`, `api_token`, `stripe_id`, `card_brand`, `card_last_four`, `trial_ends_at`, `grad_year`, `grad_month`, `last_login_at`, `intercom`, `verified_email`, `zoom_api`)
VALUES
	(1,1,'admin@notebowl.com',NULL,'$2y$10$QJVvdy8scOkpjAWiTz.jbu2OTieU.IcMgmwej6d2hx9VFxFaFVwGK','https://notebowl.s3.amazonaws.com/users/U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi/profile-picture/EFZRd9vadqmvY11kSWCFgeCK1k09BBu1','2016-05-13 01:59:41.424897','2018-10-03 07:35:58.872300','U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi',1,2,NULL,NULL,1,NULL,'Notebowl','User',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-10-03 07:35:58.872100',1,1,NULL),
	(2,1,'alexs@notebowl.com',NULL,'$2y$10$j4fOmjMjh.lvoPJzDZZpqeIOnDOAtaHx9Xma7KyeVmjmoQXQloVDG','https://notebowl.s3.amazonaws.com/users/JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4/profile-picture/PMjowlCwESuuBWYvuikErkWqsm85tTEn','2016-05-13 01:59:41.507325','2018-08-28 00:25:08.647900','JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4',0,2,NULL,NULL,1,NULL,'Alex','Slaughter',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-08-28 00:25:08.647900',1,1,NULL),
	(3,1,'andrew.chaifetz@notebowl.com',NULL,'$2y$10$r131g6obNE3GeeTtIP6.FOmSbQUOTjZdRMwHLmwocvKjrWN0KIbs6','https://notebowl.s3.amazonaws.com/files/1537957516/n10b6eda601f34f34a31a6cbbe3779d62c3848cacde6d4ad199e850f04f37062/VoG9lUdXVPOmAJbBrKYpi3Pl7JDHLhPU9Tj2VQN0.jpeg.jpg','2016-05-13 01:59:41.583603','2018-10-05 02:35:20.495300','d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ',0,2,NULL,NULL,1,NULL,'Andrew','Chaifetz',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-10-05 02:35:20.495200',1,1,NULL),
	(4,1,'alexc@notebowl.com',NULL,'$2y$10$Mpn2yVOf52QUpVBit/R8Rus28ZwDdhWFPhYuKDT4.9HvNyf45RUdO','https://notebowl.s3.amazonaws.com/users/mZBS7dLUiNdBEfDVjUh6krB54jlRaCPt/profile-picture/qvXxuSg7ESUmgJDWxRJDyiKfpFOsv1um','2016-05-13 01:59:41.668478','2016-11-10 20:20:28.692100','mZBS7dLUiNdBEfDVjUh6krB54jlRaCPt',0,2,NULL,NULL,1,NULL,'Alex','Coomans',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(5,1,'matt.silverstone@notebowl.com',NULL,'$2y$10$4FyJx3S8IcCMBQoXiFkXZ.t3aVar2omHJJ7yB2kss6nl4rIBOZdN6',NULL,'2016-05-13 01:59:41.751167','2016-11-10 20:20:28.692100','BipyPUZK2b1otMJOkVh21CUlA3GvO9Oh',0,2,NULL,NULL,1,NULL,'Matt','Sliverstone',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(6,1,'scott.birgel@notebowl.com',NULL,'$2y$10$NtmoZLU3RVviRH.JmsYZHur5zM4LO9vMrI8q0/jtDIanYs1.lCRWG',NULL,'2016-05-13 01:59:41.831772','2016-11-10 20:20:28.692100','q5ja2Qw5IP8RETJq43vGGahB9L91oXjn',0,2,NULL,NULL,1,NULL,'Scott','Birgel',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(7,1,'alec.stapp@notebowl.com',NULL,'$2y$10$/GeZXoCspxUT4vE9lvgvhOjnQ.KALN4.RVRmhvGcvWdd4ayffvjX6',NULL,'2016-05-13 01:59:41.907205','2016-11-10 20:20:28.692100','SKXNr8e8eOSTgelgcL4W4HHizteF9zmc',0,2,NULL,NULL,1,NULL,'Alec','Stapp',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(8,1,'bob.smith@notebowl.com',NULL,'$2y$10$vaoNAqN1CFST.73KTXx4VuIYkxVb4H5F4qs/hl9aZH9XCkrxBG1vG','https://notebowl.s3.amazonaws.com/users/EYVoid6eBnSNUcyhN6J67EybnjOQNRhW/profile-picture/jspAVoL4NVR1KVBMaOGHHqQH3PVCmwqz','2016-05-13 01:59:41.980726','2016-11-10 20:20:28.692100','EYVoid6eBnSNUcyhN6J67EybnjOQNRhW',0,2,NULL,NULL,1,NULL,'Bob','Smith',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(9,1,'issac.ortega@notebowl.com',NULL,'$2y$10$4a9EQBYDGCye6VjPtfPsd.KXISe7bgoUedCn67OwUnBOvwvJT5lny',NULL,'2016-05-13 01:59:42.053595','2016-11-10 20:20:28.692100','eSpvwhe9b3dsBkHZz1Xxgx0TE9cYaF9Q',0,2,NULL,NULL,1,NULL,'Issac','Ortega',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(10,1,'aaron.ogata@notebowl.com',NULL,'$2y$10$O4xopCZRhlgDAj6P62DY5emyHEihO7pJNXkDX.4GPQeKMkKItjEVS','https://notebowl.s3.amazonaws.com/files/1537983163/yb111f255120a4f98bf139f465114373ed186f938d7634331ad96701a444a181/qqEiZj8xuUiGJOAyIg87fy6ErZWObvoIVuOySxKx.gif.png','2016-05-13 01:59:42.131956','2018-09-26 17:32:45.329200','zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP',0,2,NULL,NULL,1,NULL,'Aaron','Ogata',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-09-26 17:30:43.476300',1,1,NULL),
	(11,1,'nina.iarkova@notebowl.com',NULL,'$2y$10$/JBc6YXnDBQqWRtFkG6qy.l0X3/NA8u88ut08GzBhdfF27P.rXS9i','https://notebowl.s3.amazonaws.com/files/1537958674/pf1afd2ebd351410da9d0e92de1c743108d271eddb53c419296efcb35f284e2b/L1YCXXWXpWcRxYVhtALmVJ2UC3RuPZ7UYdHj0GWr.jpeg.jpg','2016-05-13 01:59:42.214564','2018-10-03 19:42:30.011700','Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC',0,2,NULL,NULL,1,NULL,'Nina','Iarkova',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-10-03 19:42:30.011600',1,1,NULL),
	(12,1,'rachel.helmstetter@notebowl.com',NULL,'$2y$10$SXbzSG7z8Ot1ACw7zNcJa.W2niC1sbM6gBEgtYTaptqK7u7q7BoIG',NULL,'2016-05-13 01:59:42.298808','2016-11-10 20:20:28.692100','nzrHeALihLTymfkwJBsslhg0DadMFlxW',0,2,NULL,NULL,1,NULL,'Rachel','Helmstetter',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(13,1,'jose.garcia@notebowl.com',NULL,'$2y$10$chEUy4yP0USX7nuJ.oxIcOjYrdIC/QBhD56eJWW6VJdx48VMZ7L22',NULL,'2016-05-13 01:59:42.384662','2016-11-10 20:20:28.692100','XdnqLaL8eoMFFzLazUJT0yl9zoT2dx1E',0,2,NULL,NULL,1,NULL,'Jose','Garcia',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(14,1,'keith.taylor@notebowl.com',NULL,'$2y$10$80cBoPBKeoWKEmHIH1AH4uZcFkeyeQ2vhXo/WzCNT5jeC9/eiRo3q','https://notebowl.s3.amazonaws.com/users/HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3/profile-picture/sDZo4XroQICYygcvu7pNBBIby0MftYbB','2016-05-13 01:59:42.466155','2018-10-05 02:09:20.000800','HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3',0,2,NULL,NULL,1,NULL,'Keith','Taylor',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-10-05 02:09:20.000800',1,1,NULL),
	(15,1,'zedel@asu.edu',NULL,'$2y$10$rYAGI/IqVZpbNtjNxgJr5u/gcbJvZalbe0EGcgQujJiJjcT3tFvzy',NULL,'2016-05-13 01:59:42.545244','2016-11-10 20:20:28.692100','kKGeYrjclHb0s4iDeDSQISx0nKKx3S84',0,2,NULL,NULL,1,NULL,'Zachary','Edel',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(16,1,'demo-user@notebowl.com',NULL,'$2y$10$OFclDBtCIx5Cou8MR/lKm.mBUnyjArU.mm0sfFN9QkYJmUXlW/YMy',NULL,'2016-05-13 01:59:42.670308','2016-11-10 20:20:28.692100','k3SJ7WctkCFNcFAj7KumfWebx7doIieh',0,2,NULL,NULL,1,NULL,'Notebowl','Tester',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(17,1,'rmahmad@notebowl.com',NULL,'$2y$10$lq.WjdBRmPwkMOof0t3iNucXOzX83sKrW76b8cww0wCo6ElHRtoh6',NULL,'2016-05-13 01:59:42.807548','2016-11-10 20:20:28.692100','OJSU0SlF4aFknh4Six8kgbxrlTDXLFPe',0,2,NULL,NULL,1,NULL,'Rizwan','Ahmad',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(18,1,'spluta@notebowl.com',NULL,'$2y$10$w/O5TcqkCnqyV4Phn3GBPubazrkDuG8XQPrbZkX8tnotiP0DaSi.y','https://notebowl.s3.amazonaws.com/users/Eq0uKBoESBjPxuTMDtG6FsAi8CdbPEK1/profile-picture/uwFFWjZI8tlRzsG3r5vy5pUcaTvARcI3 ','2016-05-13 01:59:42.886432','2016-11-10 20:20:28.692100','Eq0uKBoESBjPxuTMDtG6FsAi8CdbPEK1',0,2,NULL,NULL,1,NULL,'Stephen','Pluta',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(19,1,'chdowen@notebowl.com',NULL,'$2y$10$P0Q4gzVTQl8XkjDQx0GTe.4Idqa/jeBOYb3aZN0EHKGzXImhzc9aq','https://notebowl.s3.amazonaws.com/files/1537959031/u0d5ab76cf43e4aad89ea1ebe678deab7a59d3c5613c4434c89e6747de520974/RxVGy3E457gLNVs2IPQS0DSVrZZnhX0X06cj1gqn.jpeg.jpg','2018-09-26 10:11:30.970800','2018-10-05 02:05:56.009200','wf8be385309224b6c86e04323fa4a28d',0,2,NULL,NULL,1,NULL,'Conner','Owen',1,1,1,NULL,NULL,NULL,NULL,NULL,2019,5,'2018-10-05 02:05:56.009100',0,1,NULL);

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
