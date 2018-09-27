# ************************************************************
# Sequel Pro SQL dump
# Version 5040
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.23-log)
# Database: notebowl_development
# Generation Time: 2018-09-27 18:20:42 +0000
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `assessment_answers` WRITE;
/*!40000 ALTER TABLE `assessment_answers` DISABLE KEYS */;

INSERT INTO `assessment_answers` (`id`, `title`, `question_id`, `is_correct`, `creator_id`, `resource_key`, `created_at`, `updated_at`, `deleted_at`)
VALUES
	(1,'True',1,1,3,'l194867ea15ba47ac99648d28086a95e','2018-09-26 12:35:04.853100','2018-09-26 12:35:04.853100',NULL),
	(2,'False',2,1,3,'l1e4e00b7ac404976bd2f2c92787fd87','2018-09-26 12:35:08.917900','2018-09-26 12:35:08.917900',NULL);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `assessment_questions` WRITE;
/*!40000 ALTER TABLE `assessment_questions` DISABLE KEYS */;

INSERT INTO `assessment_questions` (`id`, `title`, `points`, `question_scheme`, `assessment_id`, `creator_id`, `resource_key`, `created_at`, `updated_at`, `deleted_at`, `description`, `extra_credit`)
VALUES
	(1,'feferwrw',10,'true_false',1,3,'jcf15cee17720464d9bed0f21bec0855','2018-09-26 12:34:58.822100','2018-09-26 12:35:04.178100',NULL,NULL,0),
	(2,'ewfewfewfw',10,'true_false',1,3,'l8adc1c73e05446639ac701a9f0759cb','2018-09-26 12:34:58.858500','2018-09-26 12:35:08.871200',NULL,NULL,0),
	(3,NULL,10,'true_false',2,3,'abc3982a59b994cb58ccc7dc89c15511','2018-09-26 21:17:14.294500','2018-09-26 21:17:14.294500',NULL,NULL,0),
	(4,NULL,10,'true_false',2,3,'me4869d78c32044a9a32eea49146a144','2018-09-26 21:17:14.345300','2018-09-26 21:17:14.345300',NULL,NULL,0);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `assessment_responses` WRITE;
/*!40000 ALTER TABLE `assessment_responses` DISABLE KEYS */;

INSERT INTO `assessment_responses` (`id`, `answer_id`, `assessment_id`, `submission_id`, `user_id`, `text_content`, `resource_key`, `created_at`, `updated_at`, `deleted_at`, `question_id`)
VALUES
	(1,NULL,1,1,19,'True','x1dd38a211aef4d1f9a2e19ecc9fe03a','2018-09-26 12:36:22.269100','2018-09-26 12:36:22.269100',NULL,1);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `assessment_submissions` WRITE;
/*!40000 ALTER TABLE `assessment_submissions` DISABLE KEYS */;

INSERT INTO `assessment_submissions` (`id`, `assessment_id`, `user_id`, `time_started`, `time_completed`, `resource_key`, `created_at`, `updated_at`, `deleted_at`)
VALUES
	(1,1,19,'2018-09-26 12:36:20.241800',NULL,'c2be94e00f7ba4d1b983c890498999c5','2018-09-26 12:36:20.293500','2018-09-26 12:36:20.293500',NULL);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `assessments` WRITE;
/*!40000 ALTER TABLE `assessments` DISABLE KEYS */;

INSERT INTO `assessments` (`id`, `title`, `permalink`, `resource_key`, `description`, `attempts`, `time_limit`, `grace_period`, `parent_id`, `creator_id`, `category_id`, `available_date`, `due_date`, `result_scheme`, `question_scheme`, `partial_credit`, `created_at`, `updated_at`, `deleted_at`, `default_question_points`, `answer_order`, `question_order`, `parent_type`, `locked`, `action_mode`, `grade_scheme`, `grades_published`)
VALUES
	(1,'The Night Sky Quiz','the-night-sky-quiz','o15e7d4535b8146ac90a7b1ed6d33b18','Astronomy is the oldest science, and its history shows a growing realization of our insignificant status in a vast and ancient universe.\n\nComplete the quiz and submit for grading, 10 points per question.',1,0,0,3,3,13,'2018-09-26 12:34:00','2018-10-04 06:59:00','score','true_false',0,'2018-09-26 12:34:57.991600','2018-09-26 12:35:41.117300',NULL,10,'normal','normal','App\\Models\\Course',0,NULL,'Percentage',1),
	(2,'nil due','nil-due','r35c03c2c16b4420d89db80a448d720f','wewewe',1,0,0,2,3,5,NULL,NULL,'score','true_false',0,'2018-09-26 21:17:13.559700','2018-09-26 21:17:13.559700',NULL,10,'normal','normal','App\\Models\\Course',0,NULL,'Points',1);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `assignments` WRITE;
/*!40000 ALTER TABLE `assignments` DISABLE KEYS */;

INSERT INTO `assignments` (`id`, `title`, `desc`, `due_date`, `available_date`, `points`, `parent_id`, `creator_id`, `grade_only`, `category_id`, `submission_late`, `permalink`, `type`, `group_max`, `min_num_posts`, `min_num_comments`, `word_count_posts`, `word_count_comments`, `posts_required`, `comments_required`, `created_at`, `updated_at`, `resource_key`, `deleted_at`, `grades_published`, `grader_scheme`, `google_convert_submissions`, `upload_restrict_extensions`, `grade_scheme`, `submission_scheme`, `anonymous_posting`, `discussion_visibility`)
VALUES
	(2,'Space Freefall Discussion Board','Watch the video and leave ONE post on the discussion board and ONE comment for  25 points. ** Minimum of 40 words for your post and a minimum of 10 words on a comment for full credit.','2018-10-19 06:59:00','2018-08-28 00:15:00',25,3,1,0,11,1,'space-freefall-discussion','Individual',2,0,0,0,0,'Recommended','Recommended','2018-08-28 00:15:59.479800','2018-09-26 10:47:54.186900','zcda01b14200644a79a16126992f807a',NULL,1,'Professor',0,NULL,'Points','Discussion Board',0,'always'),
	(3,'Lunar Travel Topic Paper','For this assignment, each of you will be writing a 4-6 page research paper outlining the US and Soviet attempts to land on the moon, detailing the roadblocks in their way and the impact that the 1969 lunar landing has had on our modern understanding of astronomy. Use at least three scholarly and two non-scholarly sources.','2018-10-19 06:59:00','2018-08-28 00:16:00',50,3,1,0,11,1,'lunar-travel-topic-paper','Individual',2,0,0,0,0,'Recommended','Recommended','2018-08-28 00:16:46.982400','2018-09-26 10:55:13.133000','h1e210e3ce3aa43a5b3fde8547648cce',NULL,1,'Professor',0,NULL,'(In)complete','File Submission',0,'always'),
	(4,'Group Overnight Starwatch','The purpose of this project is to get you to take note of the apparent motion of the constellations with\nrespect to the horizon. The diurnal motion is observed by watching a constellation through one night.\nKeep in mind that the “time of day” is the position of the sun with respect to YOU.\n\nDo this on the first CLEAR NIGHT!! It can cloud up for weeks & weeks!!!\n\n** See attached handout for project details.\n** Attach a photo below for proof of your group stargazing.\n\nWe will discuss in class your experience after winter break.','2018-11-08 06:59:00','2018-08-28 00:16:00',30,3,1,0,11,1,'group-overnight-starwatch','Group',3,0,0,0,0,'Recommended','Recommended','2018-08-28 00:18:18.896200','2018-09-26 19:51:26.936800','d74943de54eef49108523c16ac493e86',NULL,1,'Professor',0,NULL,'Percentage','File Submission',0,'always'),
	(5,'The Night Sky Quiz','Astronomy is the oldest science, and its history shows a growing realization of our insignificant status in a vast and ancient universe.\n\nComplete the quiz and submit for grading, 10 points per question.','2018-11-16 06:59:00','2018-11-09 00:18:00',30,3,1,0,13,0,'the-night-sky-quiz','Individual',2,0,0,0,0,'Recommended','Recommended','2018-08-28 00:19:01.029000','2018-09-26 12:35:37.826700','ud7c1186e1a44432a963cdacd4368e4d','2018-09-26 12:35:37.826700',1,'Professor',0,NULL,'Percentage','No Submission',0,'always'),
	(6,'Intro to Astronomy Exam','A continuing revolution in telescope design and construction is giving astronomers an unprecedented set of tools for exploring the universe.\n\nThis exam will be graded before spring break, please ask if any questions!','2018-10-04 06:59:00','2018-08-28 00:19:00',40,3,1,0,12,0,'intro-to-astronomy-exam','Individual',2,0,0,0,0,'Recommended','Recommended','2018-08-28 00:19:55.745200','2018-09-26 10:47:12.607700','c40d8a7ce79894a879ee92d410052626',NULL,1,'Professor',0,NULL,'Letter Grade','No Submission',0,'always'),
	(7,'Mission to Mars','Review the SpaceX Mission to Mars and write up a one-page paper with your opinions on the pros and cons of this mission. And your thoughts on when it is possible.','2018-10-02 06:59:00','2018-08-28 00:20:00',50,3,1,0,14,0,'mission-to-mars','Individual',2,0,0,0,0,'Recommended','Recommended','2018-08-28 00:20:29.855900','2018-09-26 10:55:29.345300','lf1f97d5feb6746769401727a7d7988e',NULL,1,'Professor',0,NULL,'Letter Grade','File Submission',0,'always'),
	(8,'Discussion Post #1','Watch this video about the voting rights and representation of U.S. Territories (Guam, American Samoan, and Puerto Rico). Afterwards, share your thoughts on what you learned by posting and commenting on the discussion board below.','2018-10-04 06:59:00','2018-09-26 19:51:00',30,2,3,0,5,0,'discussion-post--1','Individual',2,0,0,0,0,'Recommended','Recommended','2018-09-26 19:53:20.658900','2018-09-26 19:53:20.658900','oc845a1e5fc944b82ac6bdc91d7b7155',NULL,1,'Professor',0,NULL,'Points','Discussion Board',0,'always'),
	(9,'American History Quiz on Chapter 1&2','This is the first History Quiz for the class and will cover chapter\'s 1 & 2 on how the U.S. government was formed and the American Revolution.','2018-10-04 06:59:00','2018-09-26 19:53:00',40,4,3,0,17,0,'american-history-quiz-on-','Individual',2,0,0,0,0,'Recommended','Recommended','2018-09-26 19:54:01.966600','2018-09-26 19:54:01.966600','h2c18ba321e834175838d08ef18f5573',NULL,1,'Professor',0,NULL,'Percentage','No Submission',0,'always'),
	(10,'not published','wefwef','2018-10-04 06:59:00','2018-09-26 21:14:00',80,2,3,0,5,0,'not-published','Individual',2,0,0,0,0,'Recommended','Recommended','2018-09-26 21:14:20.415100','2018-09-26 21:14:25.036900','z51235fd8ecd340949043e24b101c449',NULL,0,'Professor',0,NULL,'Points','No Submission',0,'always'),
	(11,'not availavble yet','scvd','2018-11-01 06:59:00','2018-10-17 21:14:00',30,2,3,0,5,0,'not-availavble-yet','Individual',2,0,0,0,0,'Recommended','Recommended','2018-09-26 21:14:56.682800','2018-09-26 21:14:56.682800','iddef06c406e74b9ea41a067887638f8',NULL,1,'Professor',0,NULL,'Points','No Submission',0,'always');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `attachments` WRITE;
/*!40000 ALTER TABLE `attachments` DISABLE KEYS */;

INSERT INTO `attachments` (`id`, `attachment_name`, `file_name`, `location`, `status`, `owner_id`, `parent_id`, `parent_type`, `available_date`, `view_scheme`, `created_at`, `updated_at`, `resource_key`, `attachment_scheme`, `size`, `type`, `deleted_at`, `related_id`, `related_type`)
VALUES
	(1,'Explorations: Introduction to Astronomy',NULL,'9780077345099','completed',1,3,'App\\Models\\Course','2018-08-28 00:05:16',NULL,'2018-08-28 00:05:20.787900','2018-08-28 00:05:20.787900','vfc60395a035d41069bf6f8263557350','Book',0,NULL,NULL,NULL,NULL),
	(2,'https://medium.com/s/story/why-a-great-customer-experience-can-be-even-more-important-than-the-product-d347e4dd3f6e',NULL,'https://medium.com/s/story/why-a-great-customer-experience-can-be-even-more-important-than-the-product-d347e4dd3f6e','completed',3,3,'App\\Models\\User',NULL,NULL,'2018-09-26 10:31:37.015000','2018-09-26 10:31:37.015000','o3dc3c351a35e48d9833efe240cdf63a','External',0,NULL,NULL,NULL,NULL);

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
	(8,10,4,'This link will help you determine the difference between the two black holes formations!\nhttp://www.pitt.edu/~jdnorton/teaching/HPS_0410/chapters/black_holes/#Newtonian1','2018-08-28 00:29:04.204100','2018-08-28 00:29:11.033200','hc16cc4a29bdf4ed79838367aa4b5aec',NULL,'2018-08-28 00:29:11.018700',0),
	(9,3,7,'www.usnews.com/news/national-news/articles/2018-06-19/is-leaving-the-un-human-rights-council-a-big-deal','2018-09-26 10:33:13.840300','2018-09-26 10:33:21.776100','uceefd7ae300741839fb0e6a888c1209','2018-09-26 10:33:21.776100',NULL,0),
	(10,19,6,'Social media plays a huge impact on politics. For example, Donald Trump uses Twitter as a way to easily voice his opinion to the public to generate a lot of controversy on particular issues and topics.','2018-09-26 10:37:26.421300','2018-09-26 10:37:49.387300','if1705eef7d8c487587f2a5f947f4c53','2018-09-26 10:37:49.387300',NULL,0),
	(11,19,6,'Social media plays a huge impact on politics. For example, Donald Trump uses Twitter as a way to easily voice his opinion to the public to generate a lot of controversy on particular issues and topics.','2018-09-26 10:37:57.395000','2018-09-26 10:37:57.395000','e028722bd85ce4ae5b9330e0d709a998',NULL,NULL,0),
	(12,3,6,'Exactly! It works perfectly!','2018-09-26 19:54:31.317300','2018-09-26 19:54:31.317300','v01b4ab8266dd46e39558b1728a37c33',NULL,NULL,0);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;

INSERT INTO `courses` (`id`, `university_id`, `term_id`, `name`, `subject`, `number`, `permalink`, `available_date`, `end_date`, `enrollment_close_date`, `archive_date`, `units`, `use_weighted_grades`, `created_at`, `updated_at`, `resource_key`, `deleted_at`, `use_drop_lowest`, `type`, `location`, `description`, `invite_group_id`, `price`, `download_restrict_assessments`, `download_restrict_assignments`, `download_restrict_bulletin`, `download_restrict_documents`, `download_restrict_submissions`, `download_restrict_extensions`, `course_tab_enabled_about`, `course_tab_enabled_about_t_a`, `course_tab_enabled_about_student`, `course_tab_enabled_assignments`, `course_tab_enabled_assignments_t_a`, `course_tab_enabled_assignments_student`, `course_tab_enabled_documents`, `course_tab_enabled_documents_t_a`, `course_tab_enabled_documents_student`, `course_tab_enabled_grades`, `course_tab_enabled_grades_t_a`, `course_tab_enabled_grades_student`, `course_tab_enabled_roster`, `course_tab_enabled_roster_t_a`, `course_tab_enabled_roster_student`, `course_tab_name_about`, `course_tab_name_assignments`, `course_tab_name_documents`, `course_tab_name_grades`, `course_tab_name_roster`, `course_tab_name_bulletin`, `points_enabled`, `enable_student_average_grade_letter`, `enable_student_average_grade_letter_t_a`, `enable_student_average_grade_letter_student`, `enable_student_average_grade_percentage`, `enable_student_average_grade_percentage_t_a`, `enable_student_average_grade_percentage_student`, `enable_student_average_grade_points`, `enable_student_average_grade_points_t_a`, `enable_student_average_grade_points_student`, `enable_letter_grade_override`, `grade_scheme`, `grade_base`, `grade_precision`, `grade_curve_amount`, `paywall`, `published`, `profile_picture`, `grade_scale`, `course_tab_enabled_about_observer`, `course_tab_enabled_assignments_observer`, `course_tab_enabled_documents_observer`, `course_tab_enabled_grades_observer`, `course_tab_enabled_roster_observer`)
VALUES
	(1,1,1,'Electro Magnetic Physics','PHYS','241','phys-241','2014-01-01 00:00:00','2050-01-01 00:00:00','2030-01-01 00:00:00',NULL,4,0,'2016-05-13 01:59:34.340111','2018-09-26 10:20:32.898600','bOVgMXqceI7050G5oNQI8G7TgALRy5gz',NULL,0,NULL,'Harville 220','In addition to the basic concepts of Electromagnetism, a vast variety of interesting topics are covered in this course: Lightning, Pacemakers, Electric Shock Treatment, Electrocardiograms, Metal Detectors, Musical Instruments, Magnetic Levitation, Bullet Trains, Electric Motors, Radios, TV, Car Coils, Superconductivity, Aurora Borealis, Rainbows, Radio Telescopes, Interferometers, Particle Accelerators (a.k.a. Atom Smashers or Colliders), Mass Spectrometers, Red Sunsets, Blue Skies, Haloes around Sun and Moon, Color Perception, Doppler Effect, Big-Bang Cosmology.',NULL,0.00,1,1,1,1,0,'',1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,'About','Assignments','Documents','Grades','Roster','Bulletin',1,1,1,1,1,1,1,0,0,0,0,'round','percent',1,0,1,1,NULL,'F,0,30;D,60,65;C,70,75;B,80,85;A,90,95',1,1,1,0,1),
	(2,1,1,'Honors English','ENG','109','eng-109h','2014-01-01 00:00:00','2050-01-01 00:00:00','2030-01-01 00:00:00',NULL,3,0,'2016-05-13 01:59:41.304750','2018-09-26 10:21:14.128000','oP8ByiAzFX6MQ8eSlsoNzPoYBQgXWrci',NULL,0,NULL,'Hall B202','',NULL,0.00,1,1,1,1,0,'',1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,'About','Assignments','Documents','Grades','Roster','Bulletin',1,1,1,1,1,1,1,0,0,0,0,'round','percent',1,0,1,1,NULL,'F,0,30;D,60,65;C,70,75;B,80,85;A,90,95',1,1,1,0,1),
	(3,1,1,'Exploring Time and Space','ASTR','108','astronomy--exploring-time','2014-01-01 00:00:00','2050-01-01 00:00:00',NULL,NULL,3,0,'2018-08-28 00:04:20.354200','2018-09-26 14:27:53.842600','lc70cff6d40844d52b9927fa9a406a13',NULL,0,NULL,'Suite 200','This course is designed for anyone who is interested in learning more about modern astronomy. We will help you get up to date on the most recent astronomical discoveries while also providing support at an introductory level for those who have no background in science.',NULL,0.00,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,'About','Assignments','Documents','Grades','Roster','Bulletin',1,1,1,1,1,1,1,0,0,0,0,'round','percent',1,0,0,1,'https://demo.notebowl.xyz/rpc/v1.0/services/generate/profilePicture/BF4458/854D88','F,0,30;D-,60,61.5;D,63,65;D+,67,68.5;C-,70,71.5;C,73,75;C+,77,78.5;B-,80,81.5;B,83,85;B+,87,88.5;A-,90,91.5;A,93,95;A+,97,98.5',1,1,1,0,1),
	(4,1,1,'American History: The Role of Politics and Government','AMH','400','american-history--the-rol','2014-01-01 00:00:00','2050-01-01 00:00:00',NULL,NULL,0,0,'2018-08-28 00:31:37.039100','2018-09-26 10:01:35.216400','le4acf50aaacc4d86a8ad041040cfa3d',NULL,0,NULL,NULL,NULL,NULL,0.00,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,'About','Assignments','Documents','Grades','Roster','Bulletin',1,1,1,1,1,1,1,0,0,0,0,'round','percent',1,0,0,1,NULL,'F,0,30;D,60,65;C,70,75;B,80,85;A,90,95',1,1,1,0,1),
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
	(2,3,5,'CTYj90xHVSYMuB1UW05SbstexZQVaSgZ','native',NULL,'2018-09-26 21:17:19.745200',NULL,'Professor','Accepted','App\\Models\\Course',1,'2018-09-26 21:17:19.000000'),
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
	(3,3,26,'v10654dbd44574da4a7fc36cbda7f976','native','2018-08-28 00:05:35.134800','2018-09-26 19:54:08.082200',NULL,'Professor','Accepted','App\\Models\\Course',1,'2018-09-26 19:54:08.000000'),
	(3,1,27,'y2dfd06aceeb94d648c36ee201dbad72','native','2018-08-28 00:06:01.514300','2018-08-28 00:20:50.735300',NULL,'Professor','Accepted','App\\Models\\Course',1,'2018-08-28 00:20:50.000000'),
	(3,10,28,'k4ee0d0024c6f408fbebb772b4ebf9b5','native','2018-08-28 00:14:02.983500','2018-08-28 00:14:02.983500',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(3,2,29,'b4f4c2a8e695f4ecca11e7aca71b0a4d','native','2018-08-28 00:14:10.944200','2018-08-28 00:14:10.944200',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(3,14,30,'g6a3da4f992d74e63bf73335a3d7f9b7','native','2018-08-28 00:14:32.414800','2018-08-28 00:14:32.414800',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(3,11,31,'sba6718e290774e3f98feb07a51bd332','native','2018-08-28 00:14:38.435400','2018-09-26 10:44:39.050100',NULL,'Student','Accepted','App\\Models\\Course',1,'2018-09-26 10:44:39.000000'),
	(4,3,32,'j521e4337397c4b2484eabf265e314cd','native','2018-08-28 00:31:51.672400','2018-09-26 19:54:09.088600',NULL,'Professor','Accepted','App\\Models\\Course',1,'2018-09-26 19:54:09.000000'),
	(5,3,33,'obd58aaaf121440c8afa9b47d25522af','native','2018-08-28 00:32:38.218400','2018-08-28 00:35:29.227700',NULL,'Professor','Accepted','App\\Models\\Course',1,'2018-08-28 00:35:29.000000'),
	(6,3,34,'yb1f56e05de0b4d0fa9947708cafb791','native','2018-08-28 00:33:18.675000','2018-08-28 00:35:44.707700',NULL,'Professor','Accepted','App\\Models\\Course',1,'2018-08-28 00:35:44.000000'),
	(4,10,35,'h8c1d469106224e308f0704c03ab98ac','native','2018-08-28 00:34:24.713100','2018-08-28 00:34:24.713100',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(1,19,36,'c743abe115b3f461b941e0663793dabe','native','2018-09-26 10:13:11.131500','2018-09-26 10:13:11.131500',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(2,19,37,'o18f7bc6aa08a48c88193d81c5711297','native','2018-09-26 10:13:18.459600','2018-09-26 10:13:18.459600',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(3,19,38,'fd57a22fac4504224aca1f3f35d2bed3','native','2018-09-26 10:13:31.988800','2018-09-26 14:29:26.787800',NULL,'Student','Accepted','App\\Models\\Course',1,'2018-09-26 14:29:26.000000'),
	(4,19,39,'tcf0c892941ac47f2a5cb5a53f2e370c','native','2018-09-26 10:13:40.226200','2018-09-26 10:37:10.805100',NULL,'Student','Accepted','App\\Models\\Course',1,'2018-09-26 10:37:10.000000'),
	(5,19,40,'oce9884d9693b43da8e1338d7d30a7f2','native','2018-09-26 10:13:50.237800','2018-09-26 10:13:50.237800',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(6,19,41,'pc672a14c4b3342b9a1260a09f063223','native','2018-09-26 10:14:00.737900','2018-09-26 10:14:00.737900',NULL,'Student','Accepted','App\\Models\\Course',1,NULL),
	(1,19,42,'xd3d0cead258c43eb8580b75eec2a04f','native','2018-09-26 10:14:11.400000','2018-09-26 10:14:11.400000',NULL,'Member','Accepted','App\\Models\\Group',1,NULL);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
	(7,10.000000,19,'App\\Models\\User','2018-09-26 12:36:22.408500','2018-09-26 12:36:22.408500','z173bdab11e484eb584360abd65e326f',NULL,1,'App\\Models\\AssessmentSubmission','2018-09-26 12:36:22','App\\Models\\Assessment',1,19);

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
	(33,11,3,'2018-09-26 19:49:07.621000','2018-09-26 19:49:07.621000','zf823070d830a4faf884e947f3f681df','App\\Models\\Comment',NULL);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
	(15,'363b8c85dc28','2018-08-21 18:03:59.000000','2018-08-21 17:58:59.412800','2018-08-28 00:02:43.421600','2018-08-28 00:02:43.421600',0),
	(16,'da62253136e2','2018-08-28 00:44:27.000000','2018-08-28 00:02:43.376200','2018-09-26 10:01:33.964700','2018-09-26 10:01:33.964700',0),
	(17,'345b20cfa4f0','2018-09-26 11:01:41.000000','2018-09-26 10:01:33.925200','2018-09-26 14:22:55.849100','2018-09-26 14:22:55.849100',0),
	(18,'fb62dce84f4e','2018-09-26 19:51:07.000000','2018-09-26 14:22:55.680500','2018-09-26 19:46:07.565900',NULL,0);

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
	('2018_08_13_000738_createDiscussionVisibility',73),
	('2018_08_24_180902_attachment_related',73),
	('2018_08_27_212925_eventsTable',73),
	('2018_08_27_213627_assignmentGroups',73),
	('2018_08_28_221755_courseGradeScaleColumn',73),
	('2018_08_31_180443_restrictRoster',73),
	('2018_09_04_215631_addLoggedoutIndex',73),
	('2018_09_06_210420_observerTabPermissions',73),
	('2018_09_11_030527_gradesIndex',73);

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
	(1,'App\\Models\\Attachment','recommend_apple_link','N;',NULL,'2018-08-28 00:05:20.901500','2018-08-28 00:05:20.901500',10,NULL),
	(2,'App\\Models\\Attachment','sort_value','N;',NULL,'2018-09-26 10:31:37.065500','2018-09-26 10:31:37.065500',11,NULL),
	(2,'App\\Models\\Attachment','thumbnail_url','s:70:\"https://cdn-images-1.medium.com/max/2000/1*cR4zJueh_V4wqgoQq_ZIdA.jpeg\";',NULL,'2018-09-26 10:31:37.085200','2018-09-26 10:31:37.085200',12,NULL),
	(2,'App\\Models\\Attachment','title','s:43:\"How Companies Thrive By Making You Obsessed\";',NULL,'2018-09-26 10:31:37.089100','2018-09-26 10:31:37.089100',13,NULL),
	(2,'App\\Models\\Attachment','description','s:122:\"Sephora provides an excellent case study in how companies can grow by making the experience more pleasant for the customer\";',NULL,'2018-09-26 10:31:37.092600','2018-09-26 10:31:37.092600',14,NULL),
	(2,'App\\Models\\Attachment','domain','s:6:\"Medium\";',NULL,'2018-09-26 10:31:37.094900','2018-09-26 10:31:37.094900',15,NULL);

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
	(25,19,7,'App\\Models\\Notification','text','s:122:\"Andrew Chaifetz commented on a post in American History: The Role of Politics and Government: Exactly! It works perfectly!\";','2018-09-26 19:54:32','2018-09-26 19:54:32',NULL);

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
	(9,1,5,'2018-09-26 19:53:21.893900','2018-09-26 19:53:21.893900',NULL),
	(10,2,5,'2018-09-26 19:53:21.893900','2018-09-26 19:53:21.893900',NULL),
	(11,16,5,'2018-09-26 19:53:21.893900','2018-09-26 19:53:21.893900',NULL),
	(12,19,5,'2018-09-26 19:53:21.893900','2018-09-26 19:53:21.893900',NULL),
	(13,10,6,'2018-09-26 19:54:04.776100','2018-09-26 19:54:04.776100',NULL),
	(14,19,6,'2018-09-26 19:54:04.776100','2018-09-26 19:54:04.776100',NULL),
	(15,19,7,'2018-09-26 19:54:32.350400','2018-09-26 19:54:32.350400',NULL),
	(16,10,7,'2018-09-26 19:54:32.350400','2018-09-26 19:54:32.350400',NULL),
	(17,19,7,'2018-09-26 19:54:32.350400','2018-09-26 19:54:32.350400',NULL);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;

INSERT INTO `notifications` (`id`, `created_at`, `updated_at`, `resource_key`, `type`, `parent_type`, `deleted_at`, `parent_id`, `owner_id`, `owner_type`, `creator_id`)
VALUES
	(1,'2018-09-26 19:49:10.189500','2018-09-26 19:49:10.189500','z017c38cd04a84fdd9097b1dbe667bff','created','App\\Models\\Comment',NULL,11,33,'App\\Models\\Like',3),
	(2,'2018-09-26 19:50:50.218600','2018-09-26 19:50:50.218600','k07344dc4a5d441bfb5e95c3abe4c592','updated','App\\Models\\Grade',NULL,1,1,'App\\Models\\Grade',3),
	(3,'2018-09-26 19:50:59.485600','2018-09-26 19:50:59.485600','ed2dcaf3bdd1348e3a8a8dd50a8a1d68','updated','App\\Models\\Grade',NULL,3,3,'App\\Models\\Grade',3),
	(4,'2018-09-26 19:51:30.045200','2018-09-26 19:51:30.045200','h57dac006f51140e7ac4b57b2568cb77','updated','App\\Models\\Assignment',NULL,4,4,'App\\Models\\Assignment',3),
	(5,'2018-09-26 19:53:21.869400','2018-09-26 19:53:21.869400','rd2a805567e8045efa1349de50e24c95','created','App\\Models\\Assignment',NULL,8,8,'App\\Models\\Assignment',3),
	(6,'2018-09-26 19:54:04.753100','2018-09-26 19:54:04.753100','ne494d6d305a4413db0e66ee93df8466','created','App\\Models\\Assignment',NULL,9,9,'App\\Models\\Assignment',3),
	(7,'2018-09-26 19:54:32.336700','2018-09-26 19:54:32.336700','xd3acd7d6addf43a690552f08a1a329b','created','App\\Models\\Post',NULL,6,12,'App\\Models\\Comment',3);

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
	(6,'Hi Class! Let\'s expand on our lecture from earlier today, how does social media impact politics and the news? What\'s a great example of this?',3,4,'App\\Models\\Course',0,'2018-08-28 00:35:54.170800','2018-08-28 00:35:54.170800','tcc103f3018c9471caae122e1b4630c0',NULL,NULL,0,'2018-08-28 00:35:52',4,'App\\Models\\Course',4,'App\\Models\\Course'),
	(7,'Hi Class! Check out this article that discusses the issues with the U.S. leaving the Human Rights Council. The article talks about many of the concepts from today\'s lecture!\nhttps://medium.com/s/story/why-a-great-customer-experience-can-be-even-more-important-than-the-product-d347e4dd3f6e',3,4,'App\\Models\\Course',0,'2018-09-26 10:29:49.888100','2018-09-26 10:33:29.435900','l4f54b6e284274e5fb76d3fc027b5f7f','2018-09-26 10:33:29.435900','2018-09-26 10:31:54.830900',0,'2018-09-26 10:29:47',4,'App\\Models\\Course',4,'App\\Models\\Course'),
	(8,'I\'m having trouble understanding the different types of radiation. Can we go over that Monday?',19,3,'App\\Models\\Course',0,'2018-09-26 10:38:30.627700','2018-09-26 10:39:09.087200','y1253bbcd5d1b48ecb3fd62dbdbd8725','2018-09-26 10:39:09.087200',NULL,0,'2018-09-26 10:38:28',3,'App\\Models\\Course',3,'App\\Models\\Course');

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
	(340,18,'App\\Models\\UserSession','q5e9bfa516c2641918105df8a1781176','2018-08-28 00:42:07','2018-08-28 00:42:07'),
	(341,102,'App\\Models\\ActivityLog','n85e686f4aefa48b988d6c37c11d72e8','2018-09-26 10:01:35','2018-09-26 10:01:35'),
	(342,103,'App\\Models\\ActivityLog','rfa6a95b9455c403087500d059ad9743','2018-09-26 10:01:35','2018-09-26 10:01:35'),
	(343,104,'App\\Models\\ActivityLog','k4d4da4aa65424e698eceeda77fc83bc','2018-09-26 10:01:35','2018-09-26 10:01:35'),
	(344,105,'App\\Models\\ActivityLog','hdf15a5162d5243e3a89979fbc3b184f','2018-09-26 10:01:35','2018-09-26 10:01:35'),
	(345,106,'App\\Models\\ActivityLog','qe12f05feef124e66b3009b9d50185f7','2018-09-26 10:01:35','2018-09-26 10:01:35'),
	(346,107,'App\\Models\\ActivityLog','ye7ffc7242a64484cbd7e09bde85e911','2018-09-26 10:01:35','2018-09-26 10:01:35'),
	(347,19,'App\\Models\\UserSession','tef9304866e464ceaa6d3009c11c5c82','2018-09-26 10:02:57','2018-09-26 10:02:57'),
	(348,20,'App\\Models\\UserSession','nf0745dc983594d6b9794dc70d76f21e','2018-09-26 10:06:12','2018-09-26 10:06:12'),
	(349,21,'App\\Models\\UserSession','lf08ca61a42b94c8d90a2d4c277fc15e','2018-09-26 10:06:17','2018-09-26 10:06:17'),
	(350,108,'App\\Models\\ActivityLog','o9a7c5af9571f47cc85aac943b8bc9b5','2018-09-26 10:11:02','2018-09-26 10:11:02'),
	(351,19,'App\\Models\\User','wf8be385309224b6c86e04323fa4a28d','2018-09-26 10:11:31','2018-09-26 10:11:31'),
	(352,109,'App\\Models\\ActivityLog','f35ce2c5ba97d48beb7b97c1ebec05cf','2018-09-26 10:11:31','2018-09-26 10:11:31'),
	(353,110,'App\\Models\\ActivityLog','md4c9b2c725a84f09860ec3cd16cd5b7','2018-09-26 10:11:31','2018-09-26 10:11:31'),
	(354,111,'App\\Models\\ActivityLog','ra6f9fe2244324cfc925f21a2d915034','2018-09-26 10:11:47','2018-09-26 10:11:47'),
	(355,112,'App\\Models\\ActivityLog','v1afe833c109f4a6caf046b0b75bc90d','2018-09-26 10:12:06','2018-09-26 10:12:06'),
	(356,22,'App\\Models\\UserSession','s120a6d706ae4425caa39440f56597f9','2018-09-26 10:12:06','2018-09-26 10:12:06'),
	(357,23,'App\\Models\\UserSession','c31982aeb38d849ebb572490b5d84244','2018-09-26 10:12:07','2018-09-26 10:12:07'),
	(358,36,'App\\Models\\Enrollment','c743abe115b3f461b941e0663793dabe','2018-09-26 10:13:11','2018-09-26 10:13:11'),
	(359,113,'App\\Models\\ActivityLog','f6b1430765a2b428eb21a16a11a0e457','2018-09-26 10:13:11','2018-09-26 10:13:11'),
	(360,37,'App\\Models\\Enrollment','o18f7bc6aa08a48c88193d81c5711297','2018-09-26 10:13:18','2018-09-26 10:13:18'),
	(361,114,'App\\Models\\ActivityLog','i2a38ceff40a74d34bcab0ea4c12e79d','2018-09-26 10:13:18','2018-09-26 10:13:18'),
	(362,38,'App\\Models\\Enrollment','fd57a22fac4504224aca1f3f35d2bed3','2018-09-26 10:13:32','2018-09-26 10:13:32'),
	(363,115,'App\\Models\\ActivityLog','h30f34baa69f04ea1b7c0b9fef3ce3fe','2018-09-26 10:13:32','2018-09-26 10:13:32'),
	(364,39,'App\\Models\\Enrollment','tcf0c892941ac47f2a5cb5a53f2e370c','2018-09-26 10:13:40','2018-09-26 10:13:40'),
	(365,116,'App\\Models\\ActivityLog','w0c00b05ddf924e91a45c8012c7c703c','2018-09-26 10:13:40','2018-09-26 10:13:40'),
	(366,40,'App\\Models\\Enrollment','oce9884d9693b43da8e1338d7d30a7f2','2018-09-26 10:13:50','2018-09-26 10:13:50'),
	(367,117,'App\\Models\\ActivityLog','se3a2f522cc0c4d069028f0b0d97c285','2018-09-26 10:13:50','2018-09-26 10:13:50'),
	(368,41,'App\\Models\\Enrollment','pc672a14c4b3342b9a1260a09f063223','2018-09-26 10:14:01','2018-09-26 10:14:01'),
	(369,118,'App\\Models\\ActivityLog','g9f0c6bcd53154e6191b2ec9eba87126','2018-09-26 10:14:01','2018-09-26 10:14:01'),
	(370,42,'App\\Models\\Enrollment','xd3d0cead258c43eb8580b75eec2a04f','2018-09-26 10:14:11','2018-09-26 10:14:11'),
	(371,119,'App\\Models\\ActivityLog','h4ffe374b059b41ff8cc34fd8382a948','2018-09-26 10:14:11','2018-09-26 10:14:11'),
	(372,120,'App\\Models\\ActivityLog','b99056439037b4d399072e4b4f5c75bb','2018-09-26 10:15:22','2018-09-26 10:15:22'),
	(373,121,'App\\Models\\ActivityLog','b5ab33cd5fa96480ebcf5c0bed36a628','2018-09-26 10:20:33','2018-09-26 10:20:33'),
	(374,122,'App\\Models\\ActivityLog','m58314567375940c9a54c154a90b7b7e','2018-09-26 10:20:54','2018-09-26 10:20:54'),
	(375,123,'App\\Models\\ActivityLog','wd46b7c502f684601a2ae548cafe2820','2018-09-26 10:21:14','2018-09-26 10:21:14'),
	(376,24,'App\\Models\\UserSession','td64ab7ba5919427bb065ce4b2bffa6a','2018-09-26 10:21:42','2018-09-26 10:21:42'),
	(377,25,'App\\Models\\UserSession','l55862f7a58ec476c89081556c2a93da','2018-09-26 10:21:42','2018-09-26 10:21:42'),
	(378,26,'App\\Models\\UserSession','n159d4a53e3b64d79a5f717f6d2e6b7b','2018-09-26 10:23:28','2018-09-26 10:23:28'),
	(379,124,'App\\Models\\ActivityLog','d793390aa744849d1b54a4eec3c66ccc','2018-09-26 10:25:27','2018-09-26 10:25:27'),
	(380,63,'App\\Models\\Analytic','ecd0e3968aa8a4a769a282237b8dd48c','2018-09-26 10:27:40','2018-09-26 10:27:40'),
	(381,125,'App\\Models\\ActivityLog','rf0d9976526d54759ae7087d783eae05','2018-09-26 10:27:40','2018-09-26 10:27:40'),
	(382,64,'App\\Models\\Analytic','na357e31412364ecdb29058bd771aa04','2018-09-26 10:28:28','2018-09-26 10:28:28'),
	(383,126,'App\\Models\\ActivityLog','s5dde332344264bd6b3685299072c24a','2018-09-26 10:28:28','2018-09-26 10:28:28'),
	(384,7,'App\\Models\\Post','l4f54b6e284274e5fb76d3fc027b5f7f','2018-09-26 10:29:50','2018-09-26 10:29:50'),
	(385,127,'App\\Models\\ActivityLog','hbae23ffb226b469187e709b72f0272f','2018-09-26 10:29:50','2018-09-26 10:29:50'),
	(386,27,'App\\Models\\UserSession','w34645f1de0fa422297d15db4ad57b60','2018-09-26 10:30:40','2018-09-26 10:30:40'),
	(387,65,'App\\Models\\Analytic','x3175925e6a85478997fae90998a6f48','2018-09-26 10:30:45','2018-09-26 10:30:45'),
	(388,128,'App\\Models\\ActivityLog','b3b61213173534331a6de97298faf130','2018-09-26 10:30:46','2018-09-26 10:30:46'),
	(389,129,'App\\Models\\ActivityLog','u12a358366c674d74ba35da4b3d3155c','2018-09-26 10:31:16','2018-09-26 10:31:16'),
	(390,130,'App\\Models\\ActivityLog','ue86d22ec65024214905896a44328aa1','2018-09-26 10:31:32','2018-09-26 10:31:32'),
	(391,2,'App\\Models\\Attachment','o3dc3c351a35e48d9833efe240cdf63a','2018-09-26 10:31:37','2018-09-26 10:31:37'),
	(392,131,'App\\Models\\ActivityLog','e7e936361be374e16884ecfc41bad827','2018-09-26 10:31:37','2018-09-26 10:31:37'),
	(393,132,'App\\Models\\ActivityLog','y793f085f104c409fae5e8ef05273c47','2018-09-26 10:31:55','2018-09-26 10:31:55'),
	(394,9,'App\\Models\\Comment','uceefd7ae300741839fb0e6a888c1209','2018-09-26 10:33:14','2018-09-26 10:33:14'),
	(395,133,'App\\Models\\ActivityLog','mdcaa53c83c3240d29d36dd6a4365a51','2018-09-26 10:33:14','2018-09-26 10:33:14'),
	(396,134,'App\\Models\\ActivityLog','o5890816fa1a14c1fbef3be7ce3a5a32','2018-09-26 10:33:22','2018-09-26 10:33:22'),
	(397,135,'App\\Models\\ActivityLog','kcbee534ed17143ad8f9ee6d2678585b','2018-09-26 10:33:29','2018-09-26 10:33:29'),
	(398,28,'App\\Models\\UserSession','k215764171f434fd6a659b37fafcf053','2018-09-26 10:34:23','2018-09-26 10:34:23'),
	(399,136,'App\\Models\\ActivityLog','z61b4ebee111548d194b5fcd72887ddd','2018-09-26 10:35:21','2018-09-26 10:35:21'),
	(400,66,'App\\Models\\Analytic','u55bd2f3b952841f99e1d56cedb33a61','2018-09-26 10:37:11','2018-09-26 10:37:11'),
	(401,137,'App\\Models\\ActivityLog','w1931aa9581b74e4fabf8d1b4c9d7613','2018-09-26 10:37:11','2018-09-26 10:37:11'),
	(402,10,'App\\Models\\Comment','if1705eef7d8c487587f2a5f947f4c53','2018-09-26 10:37:26','2018-09-26 10:37:26'),
	(403,138,'App\\Models\\ActivityLog','ce438c25ecc6d4670a7fd5bafe7002e5','2018-09-26 10:37:26','2018-09-26 10:37:26'),
	(404,21,'App\\Models\\Like','y2722f35e784948a986c9de554f1bda9','2018-09-26 10:37:29','2018-09-26 10:37:29'),
	(405,139,'App\\Models\\ActivityLog','sfc198208ca844905b53d610f747fe40','2018-09-26 10:37:49','2018-09-26 10:37:49'),
	(406,11,'App\\Models\\Comment','e028722bd85ce4ae5b9330e0d709a998','2018-09-26 10:37:57','2018-09-26 10:37:57'),
	(407,140,'App\\Models\\ActivityLog','y7f083e709b49401b8d7fa4d6fabffb4','2018-09-26 10:37:57','2018-09-26 10:37:57'),
	(408,8,'App\\Models\\Post','y1253bbcd5d1b48ecb3fd62dbdbd8725','2018-09-26 10:38:31','2018-09-26 10:38:31'),
	(409,141,'App\\Models\\ActivityLog','i29279382aa6e4254ba8dd099f1ac8fc','2018-09-26 10:38:31','2018-09-26 10:38:31'),
	(410,22,'App\\Models\\Like','s592a4de118b340c98a5a3deacaa1b87','2018-09-26 10:38:54','2018-09-26 10:38:54'),
	(411,23,'App\\Models\\Like','lc183695e9e6a46ea9d64c00612565a7','2018-09-26 10:39:00','2018-09-26 10:39:00'),
	(412,142,'App\\Models\\ActivityLog','c86d3e17a9de34cef89340eadd4c1987','2018-09-26 10:39:09','2018-09-26 10:39:09'),
	(413,24,'App\\Models\\Like','i49940a3bcf24405da5dee496498a349','2018-09-26 10:39:13','2018-09-26 10:39:13'),
	(414,25,'App\\Models\\Like','k3839c8b3ab48438daf54ba19029d650','2018-09-26 10:39:15','2018-09-26 10:39:15'),
	(415,143,'App\\Models\\ActivityLog','td2944f23304a435883facaad8e197ee','2018-09-26 10:41:05','2018-09-26 10:41:05'),
	(416,29,'App\\Models\\UserSession','v25b46febf2a84b3e859ab6c41f2a57d','2018-09-26 10:41:49','2018-09-26 10:41:49'),
	(417,26,'App\\Models\\Like','o061be9a99dd748ac9b01ee8714c724d','2018-09-26 10:42:13','2018-09-26 10:42:13'),
	(418,27,'App\\Models\\Like','c838e3c43230b410485127d1785e5ec9','2018-09-26 10:42:16','2018-09-26 10:42:16'),
	(419,30,'App\\Models\\UserSession','ad222293bacd1445e952e564b83ad683','2018-09-26 10:42:43','2018-09-26 10:42:43'),
	(420,144,'App\\Models\\ActivityLog','kf2a0c05e5fdb4ab59b1d2397d91ede8','2018-09-26 10:44:38','2018-09-26 10:44:38'),
	(421,67,'App\\Models\\Analytic','m28a269964aef43a79ff186db3995950','2018-09-26 10:44:39','2018-09-26 10:44:39'),
	(422,145,'App\\Models\\ActivityLog','v6da9c527108946ca96ecfdd147440f3','2018-09-26 10:44:39','2018-09-26 10:44:39'),
	(423,28,'App\\Models\\Like','qf5a5c43068864b3f861624075f0816d','2018-09-26 10:44:46','2018-09-26 10:44:46'),
	(424,29,'App\\Models\\Like','bd68b8e4c99e147c2b135c4b1081bdaa','2018-09-26 10:44:48','2018-09-26 10:44:48'),
	(425,30,'App\\Models\\Like','z538a0040c5af4784b8a2264b43600d6','2018-09-26 10:44:52','2018-09-26 10:44:52'),
	(426,31,'App\\Models\\UserSession','dc77ee9d7d36c4fc6b09c65f61bc2964','2018-09-26 10:45:23','2018-09-26 10:45:23'),
	(427,68,'App\\Models\\Analytic','a7bddc4cbbdbb468fa844edfcdd2aac7','2018-09-26 10:45:26','2018-09-26 10:45:26'),
	(428,146,'App\\Models\\ActivityLog','cdf302914339e49a18d07bcb7c064055','2018-09-26 10:45:26','2018-09-26 10:45:26'),
	(429,69,'App\\Models\\Analytic','y133db2fc5b11493ca759640e306593c','2018-09-26 10:45:32','2018-09-26 10:45:32'),
	(430,147,'App\\Models\\ActivityLog','uda0ff4f9cd8546c4a7beb1bfec644ed','2018-09-26 10:45:32','2018-09-26 10:45:32'),
	(431,148,'App\\Models\\ActivityLog','i2038fe02424d4118a6fb34d689eda30','2018-09-26 10:45:44','2018-09-26 10:45:44'),
	(432,70,'App\\Models\\Analytic','w93cf9c8b522c4cee83354a071f5f5b6','2018-09-26 10:45:47','2018-09-26 10:45:47'),
	(433,149,'App\\Models\\ActivityLog','s674d53ab40624d69adf1285c43bcd73','2018-09-26 10:45:47','2018-09-26 10:45:47'),
	(434,71,'App\\Models\\Analytic','k09e484d3d1e84065a2646c83069ba86','2018-09-26 10:45:49','2018-09-26 10:45:49'),
	(435,150,'App\\Models\\ActivityLog','x8c40d35432104a7db33643b26c8a955','2018-09-26 10:45:49','2018-09-26 10:45:49'),
	(436,72,'App\\Models\\Analytic','t676a1bd125034da182cd76da857a496','2018-09-26 10:46:19','2018-09-26 10:46:19'),
	(437,151,'App\\Models\\ActivityLog','tdc36232de503419583272e40634950c','2018-09-26 10:46:19','2018-09-26 10:46:19'),
	(438,73,'App\\Models\\Analytic','y780836fd20724756be53d722d101fd3','2018-09-26 10:46:20','2018-09-26 10:46:20'),
	(439,74,'App\\Models\\Analytic','jbd7da90dfd1d471b9512b8362d90a31','2018-09-26 10:46:22','2018-09-26 10:46:22'),
	(440,152,'App\\Models\\ActivityLog','odc9b57aa80404f59b0d035f3e19843a','2018-09-26 10:46:22','2018-09-26 10:46:22'),
	(441,75,'App\\Models\\Analytic','h7e81137be61048fd9fdc3e8b4c81fb8','2018-09-26 10:46:33','2018-09-26 10:46:33'),
	(442,153,'App\\Models\\ActivityLog','le11e3087ad1a4ee88b5023492cc353f','2018-09-26 10:46:33','2018-09-26 10:46:33'),
	(443,76,'App\\Models\\Analytic','q31ef0c26ce2e4c71a5610dd361e10e7','2018-09-26 10:46:37','2018-09-26 10:46:37'),
	(444,154,'App\\Models\\ActivityLog','j88f2ea5d09794abbb783124599d8b03','2018-09-26 10:46:37','2018-09-26 10:46:37'),
	(445,77,'App\\Models\\Analytic','r7d9590b8f51d4ac0b774156412832d5','2018-09-26 10:46:38','2018-09-26 10:46:38'),
	(446,155,'App\\Models\\ActivityLog','t15f6e55383534bc498df9077f0b4fc2','2018-09-26 10:46:58','2018-09-26 10:46:58'),
	(447,78,'App\\Models\\Analytic','ic310ed69001d4fa898261c29564bc92','2018-09-26 10:47:00','2018-09-26 10:47:00'),
	(448,156,'App\\Models\\ActivityLog','e4fa128100eff40368be9c13bdc0e1cd','2018-09-26 10:47:00','2018-09-26 10:47:00'),
	(449,79,'App\\Models\\Analytic','z7ed8f8509a9c4fb9afa2f0099c06cc9','2018-09-26 10:47:02','2018-09-26 10:47:02'),
	(450,157,'App\\Models\\ActivityLog','mba41e352e4ee4842ae3e7bd4dc422c6','2018-09-26 10:47:02','2018-09-26 10:47:02'),
	(451,80,'App\\Models\\Analytic','t49657180a2034350ad863e54d127ecc','2018-09-26 10:47:02','2018-09-26 10:47:02'),
	(452,158,'App\\Models\\ActivityLog','ffdac3f3f8d884b4786890802d687754','2018-09-26 10:47:13','2018-09-26 10:47:13'),
	(453,81,'App\\Models\\Analytic','fde8f8a478a374fd489b4f7e12bb596d','2018-09-26 10:47:14','2018-09-26 10:47:14'),
	(454,159,'App\\Models\\ActivityLog','q4c75b488ed1b40e68de060c235f4e60','2018-09-26 10:47:14','2018-09-26 10:47:14'),
	(455,82,'App\\Models\\Analytic','a1c4130bbf522494c8b5a9f997b27dcb','2018-09-26 10:47:16','2018-09-26 10:47:16'),
	(456,160,'App\\Models\\ActivityLog','cbc6d31df87394d9ab212b81071a0bb3','2018-09-26 10:47:16','2018-09-26 10:47:16'),
	(457,83,'App\\Models\\Analytic','w70428c966a2c47a5b29f846ce277a11','2018-09-26 10:47:17','2018-09-26 10:47:17'),
	(458,161,'App\\Models\\ActivityLog','i4129d466e32a4871944aa795e8f86d6','2018-09-26 10:47:24','2018-09-26 10:47:24'),
	(459,84,'App\\Models\\Analytic','ea5e9807d02554a5797b383c3fd9e97e','2018-09-26 10:47:27','2018-09-26 10:47:27'),
	(460,162,'App\\Models\\ActivityLog','r70946912fbe04b358224312904d3102','2018-09-26 10:47:27','2018-09-26 10:47:27'),
	(461,85,'App\\Models\\Analytic','m3e45c836c5a1460ab90e29e9c794fe1','2018-09-26 10:47:29','2018-09-26 10:47:29'),
	(462,163,'App\\Models\\ActivityLog','rbed71402a0eb4ac096db703ccdf8f27','2018-09-26 10:47:29','2018-09-26 10:47:29'),
	(463,86,'App\\Models\\Analytic','n6314a3ec9a184086b76c2bc15a42435','2018-09-26 10:47:29','2018-09-26 10:47:29'),
	(464,164,'App\\Models\\ActivityLog','gaf2ba1f670f84afd9766485282e9075','2018-09-26 10:47:40','2018-09-26 10:47:40'),
	(465,87,'App\\Models\\Analytic','e62f3922a26b143f8996adeb33ab94ee','2018-09-26 10:47:42','2018-09-26 10:47:42'),
	(466,165,'App\\Models\\ActivityLog','q09d5a3a44da742d59e7414a3a6f817b','2018-09-26 10:47:42','2018-09-26 10:47:42'),
	(467,88,'App\\Models\\Analytic','k4898746a59b74853b968e093cffcc1f','2018-09-26 10:47:43','2018-09-26 10:47:43'),
	(468,166,'App\\Models\\ActivityLog','mc354ce11747542a49506150c434c0f2','2018-09-26 10:47:43','2018-09-26 10:47:43'),
	(469,89,'App\\Models\\Analytic','qa3665549becb4af18f6caffedefdfd1','2018-09-26 10:47:44','2018-09-26 10:47:44'),
	(470,167,'App\\Models\\ActivityLog','u56f75a8086c149d292b687fec102c4d','2018-09-26 10:47:54','2018-09-26 10:47:54'),
	(471,90,'App\\Models\\Analytic','s8d0772c545454e4fbe0a91e50a76ce8','2018-09-26 10:47:55','2018-09-26 10:47:55'),
	(472,168,'App\\Models\\ActivityLog','fcec8f4065e0849a1be66b22d6a2d729','2018-09-26 10:47:55','2018-09-26 10:47:55'),
	(473,91,'App\\Models\\Analytic','nd2ac3200ef6a467593b81ae1d83e421','2018-09-26 10:47:57','2018-09-26 10:47:57'),
	(474,169,'App\\Models\\ActivityLog','e483b7b23783349ff98aaa2f403e149d','2018-09-26 10:47:57','2018-09-26 10:47:57'),
	(475,92,'App\\Models\\Analytic','v03be69c44d9545a8a1ea7c52d498615','2018-09-26 10:47:57','2018-09-26 10:47:57'),
	(476,170,'App\\Models\\ActivityLog','cc178490c6c2440f7a5375a9e13fe19e','2018-09-26 10:48:04','2018-09-26 10:48:04'),
	(477,93,'App\\Models\\Analytic','z00c1543660244712aadddf2f6afd6d2','2018-09-26 10:48:06','2018-09-26 10:48:06'),
	(478,171,'App\\Models\\ActivityLog','hcd07ac436586401a955bea2af8557bf','2018-09-26 10:48:06','2018-09-26 10:48:06'),
	(479,94,'App\\Models\\Analytic','tc8fc609508374889807bf35afac333b','2018-09-26 10:48:30','2018-09-26 10:48:30'),
	(480,172,'App\\Models\\ActivityLog','f06227bf0b68a413383995bf62b3790d','2018-09-26 10:48:30','2018-09-26 10:48:30'),
	(481,95,'App\\Models\\Analytic','c84728a29fdc644a0bf1d0333f2412b6','2018-09-26 10:48:38','2018-09-26 10:48:38'),
	(482,173,'App\\Models\\ActivityLog','afada6ade64ae44419abff9419fd7149','2018-09-26 10:48:38','2018-09-26 10:48:38'),
	(483,96,'App\\Models\\Analytic','xe40fde15b82749cb95bfc7852f1775f','2018-09-26 10:48:42','2018-09-26 10:48:42'),
	(484,97,'App\\Models\\Analytic','k5afed99e2f1b4f2dbf31ea31267a5c0','2018-09-26 10:48:42','2018-09-26 10:48:42'),
	(485,174,'App\\Models\\ActivityLog','sd8c5e50ce9e74c48a3ff437398ff090','2018-09-26 10:48:42','2018-09-26 10:48:42'),
	(486,98,'App\\Models\\Analytic','yc214b5b11b81490f9f4c87bf32b8081','2018-09-26 10:48:44','2018-09-26 10:48:44'),
	(487,175,'App\\Models\\ActivityLog','l010ab4ba29fc4db3a6d9106ac087588','2018-09-26 10:48:45','2018-09-26 10:48:45'),
	(488,99,'App\\Models\\Analytic','jf3387675139e4d619be270b6ae6e291','2018-09-26 10:48:46','2018-09-26 10:48:46'),
	(489,100,'App\\Models\\Analytic','n4dd9dbda869c43bc9aef6af6fc12285','2018-09-26 10:48:46','2018-09-26 10:48:46'),
	(490,176,'App\\Models\\ActivityLog','p733aa24e55d84ba58647a5e9a854d5c','2018-09-26 10:48:46','2018-09-26 10:48:46'),
	(491,101,'App\\Models\\Analytic','yfc30439787cb496e91a11625991d3f6','2018-09-26 10:48:52','2018-09-26 10:48:52'),
	(492,177,'App\\Models\\ActivityLog','s86ee1deda25147a989500b22701ad4a','2018-09-26 10:48:52','2018-09-26 10:48:52'),
	(493,102,'App\\Models\\Analytic','kd82b47e2d5d04381a28f3485b9bc90f','2018-09-26 10:48:54','2018-09-26 10:48:54'),
	(494,103,'App\\Models\\Analytic','a59bd424cf1ff4b568117e8c9d9cf6b5','2018-09-26 10:48:54','2018-09-26 10:48:54'),
	(495,178,'App\\Models\\ActivityLog','me57ad70b165b4b6a91a453606c2f3ac','2018-09-26 10:48:54','2018-09-26 10:48:54'),
	(496,104,'App\\Models\\Analytic','i3b6fb2752b7c407e8f4bc0de9b88781','2018-09-26 10:48:58','2018-09-26 10:48:58'),
	(497,179,'App\\Models\\ActivityLog','nfd73e88ee9c846a6854c9815df0dec5','2018-09-26 10:48:58','2018-09-26 10:48:58'),
	(498,105,'App\\Models\\Analytic','mdc474cfabe2046949e69abb8ee211ae','2018-09-26 10:49:14','2018-09-26 10:49:14'),
	(499,180,'App\\Models\\ActivityLog','maf5d0a64024048b19ecf1b9b729c9bd','2018-09-26 10:49:14','2018-09-26 10:49:14'),
	(500,181,'App\\Models\\ActivityLog','e02a14a84760249e082e72ac06e92cda','2018-09-26 10:49:28','2018-09-26 10:49:28'),
	(501,106,'App\\Models\\Analytic','w9f9057eaa7c546fb9f8e6de6d7aaaf3','2018-09-26 10:49:29','2018-09-26 10:49:29'),
	(502,182,'App\\Models\\ActivityLog','s949be6c115774d18a0c11991b049a11','2018-09-26 10:49:29','2018-09-26 10:49:29'),
	(503,1,'App\\Models\\Grade','k686eed2e071b4aec80916f80bf13945','2018-09-26 10:49:33','2018-09-26 10:49:33'),
	(504,183,'App\\Models\\ActivityLog','t45e4a3e4c2e041c9aa5fdc3d060da16','2018-09-26 10:49:33','2018-09-26 10:49:33'),
	(505,2,'App\\Models\\Grade','s0508c40eac7041f3af03e45eb4b337d','2018-09-26 10:49:47','2018-09-26 10:49:47'),
	(506,184,'App\\Models\\ActivityLog','w6675574e72d74f3cb161183154506f0','2018-09-26 10:49:47','2018-09-26 10:49:47'),
	(507,107,'App\\Models\\Analytic','va48e4423abcb49fa8b1c435c3168b01','2018-09-26 10:49:52','2018-09-26 10:49:52'),
	(508,185,'App\\Models\\ActivityLog','g611b9bcea7bc4249b47c296576745c3','2018-09-26 10:49:52','2018-09-26 10:49:52'),
	(509,32,'App\\Models\\UserSession','w7511f0531b3f4da98b367a15d8dcd93','2018-09-26 10:50:13','2018-09-26 10:50:13'),
	(510,186,'App\\Models\\ActivityLog','x0a6f7a02d16a4db9b874c25c6b77c8e','2018-09-26 10:50:35','2018-09-26 10:50:35'),
	(511,108,'App\\Models\\Analytic','ebed240eab50e44bfa26076879380302','2018-09-26 10:50:44','2018-09-26 10:50:44'),
	(512,187,'App\\Models\\ActivityLog','l0ea35b5a97eb48c8ac8bf17713c1b3b','2018-09-26 10:50:44','2018-09-26 10:50:44'),
	(513,109,'App\\Models\\Analytic','a4db3559612be4b49953f8502e5a6ed3','2018-09-26 10:50:48','2018-09-26 10:50:48'),
	(514,188,'App\\Models\\ActivityLog','lf1e13a6e50f34649ab6f42b85052c0c','2018-09-26 10:50:48','2018-09-26 10:50:48'),
	(515,110,'App\\Models\\Analytic','kf16463b9fdb74a259a3671af130e09d','2018-09-26 10:50:57','2018-09-26 10:50:57'),
	(516,189,'App\\Models\\ActivityLog','d125aace9bedd4032b59106d3a5a9c8a','2018-09-26 10:50:57','2018-09-26 10:50:57'),
	(517,111,'App\\Models\\Analytic','pc30594f38b4a4e5683d541dc5d65d5a','2018-09-26 10:50:58','2018-09-26 10:50:58'),
	(518,1,'App\\Models\\Submission','tadcbd55243e04a2a95304d5f2aaad82','2018-09-26 10:52:30','2018-09-26 10:52:30'),
	(519,190,'App\\Models\\ActivityLog','q7c07173e3cb34906873f4817a54fd44','2018-09-26 10:52:30','2018-09-26 10:52:30'),
	(520,112,'App\\Models\\Analytic','xe73bb655b684434ebf0114635c17f23','2018-09-26 10:52:33','2018-09-26 10:52:33'),
	(521,191,'App\\Models\\ActivityLog','t485efca8d63e41ad9177509348afeda','2018-09-26 10:52:33','2018-09-26 10:52:33'),
	(522,113,'App\\Models\\Analytic','f4e692cd210dc4fdda0469a3aa2f309d','2018-09-26 10:52:36','2018-09-26 10:52:36'),
	(523,192,'App\\Models\\ActivityLog','xfc960a3567fc4bb087162e5965a00ae','2018-09-26 10:52:37','2018-09-26 10:52:37'),
	(524,114,'App\\Models\\Analytic','n8475751eff934dd9996f8b039556a80','2018-09-26 10:52:37','2018-09-26 10:52:37'),
	(525,1,'App\\Models\\AssignmentGroupUser','a5f0b21877203401995a8166a7edfb80','2018-09-26 10:52:42','2018-09-26 10:52:42'),
	(526,115,'App\\Models\\Analytic','da6b36cfe410141f3883695970ed7cae','2018-09-26 10:52:42','2018-09-26 10:52:42'),
	(527,116,'App\\Models\\Analytic','p8925a06cd54441d5b24c5e65e972149','2018-09-26 10:52:42','2018-09-26 10:52:42'),
	(528,193,'App\\Models\\ActivityLog','d71c5be0bed824d2b8730cbceab7bda2','2018-09-26 10:52:42','2018-09-26 10:52:42'),
	(529,194,'App\\Models\\ActivityLog','fbf6eabc4e55043be9aea5630ab7b3b3','2018-09-26 10:52:42','2018-09-26 10:52:42'),
	(530,117,'App\\Models\\Analytic','m439574604a4147db9ea7b43ace4eb72','2018-09-26 10:52:42','2018-09-26 10:52:42'),
	(531,2,'App\\Models\\Submission','re79098faf34d49adbef3cdcf53471af','2018-09-26 10:52:53','2018-09-26 10:52:53'),
	(532,195,'App\\Models\\ActivityLog','s9f392fdcc81a469cbe7d6b638644dfa','2018-09-26 10:52:53','2018-09-26 10:52:53'),
	(533,118,'App\\Models\\Analytic','j5bf7cfa8afe74c71850b5cbe9df80b2','2018-09-26 10:52:56','2018-09-26 10:52:56'),
	(534,196,'App\\Models\\ActivityLog','o5b8579d1da6541f38b273872f29463c','2018-09-26 10:52:56','2018-09-26 10:52:56'),
	(535,119,'App\\Models\\Analytic','q734775d423b94e7396161f0c21df875','2018-09-26 10:53:01','2018-09-26 10:53:01'),
	(536,197,'App\\Models\\ActivityLog','n3e6011a30fa046d49fb60e859c19283','2018-09-26 10:53:01','2018-09-26 10:53:01'),
	(537,120,'App\\Models\\Analytic','fde69547fa0594f07bb11b90b4a7cd4d','2018-09-26 10:53:01','2018-09-26 10:53:01'),
	(538,121,'App\\Models\\Analytic','j3ea92d988ea54fc7a1019baa5ab92a4','2018-09-26 10:53:08','2018-09-26 10:53:08'),
	(539,198,'App\\Models\\ActivityLog','v0c083e809f1d4d55a0aa03cc02308a3','2018-09-26 10:53:08','2018-09-26 10:53:08'),
	(540,122,'App\\Models\\Analytic','u57b01212943b43f99ab017a80a88c25','2018-09-26 10:53:16','2018-09-26 10:53:16'),
	(541,199,'App\\Models\\ActivityLog','fc9a6cc3f1e9e4fdebad945b47ff7b0a','2018-09-26 10:53:16','2018-09-26 10:53:16'),
	(542,123,'App\\Models\\Analytic','kab6253ee35fa4d70907707076856a75','2018-09-26 10:53:16','2018-09-26 10:53:16'),
	(543,3,'App\\Models\\Submission','j995cdb2ae0f2435eb47c78a5409885a','2018-09-26 10:53:20','2018-09-26 10:53:20'),
	(544,200,'App\\Models\\ActivityLog','q0eaed044c55e4d1d87a488356a4eac5','2018-09-26 10:53:20','2018-09-26 10:53:20'),
	(545,124,'App\\Models\\Analytic','d0d13d58f5364443590b6d3ca8ae3a43','2018-09-26 10:53:23','2018-09-26 10:53:23'),
	(546,201,'App\\Models\\ActivityLog','q667f90d324634aa8bfa7439108479f9','2018-09-26 10:53:23','2018-09-26 10:53:23'),
	(547,33,'App\\Models\\UserSession','g4ac4a8e0eac8491585366817f9f7e65','2018-09-26 10:53:34','2018-09-26 10:53:34'),
	(548,125,'App\\Models\\Analytic','n9db77033c535421b9b75ff58921d922','2018-09-26 10:53:37','2018-09-26 10:53:37'),
	(549,202,'App\\Models\\ActivityLog','la196e5848cf44518b8e263023e8c752','2018-09-26 10:53:37','2018-09-26 10:53:37'),
	(550,126,'App\\Models\\Analytic','bb722a16a10874d50b7d17ce918f4ea2','2018-09-26 10:53:42','2018-09-26 10:53:42'),
	(551,203,'App\\Models\\ActivityLog','uf65273028bd8416cbd0226f20654734','2018-09-26 10:53:42','2018-09-26 10:53:42'),
	(552,127,'App\\Models\\Analytic','y73befd9eb6144576b54812a9282f004','2018-09-26 10:53:43','2018-09-26 10:53:43'),
	(553,128,'App\\Models\\Analytic','bd70b3c551706450daf0c32fd4725d06','2018-09-26 10:53:46','2018-09-26 10:53:46'),
	(554,204,'App\\Models\\ActivityLog','k4591a52ef162444f97577ea62df6922','2018-09-26 10:53:46','2018-09-26 10:53:46'),
	(555,129,'App\\Models\\Analytic','vf8534ae838ea4536817cfd99db563d9','2018-09-26 10:53:47','2018-09-26 10:53:47'),
	(556,205,'App\\Models\\ActivityLog','h9337bc802fa744909970a501ec30c4c','2018-09-26 10:54:35','2018-09-26 10:54:35'),
	(557,3,'App\\Models\\Grade','iff26558edd9f4dc5b791d314d176c31','2018-09-26 10:54:47','2018-09-26 10:54:47'),
	(558,206,'App\\Models\\ActivityLog','a32e1a40e429647edb5f91488d20f523','2018-09-26 10:54:47','2018-09-26 10:54:47'),
	(559,130,'App\\Models\\Analytic','jaa5c6b5e8f7e432eafb25e7c6b6c35a','2018-09-26 10:54:50','2018-09-26 10:54:50'),
	(560,207,'App\\Models\\ActivityLog','wa470b4f8431b40cf94d00b882d31db1','2018-09-26 10:54:50','2018-09-26 10:54:50'),
	(561,131,'App\\Models\\Analytic','o69e9b2eb4d054503a1321af467f6784','2018-09-26 10:54:51','2018-09-26 10:54:51'),
	(562,208,'App\\Models\\ActivityLog','idf2000b0b4d0466995c763fc245a8c3','2018-09-26 10:54:51','2018-09-26 10:54:51'),
	(563,132,'App\\Models\\Analytic','dcc9be8ac37ea4183a41dbfb805a2bab','2018-09-26 10:54:58','2018-09-26 10:54:58'),
	(564,209,'App\\Models\\ActivityLog','a9e25b0eda76a4d1a9c6bade97c207e3','2018-09-26 10:54:58','2018-09-26 10:54:58'),
	(565,133,'App\\Models\\Analytic','h8d04abc472a3407eb35ff4be9be6009','2018-09-26 10:54:59','2018-09-26 10:54:59'),
	(566,210,'App\\Models\\ActivityLog','ua37ec01e922045d494fc13aec645d06','2018-09-26 10:55:13','2018-09-26 10:55:13'),
	(567,134,'App\\Models\\Analytic','xba6474eacd4d4d348b208e6786d9528','2018-09-26 10:55:14','2018-09-26 10:55:14'),
	(568,135,'App\\Models\\Analytic','ia0b12a2c181d4a7d9fd858907b8222c','2018-09-26 10:55:14','2018-09-26 10:55:14'),
	(569,211,'App\\Models\\ActivityLog','f850c0c7ea06644fd80ae8647b46a3da','2018-09-26 10:55:14','2018-09-26 10:55:14'),
	(570,4,'App\\Models\\Grade','z76b4f5782c574048ae656d14361fedc','2018-09-26 10:55:16','2018-09-26 10:55:16'),
	(571,212,'App\\Models\\ActivityLog','na1feb9576ece4ad4b89546b01f63062','2018-09-26 10:55:16','2018-09-26 10:55:16'),
	(572,136,'App\\Models\\Analytic','dae1095a2b61445fd9564c416e3c0fc4','2018-09-26 10:55:17','2018-09-26 10:55:17'),
	(573,213,'App\\Models\\ActivityLog','ef1d5b3f99efa411da8a62384d92921b','2018-09-26 10:55:17','2018-09-26 10:55:17'),
	(574,137,'App\\Models\\Analytic','jecc119736c8d4417a006be7b5ac30a2','2018-09-26 10:55:19','2018-09-26 10:55:19'),
	(575,214,'App\\Models\\ActivityLog','l81606785ec5d4db7a9db370a52f9d88','2018-09-26 10:55:19','2018-09-26 10:55:19'),
	(576,138,'App\\Models\\Analytic','rc4ed0b3036e641fd8a0c34a4369f31a','2018-09-26 10:55:20','2018-09-26 10:55:20'),
	(577,215,'App\\Models\\ActivityLog','p5d0a59e37c994b45b09a2204452268e','2018-09-26 10:55:29','2018-09-26 10:55:29'),
	(578,139,'App\\Models\\Analytic','p0e926e5060994e7195f1557b5f603ab','2018-09-26 10:55:30','2018-09-26 10:55:30'),
	(579,140,'App\\Models\\Analytic','v249941467ec345e7817b9ade0e52fd2','2018-09-26 10:55:30','2018-09-26 10:55:30'),
	(580,216,'App\\Models\\ActivityLog','h4cec752f563d454fb0e3ac3bc4e48a3','2018-09-26 10:55:30','2018-09-26 10:55:30'),
	(581,5,'App\\Models\\Grade','b2df00d7170b3438abd59aec5447cb13','2018-09-26 10:55:34','2018-09-26 10:55:34'),
	(582,217,'App\\Models\\ActivityLog','c3735e354c7d04b1d825d878453220f2','2018-09-26 10:55:34','2018-09-26 10:55:34'),
	(583,141,'App\\Models\\Analytic','e583cc1d4d80c4e61bd524abd998e5dd','2018-09-26 10:55:36','2018-09-26 10:55:36'),
	(584,218,'App\\Models\\ActivityLog','n1c4cc2460cad4089aa1d2a5113af448','2018-09-26 10:55:36','2018-09-26 10:55:36'),
	(585,142,'App\\Models\\Analytic','ra046a3a704ae4dbeaa08c601d559932','2018-09-26 10:55:42','2018-09-26 10:55:42'),
	(586,219,'App\\Models\\ActivityLog','yfe30430cf183498b820593b93985b5d','2018-09-26 10:55:42','2018-09-26 10:55:42'),
	(587,143,'App\\Models\\Analytic','tc3a201d19b114f6aae3f96cf69ae913','2018-09-26 10:55:48','2018-09-26 10:55:48'),
	(588,220,'App\\Models\\ActivityLog','rcd071dc26b59451da493846d5477db9','2018-09-26 10:55:48','2018-09-26 10:55:48'),
	(589,34,'App\\Models\\UserSession','ob5e937403edb4bf99fb39497959a25d','2018-09-26 10:56:12','2018-09-26 10:56:12'),
	(590,144,'App\\Models\\Analytic','y9c0f62171afa4a0284e65a352127079','2018-09-26 10:56:16','2018-09-26 10:56:16'),
	(591,221,'App\\Models\\ActivityLog','q7de78ccf7b114c8cb5ca5c96d48a177','2018-09-26 10:56:16','2018-09-26 10:56:16'),
	(592,1,'App\\Models\\Setting','p7fb866eda92742ab82e454f2d3893b4','2018-09-26 10:56:26','2018-09-26 10:56:26'),
	(593,35,'App\\Models\\UserSession','x7ad10be35b454721bbad3cdb3c2327c','2018-09-26 10:56:42','2018-09-26 10:56:42'),
	(594,2,'App\\Models\\Setting','g1431d419ba0c478184512dd33ebc8f0','2018-09-26 10:56:59','2018-09-26 10:56:59'),
	(595,36,'App\\Models\\UserSession','g7a4ebb68d99348218f87c6c8d295320','2018-09-26 10:58:16','2018-09-26 10:58:16'),
	(596,31,'App\\Models\\Like','bebaebbb75739479e88092e7e1e364ef','2018-09-26 10:58:32','2018-09-26 10:58:32'),
	(597,145,'App\\Models\\Analytic','u7b682a78b9f84410b89e20e966ce23f','2018-09-26 10:58:48','2018-09-26 10:58:48'),
	(598,222,'App\\Models\\ActivityLog','f69b65f4e34984754a5de3a8a9c3a988','2018-09-26 10:58:48','2018-09-26 10:58:48'),
	(599,146,'App\\Models\\Analytic','c668ab015066f47cd8c516bf00804e7e','2018-09-26 10:58:51','2018-09-26 10:58:51'),
	(600,223,'App\\Models\\ActivityLog','l18dabadf105e4b4e81b0ac56a327baa','2018-09-26 10:58:51','2018-09-26 10:58:51'),
	(601,147,'App\\Models\\Analytic','d8b1538b7f3bf4faf8f53056901bc243','2018-09-26 10:58:53','2018-09-26 10:58:53'),
	(602,224,'App\\Models\\ActivityLog','ef119c1673da04b109c103162157069d','2018-09-26 10:58:53','2018-09-26 10:58:53'),
	(603,32,'App\\Models\\Like','r408199180eec4ab28cccb48991ca702','2018-09-26 10:59:06','2018-09-26 10:59:06'),
	(604,148,'App\\Models\\Analytic','icab8a54f1cc345bd946f680c59c1dee','2018-09-26 10:59:41','2018-09-26 10:59:41'),
	(605,225,'App\\Models\\ActivityLog','o0475668fec414e2eb10c4b21987fe35','2018-09-26 10:59:41','2018-09-26 10:59:41'),
	(606,149,'App\\Models\\Analytic','ze031960c203e4f598e84d0bc1a19fec','2018-09-26 10:59:44','2018-09-26 10:59:44'),
	(607,226,'App\\Models\\ActivityLog','a56217cb7538b4d3db24a908f0de2903','2018-09-26 10:59:44','2018-09-26 10:59:44'),
	(608,227,'App\\Models\\ActivityLog','s6d960bd8486e4c288eb70734141d9a8','2018-09-26 10:59:55','2018-09-26 10:59:55'),
	(609,37,'App\\Models\\UserSession','t46b1fc2470b54cdbaf26cb3eea940a7','2018-09-26 11:04:34','2018-09-26 11:04:34'),
	(610,38,'App\\Models\\UserSession','zfa8139c2a50d4144b6e52f5c6848760','2018-09-26 11:04:42','2018-09-26 11:04:42'),
	(611,150,'App\\Models\\Analytic','o6e72c0085004453a8aa7f780bc36cf3','2018-09-26 11:05:56','2018-09-26 11:05:56'),
	(612,228,'App\\Models\\ActivityLog','w67a60cfdb0804d9a820af3ecb3ce1bb','2018-09-26 11:05:56','2018-09-26 11:05:56'),
	(613,39,'App\\Models\\UserSession','r8d1d022423a3430dae291a4020c7059','2018-09-26 11:12:39','2018-09-26 11:12:39'),
	(614,40,'App\\Models\\UserSession','hc0ac8db0a0c54270a3f2424403b05b8','2018-09-26 11:20:34','2018-09-26 11:20:34'),
	(615,41,'App\\Models\\UserSession','f62997c5339b34b72a0db61784656005','2018-09-26 11:26:07','2018-09-26 11:26:07'),
	(616,42,'App\\Models\\UserSession','h6f74cf6fed7c4bc1a9913d7e8dd950f','2018-09-26 11:26:07','2018-09-26 11:26:07'),
	(617,43,'App\\Models\\UserSession','v9f6cbbd70d524f1e9725c29e588a5e2','2018-09-26 11:37:01','2018-09-26 11:37:01'),
	(618,44,'App\\Models\\UserSession','w8888833695334b208d2a89ffa6b4a17','2018-09-26 11:37:01','2018-09-26 11:37:01'),
	(619,45,'App\\Models\\UserSession','kacc505075f6341cf908f47c0548e11d','2018-09-26 11:39:49','2018-09-26 11:39:49'),
	(620,46,'App\\Models\\UserSession','w4dc447eba8884f6092eebb0dd2ffe01','2018-09-26 11:39:49','2018-09-26 11:39:49'),
	(621,47,'App\\Models\\UserSession','k9290fee173364f42bd44ce972a6294a','2018-09-26 11:41:45','2018-09-26 11:41:45'),
	(622,48,'App\\Models\\UserSession','r0ca244b178354268a321e7a8766842f','2018-09-26 11:41:46','2018-09-26 11:41:46'),
	(623,49,'App\\Models\\UserSession','k4a6b481a8ae94290b1e2b03da3605bb','2018-09-26 11:44:25','2018-09-26 11:44:25'),
	(624,50,'App\\Models\\UserSession','f5232a5bb624e4d6c837c421cdc63985','2018-09-26 11:44:26','2018-09-26 11:44:26'),
	(625,51,'App\\Models\\UserSession','j3c915ac3e4a64ff888709de66c20b6e','2018-09-26 11:46:38','2018-09-26 11:46:38'),
	(626,52,'App\\Models\\UserSession','b7ece7143706541c6bcfc6050f1cb99d','2018-09-26 11:46:39','2018-09-26 11:46:39'),
	(627,53,'App\\Models\\UserSession','r2e71e5e784d34ae3aff9f9aa9e3b4b6','2018-09-26 11:48:20','2018-09-26 11:48:20'),
	(628,54,'App\\Models\\UserSession','a253477dfa12b4e47aced8ce29c072b6','2018-09-26 11:48:20','2018-09-26 11:48:20'),
	(629,55,'App\\Models\\UserSession','bfb641f7b3b564b9598cdaa81fdff139','2018-09-26 11:49:48','2018-09-26 11:49:48'),
	(630,56,'App\\Models\\UserSession','z2949d41ad9db4dcebee0a1306a94aba','2018-09-26 11:49:48','2018-09-26 11:49:48'),
	(631,57,'App\\Models\\UserSession','dee32bc3f65ad42c084b5bdec3c66c91','2018-09-26 11:51:40','2018-09-26 11:51:40'),
	(632,58,'App\\Models\\UserSession','i290c77ec9ba64af6bb00080aa8acea0','2018-09-26 11:51:40','2018-09-26 11:51:40'),
	(633,59,'App\\Models\\UserSession','y73b6989a57964ce2b5a546e94bf26e9','2018-09-26 11:52:39','2018-09-26 11:52:39'),
	(634,60,'App\\Models\\UserSession','if205fe4a8abd48d48313e1e63ca9ab7','2018-09-26 11:52:40','2018-09-26 11:52:40'),
	(635,61,'App\\Models\\UserSession','y753715ccca9045a9be7a909d4e31aba','2018-09-26 11:54:20','2018-09-26 11:54:20'),
	(636,62,'App\\Models\\UserSession','i365be6c1326e48ca82655948e2a3e9d','2018-09-26 11:54:20','2018-09-26 11:54:20'),
	(637,63,'App\\Models\\UserSession','nb1bec482b97b4ec18296aa80759cbf4','2018-09-26 11:57:06','2018-09-26 11:57:06'),
	(638,64,'App\\Models\\UserSession','ea7ac73da35e94d5c8f365fd6a5fb0aa','2018-09-26 11:57:06','2018-09-26 11:57:06'),
	(639,65,'App\\Models\\UserSession','q5c3390857ab4418495b3671c443158d','2018-09-26 11:58:39','2018-09-26 11:58:39'),
	(640,66,'App\\Models\\UserSession','o54af2bb0e0fe4385b5ebd86dad83ab5','2018-09-26 11:58:40','2018-09-26 11:58:40'),
	(641,67,'App\\Models\\UserSession','yf70ae094f2fd4ba99fe94454856ac3a','2018-09-26 12:00:56','2018-09-26 12:00:56'),
	(642,68,'App\\Models\\UserSession','lb6a7fc0ad564446ea9eacd77416469d','2018-09-26 12:00:56','2018-09-26 12:00:56'),
	(643,69,'App\\Models\\UserSession','bf286e234c8474e458adcb56c35ee934','2018-09-26 12:01:57','2018-09-26 12:01:57'),
	(644,70,'App\\Models\\UserSession','t7025efca948343799c5776a72c90668','2018-09-26 12:01:57','2018-09-26 12:01:57'),
	(645,71,'App\\Models\\UserSession','ned9b489b3d1a42eaad146dc46714979','2018-09-26 12:03:14','2018-09-26 12:03:14'),
	(646,72,'App\\Models\\UserSession','jf6752d0060e049469041edea959894a','2018-09-26 12:03:15','2018-09-26 12:03:15'),
	(647,73,'App\\Models\\UserSession','i27ee2e40db924d079adedef3f018dba','2018-09-26 12:05:08','2018-09-26 12:05:08'),
	(648,74,'App\\Models\\UserSession','s3b903e520f654eeaa4386d98b8db366','2018-09-26 12:05:08','2018-09-26 12:05:08'),
	(649,75,'App\\Models\\UserSession','f8c67f431b83147889c7670892b94711','2018-09-26 12:06:30','2018-09-26 12:06:30'),
	(650,76,'App\\Models\\UserSession','x5da1470a38874fe2ad54dfc202465b7','2018-09-26 12:06:30','2018-09-26 12:06:30'),
	(651,77,'App\\Models\\UserSession','e82fb15af85914beabf976072b687c1d','2018-09-26 12:07:24','2018-09-26 12:07:24'),
	(652,78,'App\\Models\\UserSession','jf8490f78eae94c3fa96ae9e4c65ff73','2018-09-26 12:07:25','2018-09-26 12:07:25'),
	(653,79,'App\\Models\\UserSession','id2484678e7654283a3519bb4f20cdf6','2018-09-26 12:10:29','2018-09-26 12:10:29'),
	(654,80,'App\\Models\\UserSession','k5a3280c8e5b14fa7a3ab306b6c00f71','2018-09-26 12:10:29','2018-09-26 12:10:29'),
	(655,81,'App\\Models\\UserSession','kbc85f90f601a42aab59027d03fc0b3b','2018-09-26 12:19:39','2018-09-26 12:19:39'),
	(656,82,'App\\Models\\UserSession','l0c97e23756c14c62adff59c903ff23e','2018-09-26 12:20:57','2018-09-26 12:20:57'),
	(657,83,'App\\Models\\UserSession','o48d04e24c6204df19d37fd9168989b7','2018-09-26 12:20:58','2018-09-26 12:20:58'),
	(658,84,'App\\Models\\UserSession','jee38d9935584421188dcf4d0771f84c','2018-09-26 12:23:12','2018-09-26 12:23:12'),
	(659,85,'App\\Models\\UserSession','y88d3fe5f8cfe4f659487ad3f6287990','2018-09-26 12:23:13','2018-09-26 12:23:13'),
	(660,86,'App\\Models\\UserSession','p8005acb556934a708d3b8797489ee44','2018-09-26 12:25:08','2018-09-26 12:25:08'),
	(661,87,'App\\Models\\UserSession','pcc2c45e8fe1f448ab2e8f1497856363','2018-09-26 12:25:08','2018-09-26 12:25:08'),
	(662,88,'App\\Models\\UserSession','nd45e488c106d471ebf2ac6f29f79ef4','2018-09-26 12:28:41','2018-09-26 12:28:41'),
	(663,89,'App\\Models\\UserSession','t9b95ddbc149a48efbf8d5e58c80229a','2018-09-26 12:28:41','2018-09-26 12:28:41'),
	(664,90,'App\\Models\\UserSession','yffbbbccaf39c4a96b754186a63cda6a','2018-09-26 12:30:00','2018-09-26 12:30:00'),
	(665,151,'App\\Models\\Analytic','k06ec6260d0a046919f5e56a95288eff','2018-09-26 12:31:15','2018-09-26 12:31:15'),
	(666,229,'App\\Models\\ActivityLog','t71aeb4e3a70645eaa2c0074a56371f9','2018-09-26 12:31:15','2018-09-26 12:31:15'),
	(667,152,'App\\Models\\Analytic','j3c2b64d890fa4f049818e700340f658','2018-09-26 12:31:18','2018-09-26 12:31:18'),
	(668,230,'App\\Models\\ActivityLog','lfa54a4781b1146a697626d6108ef96c','2018-09-26 12:31:18','2018-09-26 12:31:18'),
	(669,153,'App\\Models\\Analytic','gae025c7af3db49f2a1c1e1ecfa60cc4','2018-09-26 12:31:26','2018-09-26 12:31:26'),
	(670,231,'App\\Models\\ActivityLog','vcbb30189c04c4e8bad61978cefdf9d6','2018-09-26 12:31:26','2018-09-26 12:31:26'),
	(671,154,'App\\Models\\Analytic','o7f1d2c99f5694ca8a7e50cdefa57081','2018-09-26 12:31:27','2018-09-26 12:31:27'),
	(672,155,'App\\Models\\Analytic','v68e6a95a66ba4c0d914878c5952f2b8','2018-09-26 12:31:32','2018-09-26 12:31:32'),
	(673,232,'App\\Models\\ActivityLog','o103a71544943493693896f6dbff71e0','2018-09-26 12:31:32','2018-09-26 12:31:32'),
	(674,156,'App\\Models\\Analytic','v6bb2b288b93246e39fa85be6b636508','2018-09-26 12:31:44','2018-09-26 12:31:44'),
	(675,233,'App\\Models\\ActivityLog','f9ada6d8bb0514ea99faab097500b23d','2018-09-26 12:31:44','2018-09-26 12:31:44'),
	(676,157,'App\\Models\\Analytic','a9e508291265e4648bcd2387dfe7fb20','2018-09-26 12:31:45','2018-09-26 12:31:45'),
	(677,158,'App\\Models\\Analytic','b0b9359a7c2d4453f8f4fc1a172d13af','2018-09-26 12:31:48','2018-09-26 12:31:48'),
	(678,234,'App\\Models\\ActivityLog','wede7bd7823f340a79ae2e360bcfbffc','2018-09-26 12:31:48','2018-09-26 12:31:48'),
	(679,159,'App\\Models\\Analytic','vd19edd29db084d21bea613a3ca6fe17','2018-09-26 12:31:52','2018-09-26 12:31:52'),
	(680,235,'App\\Models\\ActivityLog','vbe34ccfddf144d0ead44cec644fd6cb','2018-09-26 12:31:53','2018-09-26 12:31:53'),
	(681,160,'App\\Models\\Analytic','d6b85b46eff424ab6a246289384e9b86','2018-09-26 12:31:53','2018-09-26 12:31:53'),
	(682,161,'App\\Models\\Analytic','fd8606ba8772048888ef29bea481280d','2018-09-26 12:31:59','2018-09-26 12:31:59'),
	(683,236,'App\\Models\\ActivityLog','ucdcf99f615c44fca98c455b5c6c1665','2018-09-26 12:31:59','2018-09-26 12:31:59'),
	(684,162,'App\\Models\\Analytic','i15484d4692c647459e6473fd30cb9e3','2018-09-26 12:32:00','2018-09-26 12:32:00'),
	(685,163,'App\\Models\\Analytic','r02390e266a1f4626b82b00685f2ea1e','2018-09-26 12:32:00','2018-09-26 12:32:00'),
	(686,237,'App\\Models\\ActivityLog','x40055c902fd54f06a5a703676ac4bb9','2018-09-26 12:32:00','2018-09-26 12:32:00'),
	(687,164,'App\\Models\\Analytic','c272c541f6c294b8c9b935c3b8cbf24a','2018-09-26 12:32:03','2018-09-26 12:32:03'),
	(688,238,'App\\Models\\ActivityLog','s78e14818be14448fa69fced61c27a89','2018-09-26 12:32:03','2018-09-26 12:32:03'),
	(689,165,'App\\Models\\Analytic','he16f5b957b6041de8e6a65384d81704','2018-09-26 12:32:04','2018-09-26 12:32:04'),
	(690,166,'App\\Models\\Analytic','od901bc24f14a42aba67fda538898f68','2018-09-26 12:32:04','2018-09-26 12:32:04'),
	(691,239,'App\\Models\\ActivityLog','z5041410bd8184b7f993897c09e56d82','2018-09-26 12:32:04','2018-09-26 12:32:04'),
	(692,167,'App\\Models\\Analytic','s0a83d9b99b6d45e481ad64b5f35b481','2018-09-26 12:32:06','2018-09-26 12:32:06'),
	(693,240,'App\\Models\\ActivityLog','za3a64c7f7dc645ff89ee1e7ae7e4ded','2018-09-26 12:32:06','2018-09-26 12:32:06'),
	(694,168,'App\\Models\\Analytic','kfc20a5417c4f4ddd9f3f5a7616aa171','2018-09-26 12:32:08','2018-09-26 12:32:08'),
	(695,241,'App\\Models\\ActivityLog','s470ba1039fe0435e8bf16b60a843e63','2018-09-26 12:32:08','2018-09-26 12:32:08'),
	(696,169,'App\\Models\\Analytic','qfe7b585bcbde435389e4d467764c7bd','2018-09-26 12:32:09','2018-09-26 12:32:09'),
	(697,170,'App\\Models\\Analytic','w8865d737c93d445eb066c5036b492ca','2018-09-26 12:32:19','2018-09-26 12:32:19'),
	(698,242,'App\\Models\\ActivityLog','o0c9be297763d45a6953d1775f2fa5de','2018-09-26 12:32:19','2018-09-26 12:32:19'),
	(699,171,'App\\Models\\Analytic','k18269bb296bb48d3bbdfed9901da8c3','2018-09-26 12:32:53','2018-09-26 12:32:53'),
	(700,172,'App\\Models\\Analytic','a66b2de30e6b5497dba4e735409c65b5','2018-09-26 12:32:53','2018-09-26 12:32:53'),
	(701,243,'App\\Models\\ActivityLog','u5135275a6ce345c1a13815d60552eff','2018-09-26 12:32:54','2018-09-26 12:32:54'),
	(702,173,'App\\Models\\Analytic','j5f9b9c332181499ea54d2f2153a9388','2018-09-26 12:32:56','2018-09-26 12:32:56'),
	(703,244,'App\\Models\\ActivityLog','b7922ecfd8a2e48cb99b9848263725cd','2018-09-26 12:32:56','2018-09-26 12:32:56'),
	(704,174,'App\\Models\\Analytic','k43566a046df54558b979d3a21d5c804','2018-09-26 12:32:58','2018-09-26 12:32:58'),
	(705,175,'App\\Models\\Analytic','ie3be45f575114f949884f3760d76e0a','2018-09-26 12:32:58','2018-09-26 12:32:58'),
	(706,245,'App\\Models\\ActivityLog','ca61a0b6e00e14ef1863ded8cdacc143','2018-09-26 12:32:59','2018-09-26 12:32:59'),
	(707,176,'App\\Models\\Analytic','v2ee76ac9255c42aa9c61803f244d6f0','2018-09-26 12:33:01','2018-09-26 12:33:01'),
	(708,246,'App\\Models\\ActivityLog','z339aaf82b43f472a8b7b9e6e48268ef','2018-09-26 12:33:01','2018-09-26 12:33:01'),
	(709,177,'App\\Models\\Analytic','ba66fad2659c445dc83a699fa3aba909','2018-09-26 12:33:03','2018-09-26 12:33:03'),
	(710,178,'App\\Models\\Analytic','kb85f0c06b07a415a8ec3157ac7b5e58','2018-09-26 12:33:03','2018-09-26 12:33:03'),
	(711,247,'App\\Models\\ActivityLog','w622ce686f8e24b23912d0d38c61cdc4','2018-09-26 12:33:03','2018-09-26 12:33:03'),
	(712,179,'App\\Models\\Analytic','w41ec5ace8f9549ee9ab623efd5d126b','2018-09-26 12:33:27','2018-09-26 12:33:27'),
	(713,248,'App\\Models\\ActivityLog','yb8d0e891c1df47cba14e6881ea56ab2','2018-09-26 12:33:27','2018-09-26 12:33:27'),
	(714,249,'App\\Models\\ActivityLog','y39a47cf98fee4892b23e6b5b57a264c','2018-09-26 12:33:29','2018-09-26 12:33:29'),
	(715,250,'App\\Models\\ActivityLog','ub17358484e1e47d4967fd6c2759cf40','2018-09-26 12:33:31','2018-09-26 12:33:31'),
	(716,180,'App\\Models\\Analytic','p6ab4642532d94a4aa39d1d419117bf9','2018-09-26 12:33:35','2018-09-26 12:33:35'),
	(717,251,'App\\Models\\ActivityLog','t520b0d59858d45c0a5d66ccb9420419','2018-09-26 12:33:35','2018-09-26 12:33:35'),
	(718,181,'App\\Models\\Analytic','x410f5fc0ff5d4a1683dfd82d604b2ea','2018-09-26 12:33:40','2018-09-26 12:33:40'),
	(719,252,'App\\Models\\ActivityLog','jfc1f0dac2fd84b82a6dc1558b1ca276','2018-09-26 12:33:40','2018-09-26 12:33:40'),
	(720,182,'App\\Models\\Analytic','vc86042c731444e56b293630547ebf69','2018-09-26 12:33:41','2018-09-26 12:33:41'),
	(721,253,'App\\Models\\ActivityLog','z205ddee479a64e6c9296bd54401cacd','2018-09-26 12:33:41','2018-09-26 12:33:41'),
	(722,183,'App\\Models\\Analytic','hba2487d3b337425ba279ef687bec9ca','2018-09-26 12:33:42','2018-09-26 12:33:42'),
	(723,184,'App\\Models\\Analytic','v29d4c470fe3b41b6a3f8247228bcc2b','2018-09-26 12:33:42','2018-09-26 12:33:42'),
	(724,254,'App\\Models\\ActivityLog','a7ecc946a2e5048cf8bd8b68afb39375','2018-09-26 12:33:42','2018-09-26 12:33:42'),
	(725,185,'App\\Models\\Analytic','ha9ecf128dd78481795f26ad56fdf62d','2018-09-26 12:33:48','2018-09-26 12:33:48'),
	(726,255,'App\\Models\\ActivityLog','af6e92866b1984bcc99ce7616803510c','2018-09-26 12:33:48','2018-09-26 12:33:48'),
	(727,186,'App\\Models\\Analytic','c44865775460740a3a3ad1c8aaaa8672','2018-09-26 12:34:02','2018-09-26 12:34:02'),
	(728,256,'App\\Models\\ActivityLog','ua8ae78d86fb74cbb993251640065d3b','2018-09-26 12:34:02','2018-09-26 12:34:02'),
	(729,187,'App\\Models\\Analytic','p9d36189cfea64abbb1565b8ea217f31','2018-09-26 12:34:03','2018-09-26 12:34:03'),
	(730,257,'App\\Models\\ActivityLog','iad56bca3591943ec96359f9397dfff6','2018-09-26 12:34:25','2018-09-26 12:34:25'),
	(731,258,'App\\Models\\ActivityLog','j0e6c0b81bd7a4fcd8f76bada80c4054','2018-09-26 12:34:28','2018-09-26 12:34:28'),
	(732,188,'App\\Models\\Analytic','eb5988e96abaa47dd8bdc8e201f7f493','2018-09-26 12:34:30','2018-09-26 12:34:30'),
	(733,259,'App\\Models\\ActivityLog','f3b50af2dd5a54ebba6dcc28fa8c96bb','2018-09-26 12:34:30','2018-09-26 12:34:30'),
	(734,1,'App\\Models\\Assessment','o15e7d4535b8146ac90a7b1ed6d33b18','2018-09-26 12:34:58','2018-09-26 12:34:58'),
	(735,1,'App\\Models\\AssessmentQuestion','jcf15cee17720464d9bed0f21bec0855','2018-09-26 12:34:59','2018-09-26 12:34:59'),
	(736,260,'App\\Models\\ActivityLog','v1e888406abea4fc2ac7414ef5b13109','2018-09-26 12:34:59','2018-09-26 12:34:59'),
	(737,2,'App\\Models\\AssessmentQuestion','l8adc1c73e05446639ac701a9f0759cb','2018-09-26 12:34:59','2018-09-26 12:34:59'),
	(738,261,'App\\Models\\ActivityLog','p92a04242ec2a4f57be075a9d787ba85','2018-09-26 12:34:59','2018-09-26 12:34:59'),
	(739,189,'App\\Models\\Analytic','mdbb6f0474e3744ecb71371be903aec4','2018-09-26 12:34:59','2018-09-26 12:34:59'),
	(740,262,'App\\Models\\ActivityLog','b23ece1b63c1740958431cd95bf8bb7e','2018-09-26 12:34:59','2018-09-26 12:34:59'),
	(741,190,'App\\Models\\Analytic','occ52792915c547e082c3dcaec3eb5a2','2018-09-26 12:35:00','2018-09-26 12:35:00'),
	(742,263,'App\\Models\\ActivityLog','xa61f721136de48c49cc637b9c503e16','2018-09-26 12:35:04','2018-09-26 12:35:04'),
	(743,1,'App\\Models\\AssessmentAnswer','l194867ea15ba47ac99648d28086a95e','2018-09-26 12:35:05','2018-09-26 12:35:05'),
	(744,264,'App\\Models\\ActivityLog','hba0eeae6f50b422db07caff5aab2a2b','2018-09-26 12:35:05','2018-09-26 12:35:05'),
	(745,265,'App\\Models\\ActivityLog','n5ee97054d2024cc1b30f3700704bb0e','2018-09-26 12:35:08','2018-09-26 12:35:08'),
	(746,266,'App\\Models\\ActivityLog','s8c2214f553bb4ba1ba7048070ce38fa','2018-09-26 12:35:09','2018-09-26 12:35:09'),
	(747,2,'App\\Models\\AssessmentAnswer','l1e4e00b7ac404976bd2f2c92787fd87','2018-09-26 12:35:09','2018-09-26 12:35:09'),
	(748,267,'App\\Models\\ActivityLog','k6c3da7b9f3e142989a0fa8d71119660','2018-09-26 12:35:09','2018-09-26 12:35:09'),
	(749,191,'App\\Models\\Analytic','c45c047fc16424e9994ee2f6f75db6d9','2018-09-26 12:35:17','2018-09-26 12:35:17'),
	(750,268,'App\\Models\\ActivityLog','l586f9408bb484845bbef8e745c1fc4c','2018-09-26 12:35:17','2018-09-26 12:35:17'),
	(751,269,'App\\Models\\ActivityLog','obd1b7bd7ccd34ec69a640c1c6a64dbc','2018-09-26 12:35:38','2018-09-26 12:35:38'),
	(752,270,'App\\Models\\ActivityLog','s42d1698c303441b6885d9954d87647a','2018-09-26 12:35:38','2018-09-26 12:35:38'),
	(753,91,'App\\Models\\UserSession','cd187983700ae46f7bf7bfe5248e90d2','2018-09-26 12:35:53','2018-09-26 12:35:53'),
	(754,192,'App\\Models\\Analytic','ka91ac6e297ff4f019b9a9bd16e6b56a','2018-09-26 12:35:57','2018-09-26 12:35:57'),
	(755,271,'App\\Models\\ActivityLog','oa8c2e3d0066743629edd76038e0120c','2018-09-26 12:35:57','2018-09-26 12:35:57'),
	(756,193,'App\\Models\\Analytic','m34bd28ce429044abb518cd3bfffa4f0','2018-09-26 12:36:18','2018-09-26 12:36:18'),
	(757,272,'App\\Models\\ActivityLog','h05bb7b2a52344879ae61800ae2fc6ef','2018-09-26 12:36:18','2018-09-26 12:36:18'),
	(758,194,'App\\Models\\Analytic','sfff7918a7f73498fa68191d224589be','2018-09-26 12:36:19','2018-09-26 12:36:19'),
	(759,1,'App\\Models\\AssessmentSubmission','c2be94e00f7ba4d1b983c890498999c5','2018-09-26 12:36:20','2018-09-26 12:36:20'),
	(760,273,'App\\Models\\ActivityLog','gfe85886c5678409e8c80759720741f4','2018-09-26 12:36:20','2018-09-26 12:36:20'),
	(761,1,'App\\Models\\AssessmentResponse','x1dd38a211aef4d1f9a2e19ecc9fe03a','2018-09-26 12:36:22','2018-09-26 12:36:22'),
	(762,274,'App\\Models\\ActivityLog','i9ebbfdedbe2c4be0a48ec982082eb33','2018-09-26 12:36:22','2018-09-26 12:36:22'),
	(763,6,'App\\Models\\Grade','ff3e118205b06457f9a8a3b9ce5bca4f','2018-09-26 12:36:22','2018-09-26 12:36:22'),
	(764,275,'App\\Models\\ActivityLog','h2e9d0dc7d30f4ec285f9334f45b6184','2018-09-26 12:36:22','2018-09-26 12:36:22'),
	(765,7,'App\\Models\\Grade','z173bdab11e484eb584360abd65e326f','2018-09-26 12:36:22','2018-09-26 12:36:22'),
	(766,276,'App\\Models\\ActivityLog','c13917d16355b44d9a20803360b91842','2018-09-26 12:36:22','2018-09-26 12:36:22'),
	(767,195,'App\\Models\\Analytic','s0d9e6b56acd244348f19855480d8c42','2018-09-26 12:36:28','2018-09-26 12:36:28'),
	(768,277,'App\\Models\\ActivityLog','md924e6d8637e4d0fb32e3c65c7457e1','2018-09-26 12:36:28','2018-09-26 12:36:28'),
	(769,92,'App\\Models\\UserSession','q5c8215e968cf4398b6454577cefb852','2018-09-26 12:36:49','2018-09-26 12:36:49'),
	(770,93,'App\\Models\\UserSession','d821f73f16e544e74a8e4efb25f98390','2018-09-26 12:36:49','2018-09-26 12:36:49'),
	(771,94,'App\\Models\\UserSession','m6dc869a50b7b445587c87aa0a4d4ca4','2018-09-26 12:39:14','2018-09-26 12:39:14'),
	(772,95,'App\\Models\\UserSession','hdcf5d5a76131493380e3aceed64666e','2018-09-26 12:39:15','2018-09-26 12:39:15'),
	(773,96,'App\\Models\\UserSession','l3d9993473976476899df3fb1f4b92bc','2018-09-26 12:41:08','2018-09-26 12:41:08'),
	(774,97,'App\\Models\\UserSession','i3652ad371b984cde9495b9e4b253e52','2018-09-26 12:41:08','2018-09-26 12:41:08'),
	(775,98,'App\\Models\\UserSession','p21d07235866e40208b4cedd6efb99c5','2018-09-26 12:43:32','2018-09-26 12:43:32'),
	(776,99,'App\\Models\\UserSession','ra8edb36280234111aa13b65d788d65d','2018-09-26 12:43:32','2018-09-26 12:43:32'),
	(777,100,'App\\Models\\UserSession','ae4bdafb8c1e84152a4884242b0ee066','2018-09-26 12:45:06','2018-09-26 12:45:06'),
	(778,101,'App\\Models\\UserSession','s70559fa456c54999964181effe28764','2018-09-26 12:45:07','2018-09-26 12:45:07'),
	(779,102,'App\\Models\\UserSession','eb72928a277274cfeb6dfcb3e4c2eddb','2018-09-26 12:48:09','2018-09-26 12:48:09'),
	(780,103,'App\\Models\\UserSession','b05dcf47f1eaf451a87da2c9aa95621d','2018-09-26 12:48:09','2018-09-26 12:48:09'),
	(781,104,'App\\Models\\UserSession','c57a5ba8c3ab24d689df0410e23a486d','2018-09-26 12:50:25','2018-09-26 12:50:25'),
	(782,105,'App\\Models\\UserSession','rc5664468bb6140e3bb317d61bcd631f','2018-09-26 12:50:26','2018-09-26 12:50:26'),
	(783,106,'App\\Models\\UserSession','bfe726cde4f0449519da282e3742ec92','2018-09-26 14:23:55','2018-09-26 14:23:55'),
	(784,196,'App\\Models\\Analytic','k619910e03dda4f00b8c73618e4280a9','2018-09-26 14:24:32','2018-09-26 14:24:32'),
	(785,278,'App\\Models\\ActivityLog','kadc1ccba1f7d425c8eef1f6828f7b68','2018-09-26 14:24:33','2018-09-26 14:24:33'),
	(786,197,'App\\Models\\Analytic','a36e5dccc20a846c480dce580e0cf7a3','2018-09-26 14:24:40','2018-09-26 14:24:40'),
	(787,279,'App\\Models\\ActivityLog','qfa9700de1eff4e5bafc538be8593c5c','2018-09-26 14:24:40','2018-09-26 14:24:40'),
	(788,198,'App\\Models\\Analytic','x4c97bda9faf6498f9c1ca81d213eaf3','2018-09-26 14:24:52','2018-09-26 14:24:52'),
	(789,280,'App\\Models\\ActivityLog','nda44977789874e72adefe37306cb85c','2018-09-26 14:24:52','2018-09-26 14:24:52'),
	(790,199,'App\\Models\\Analytic','p8c76c76358494479ae395cae81ab1c9','2018-09-26 14:25:08','2018-09-26 14:25:08'),
	(791,281,'App\\Models\\ActivityLog','aa1ed0ddb73064d6594b99a3ecadb32f','2018-09-26 14:25:08','2018-09-26 14:25:08'),
	(792,200,'App\\Models\\Analytic','nc24d7a10ace44ba98372195df960916','2018-09-26 14:25:11','2018-09-26 14:25:11'),
	(793,282,'App\\Models\\ActivityLog','i8fcc20b516b5497ab9842ae6eaecd9d','2018-09-26 14:25:11','2018-09-26 14:25:11'),
	(794,107,'App\\Models\\UserSession','l06268083923149ca8b00cb2f8e3b51f','2018-09-26 14:27:34','2018-09-26 14:27:34'),
	(795,201,'App\\Models\\Analytic','m0a5b0b2c9719473daf0d14f7e860c27','2018-09-26 14:27:39','2018-09-26 14:27:39'),
	(796,283,'App\\Models\\ActivityLog','p474ae7ab0ca842119484281de1da9b2','2018-09-26 14:27:39','2018-09-26 14:27:39'),
	(797,202,'App\\Models\\Analytic','t760066550c5044d8845f81eab6171cf','2018-09-26 14:27:44','2018-09-26 14:27:44'),
	(798,284,'App\\Models\\ActivityLog','ra9bb33f46e194624b3f407d91b85e32','2018-09-26 14:27:44','2018-09-26 14:27:44'),
	(799,285,'App\\Models\\ActivityLog','nf711169e7f734867a3f6726f2336f8a','2018-09-26 14:27:54','2018-09-26 14:27:54'),
	(800,203,'App\\Models\\Analytic','d1e1c2ca8773b4aba800f17c4dd56063','2018-09-26 14:28:09','2018-09-26 14:28:09'),
	(801,286,'App\\Models\\ActivityLog','gab7918ae65a34fa6a8cf9a956ec14a3','2018-09-26 14:28:09','2018-09-26 14:28:09'),
	(802,204,'App\\Models\\Analytic','l205193c8b3374afaacca1e16d7152c2','2018-09-26 14:28:11','2018-09-26 14:28:11'),
	(803,287,'App\\Models\\ActivityLog','qfa54117f45024e2bb85b25d1d4d1c4b','2018-09-26 14:28:11','2018-09-26 14:28:11'),
	(804,205,'App\\Models\\Analytic','re1f0088a39ec458c92f8566ad78fa66','2018-09-26 14:28:21','2018-09-26 14:28:21'),
	(805,288,'App\\Models\\ActivityLog','rbf7ec740be384ed088a93e57cd6df18','2018-09-26 14:28:21','2018-09-26 14:28:21'),
	(806,206,'App\\Models\\Analytic','zba6d949f255745f0b7d86313b6f6299','2018-09-26 14:28:48','2018-09-26 14:28:48'),
	(807,289,'App\\Models\\ActivityLog','ca8474c85cc4041a5b7662032749e6b1','2018-09-26 14:28:48','2018-09-26 14:28:48'),
	(808,207,'App\\Models\\Analytic','y83d1dfc2623a4fbf9656217d0185c87','2018-09-26 14:28:48','2018-09-26 14:28:48'),
	(809,208,'App\\Models\\Analytic','zee07b7c7d1e04d0486837fb9a19f2d8','2018-09-26 14:28:51','2018-09-26 14:28:51'),
	(810,290,'App\\Models\\ActivityLog','cc74750af8f634bc3ac33c7f821781fd','2018-09-26 14:28:51','2018-09-26 14:28:51'),
	(811,209,'App\\Models\\Analytic','qa1d6bb1101ee48c5aa14302ed8142fd','2018-09-26 14:29:09','2018-09-26 14:29:09'),
	(812,291,'App\\Models\\ActivityLog','t3ad960154d1d44a2ac43fb2e71285ef','2018-09-26 14:29:09','2018-09-26 14:29:09'),
	(813,108,'App\\Models\\UserSession','ub5d651e98a56424898b4befa9b26ddc','2018-09-26 14:29:23','2018-09-26 14:29:23'),
	(814,210,'App\\Models\\Analytic','u099c54f68643436c9be713970cc5a46','2018-09-26 14:29:27','2018-09-26 14:29:27'),
	(815,292,'App\\Models\\ActivityLog','m86da02de30b44830934e19eb71836af','2018-09-26 14:29:27','2018-09-26 14:29:27'),
	(816,109,'App\\Models\\UserSession','v70345a6341be48f6b96a949aa66e26b','2018-09-26 14:30:45','2018-09-26 14:30:45'),
	(817,110,'App\\Models\\UserSession','eb8f31f95de084536a97f3ea47d00f0e','2018-09-26 14:30:46','2018-09-26 14:30:46'),
	(818,111,'App\\Models\\UserSession','d213343a319e94424a504f14978f1324','2018-09-26 14:52:10','2018-09-26 14:52:10'),
	(819,112,'App\\Models\\UserSession','x40507c4ec27a4a7c86858e4088d5971','2018-09-26 14:52:10','2018-09-26 14:52:10'),
	(820,113,'App\\Models\\UserSession','o6aefd940620a4a07a0b42e7d71cfaee','2018-09-26 15:28:04','2018-09-26 15:28:04'),
	(821,114,'App\\Models\\UserSession','l9842e402156e46cb983d563bb248cef','2018-09-26 15:28:04','2018-09-26 15:28:04'),
	(822,115,'App\\Models\\UserSession','xb8e38b3502a74297bd6ff0bc9e94e16','2018-09-26 15:36:32','2018-09-26 15:36:32'),
	(823,116,'App\\Models\\UserSession','q5d18a6ce7cde4fc79e1bd7df5923fe9','2018-09-26 15:36:33','2018-09-26 15:36:33'),
	(824,117,'App\\Models\\UserSession','of6ef563f4fb64064a5cfa27c075268f','2018-09-26 16:23:46','2018-09-26 16:23:46'),
	(825,118,'App\\Models\\UserSession','vbd9c4ae1eb8244c08be829919512948','2018-09-26 16:27:46','2018-09-26 16:27:46'),
	(826,119,'App\\Models\\UserSession','t895fcc6ab9b8496f859b688c85260d1','2018-09-26 16:27:47','2018-09-26 16:27:47'),
	(827,120,'App\\Models\\UserSession','wda4462814fc0475aa4d5420f41f1a08','2018-09-26 16:53:54','2018-09-26 16:53:54'),
	(828,121,'App\\Models\\UserSession','ua089fc9869b44cc2ad0dd6c12c393cc','2018-09-26 16:53:54','2018-09-26 16:53:54'),
	(829,122,'App\\Models\\UserSession','bbebce738c7064ef594bee635ea9b81d','2018-09-26 17:07:44','2018-09-26 17:07:44'),
	(830,123,'App\\Models\\UserSession','q0bb13869a10f4d7b80843845c5453c6','2018-09-26 17:07:45','2018-09-26 17:07:45'),
	(831,124,'App\\Models\\UserSession','y83fdd7e8c8094df889b1252810f5164','2018-09-26 17:14:43','2018-09-26 17:14:43'),
	(832,125,'App\\Models\\UserSession','a06a7a5b5925d4d37bb9c908e877f330','2018-09-26 17:14:43','2018-09-26 17:14:43'),
	(833,126,'App\\Models\\UserSession','kf3b7d7381ec54992bf3dced921b2260','2018-09-26 17:18:31','2018-09-26 17:18:31'),
	(834,127,'App\\Models\\UserSession','uda553e4c587e4c6890c6393449053d2','2018-09-26 17:18:32','2018-09-26 17:18:32'),
	(835,128,'App\\Models\\UserSession','j9e91e038c20449a392ca875e87dbda9','2018-09-26 17:20:40','2018-09-26 17:20:40'),
	(836,129,'App\\Models\\UserSession','qd619f52ca3af4bd29584509d2bcc733','2018-09-26 17:20:40','2018-09-26 17:20:40'),
	(837,130,'App\\Models\\UserSession','na1151d7f68594ae49807dfb082e31cb','2018-09-26 17:21:50','2018-09-26 17:21:50'),
	(838,131,'App\\Models\\UserSession','o516fe6df3d504e04b3b98261f8fbc16','2018-09-26 17:21:51','2018-09-26 17:21:51'),
	(839,132,'App\\Models\\UserSession','dfb39a9d723954e93a7af09b6b05f611','2018-09-26 17:29:35','2018-09-26 17:29:35'),
	(840,133,'App\\Models\\UserSession','wb9613ccba6e64197957fd6540b02fc0','2018-09-26 17:29:44','2018-09-26 17:29:44'),
	(841,134,'App\\Models\\UserSession','a872e9f7e45d047b09ff07f022421154','2018-09-26 17:30:32','2018-09-26 17:30:32'),
	(842,135,'App\\Models\\UserSession','t4fc901b34ff4458c940a730fafa44ea','2018-09-26 17:30:43','2018-09-26 17:30:43'),
	(843,293,'App\\Models\\ActivityLog','b2fcfa2096f09468f85f716a77644996','2018-09-26 17:31:14','2018-09-26 17:31:14'),
	(844,294,'App\\Models\\ActivityLog','zcc3d92296c954e5d82d4dc6011e7b11','2018-09-26 17:32:45','2018-09-26 17:32:45'),
	(845,136,'App\\Models\\UserSession','r17a30c80d6cf44ff8aa90343d2ec7fb','2018-09-26 17:54:23','2018-09-26 17:54:23'),
	(846,137,'App\\Models\\UserSession','gd54d45ae259f4dc9a3b483f464dcd2d','2018-09-26 17:54:23','2018-09-26 17:54:23'),
	(847,138,'App\\Models\\UserSession','h3cdea3e7151448c890647dc27d8c105','2018-09-26 17:57:33','2018-09-26 17:57:33'),
	(848,139,'App\\Models\\UserSession','r5a6ad0c7c9ec491c859b8296e1591b3','2018-09-26 17:57:33','2018-09-26 17:57:33'),
	(849,140,'App\\Models\\UserSession','fc155de8779044a60938292ebec457ac','2018-09-26 17:57:51','2018-09-26 17:57:51'),
	(850,141,'App\\Models\\UserSession','kf4007ea2a5e944a6b277760dc122450','2018-09-26 17:57:51','2018-09-26 17:57:51'),
	(851,142,'App\\Models\\UserSession','y4b6619c7108a49bdbbe429e90f1de6d','2018-09-26 17:58:07','2018-09-26 17:58:07'),
	(852,143,'App\\Models\\UserSession','g6fc1eb52036a4ba599b018c6127fef5','2018-09-26 17:58:07','2018-09-26 17:58:07'),
	(853,144,'App\\Models\\UserSession','q047b5bd11df74b7c8bfd7510cf41ba1','2018-09-26 17:58:24','2018-09-26 17:58:24'),
	(854,145,'App\\Models\\UserSession','i0f7273379da04580902ad4bf00442f0','2018-09-26 17:58:25','2018-09-26 17:58:25'),
	(855,146,'App\\Models\\UserSession','w38bd5448c1dc4c9786c3a15238df7a4','2018-09-26 17:58:41','2018-09-26 17:58:41'),
	(856,147,'App\\Models\\UserSession','y09bee073e77e4ffd9d0c32bcd68a9f7','2018-09-26 17:58:41','2018-09-26 17:58:41'),
	(857,148,'App\\Models\\UserSession','lc50edf22176544b39157dd99b01902f','2018-09-26 17:58:56','2018-09-26 17:58:56'),
	(858,149,'App\\Models\\UserSession','y43fa5cc929f9417d9e2e56429e8e434','2018-09-26 17:58:56','2018-09-26 17:58:56'),
	(859,150,'App\\Models\\UserSession','o771373649ea941e6ac46f33ea868b95','2018-09-26 17:59:44','2018-09-26 17:59:44'),
	(860,151,'App\\Models\\UserSession','o51f3c22fd346408eaaae1210e8a6358','2018-09-26 17:59:45','2018-09-26 17:59:45'),
	(861,152,'App\\Models\\UserSession','z711e50b5fecb41478ebd9e38301b3cb','2018-09-26 18:00:01','2018-09-26 18:00:01'),
	(862,153,'App\\Models\\UserSession','g2f055a9d6f8f4ff880827f5c1088f01','2018-09-26 18:00:01','2018-09-26 18:00:01'),
	(863,154,'App\\Models\\UserSession','l72b26d585e1c4077a6fea9bfb541576','2018-09-26 18:00:18','2018-09-26 18:00:18'),
	(864,155,'App\\Models\\UserSession','q24fc221125e6403da0c02d1fb68db7b','2018-09-26 18:00:18','2018-09-26 18:00:18'),
	(865,156,'App\\Models\\UserSession','q5af78111f1df491c93668a18a7d6950','2018-09-26 18:00:34','2018-09-26 18:00:34'),
	(866,157,'App\\Models\\UserSession','k0c7226c953584bb48883ba45e8f64ca','2018-09-26 18:00:34','2018-09-26 18:00:34'),
	(867,158,'App\\Models\\UserSession','g5843b8be14a546c0b06ac1f479aeab1','2018-09-26 18:00:50','2018-09-26 18:00:50'),
	(868,159,'App\\Models\\UserSession','m7aaa709b7ced416eb0d1f1745e666bb','2018-09-26 18:00:51','2018-09-26 18:00:51'),
	(869,160,'App\\Models\\UserSession','b45c3bcb367104509a60156df14dcd8d','2018-09-26 18:01:06','2018-09-26 18:01:06'),
	(870,161,'App\\Models\\UserSession','qa78348597a8545e3a8215db9486ce91','2018-09-26 18:01:07','2018-09-26 18:01:07'),
	(871,162,'App\\Models\\UserSession','f14a3176db3874b6d80ef76994186fe6','2018-09-26 18:01:54','2018-09-26 18:01:54'),
	(872,163,'App\\Models\\UserSession','j746fdbf5d29749dd8dfaad1d9b1d80a','2018-09-26 18:01:54','2018-09-26 18:01:54'),
	(873,164,'App\\Models\\UserSession','e777da82b9c1546058d4c5ef95956f75','2018-09-26 18:02:11','2018-09-26 18:02:11'),
	(874,165,'App\\Models\\UserSession','s477f0ad0f10742cdb8dd8d27dfde470','2018-09-26 18:02:11','2018-09-26 18:02:11'),
	(875,166,'App\\Models\\UserSession','h8e3578f0c56a4f5aab7e1c0256cd68a','2018-09-26 18:02:27','2018-09-26 18:02:27'),
	(876,167,'App\\Models\\UserSession','mec98b68de15944758565c69ee27646c','2018-09-26 18:02:27','2018-09-26 18:02:27'),
	(877,168,'App\\Models\\UserSession','t74175d40150d4e30aa5aa059e20aea4','2018-09-26 18:02:43','2018-09-26 18:02:43'),
	(878,169,'App\\Models\\UserSession','ff5f01dfbca9f42ab8767af824ca14fa','2018-09-26 18:02:44','2018-09-26 18:02:44'),
	(879,170,'App\\Models\\UserSession','ta8634e41cee24c4aa510c71f7f2e181','2018-09-26 18:03:00','2018-09-26 18:03:00'),
	(880,171,'App\\Models\\UserSession','j34093b54e4894c7fb6ec880e1dc6fb2','2018-09-26 18:03:00','2018-09-26 18:03:00'),
	(881,172,'App\\Models\\UserSession','l387deb2797ed45b4920ef65593b9e4f','2018-09-26 18:03:16','2018-09-26 18:03:16'),
	(882,173,'App\\Models\\UserSession','a21d5be74ba564742a9b393dcc98b53f','2018-09-26 18:03:17','2018-09-26 18:03:17'),
	(883,174,'App\\Models\\UserSession','mb520cd94f8804c7eb5e04ca0b9ee13d','2018-09-26 18:04:07','2018-09-26 18:04:07'),
	(884,175,'App\\Models\\UserSession','g4e081588efce49c8af8c2f5ac30eafa','2018-09-26 18:04:07','2018-09-26 18:04:07'),
	(885,176,'App\\Models\\UserSession','hf81e100b8d874751811ad8d73bb3a3e','2018-09-26 18:04:24','2018-09-26 18:04:24'),
	(886,177,'App\\Models\\UserSession','v0c0d73ec99e443918028b9ce5c7f360','2018-09-26 18:04:24','2018-09-26 18:04:24'),
	(887,178,'App\\Models\\UserSession','ybb8aa97e04c94a9aa936282f43ef9f5','2018-09-26 18:04:40','2018-09-26 18:04:40'),
	(888,179,'App\\Models\\UserSession','k28c27c7d0abf4223a5bb999dc9b0071','2018-09-26 18:04:40','2018-09-26 18:04:40'),
	(889,180,'App\\Models\\UserSession','r675eec3481e843d98916e8ef160d3b3','2018-09-26 18:07:53','2018-09-26 18:07:53'),
	(890,181,'App\\Models\\UserSession','od627f13e1e004fdc8b2617c5223ff36','2018-09-26 18:07:54','2018-09-26 18:07:54'),
	(891,182,'App\\Models\\UserSession','l5f0e702e65c14be9a1f368e90d9d168','2018-09-26 18:08:27','2018-09-26 18:08:27'),
	(892,183,'App\\Models\\UserSession','v4b65deccd3a94d92a4ebd79e8425c25','2018-09-26 18:08:28','2018-09-26 18:08:28'),
	(893,184,'App\\Models\\UserSession','q2af9a9cd1aa7436785d344a77bd1ddd','2018-09-26 18:08:43','2018-09-26 18:08:43'),
	(894,185,'App\\Models\\UserSession','s42dff2ffd2e642dbac48d718e17391a','2018-09-26 18:09:44','2018-09-26 18:09:44'),
	(895,186,'App\\Models\\UserSession','va129a157496449cf9af0e938ac23e3b','2018-09-26 18:09:44','2018-09-26 18:09:44'),
	(896,187,'App\\Models\\UserSession','m19a5a05f153e4d148a6d2a744774545','2018-09-26 18:41:55','2018-09-26 18:41:55'),
	(897,188,'App\\Models\\UserSession','af5aadb63402e4f188a794e44638ce8d','2018-09-26 18:41:55','2018-09-26 18:41:55'),
	(898,189,'App\\Models\\UserSession','if8e4488ca169466ebc9e48209133f19','2018-09-26 18:42:18','2018-09-26 18:42:18'),
	(899,190,'App\\Models\\UserSession','tec8a7c3a33e34da6a392f65693ec3e3','2018-09-26 18:42:18','2018-09-26 18:42:18'),
	(900,191,'App\\Models\\UserSession','ld896f64a87354c4c98abeb9851564e7','2018-09-26 18:42:34','2018-09-26 18:42:34'),
	(901,192,'App\\Models\\UserSession','vb9c8c44f60ca42309192886f8cc52bb','2018-09-26 18:42:34','2018-09-26 18:42:34'),
	(902,193,'App\\Models\\UserSession','v7bfd53df246d44b8b2698c21d9346fd','2018-09-26 18:42:51','2018-09-26 18:42:51'),
	(903,194,'App\\Models\\UserSession','gb67fed6679a24015a111ba095a9a61f','2018-09-26 18:42:51','2018-09-26 18:42:51'),
	(904,195,'App\\Models\\UserSession','b30cef48130284fd98d1ed49c4efa791','2018-09-26 18:43:06','2018-09-26 18:43:06'),
	(905,196,'App\\Models\\UserSession','ac25849011f1d4cb6bc773b32cbb325d','2018-09-26 18:43:06','2018-09-26 18:43:06'),
	(906,197,'App\\Models\\UserSession','wce7c59c9e998495b9e01e73689a8077','2018-09-26 18:43:23','2018-09-26 18:43:23'),
	(907,198,'App\\Models\\UserSession','r987203d7c542474188cc70d2e1b1ea3','2018-09-26 18:43:24','2018-09-26 18:43:24'),
	(908,199,'App\\Models\\UserSession','a227456f371934ba59bc187c1f8b5b86','2018-09-26 19:46:38','2018-09-26 19:46:38'),
	(909,200,'App\\Models\\UserSession','ha100a78b621d426284dff9d38d6225f','2018-09-26 19:48:52','2018-09-26 19:48:52'),
	(910,33,'App\\Models\\Like','zf823070d830a4faf884e947f3f681df','2018-09-26 19:49:08','2018-09-26 19:49:08'),
	(911,1,'App\\Models\\Notification','z017c38cd04a84fdd9097b1dbe667bff','2018-09-26 19:49:10','2018-09-26 19:49:10'),
	(912,211,'App\\Models\\Analytic','y2c1982f8898342bca32aaf90568cda1','2018-09-26 19:49:18','2018-09-26 19:49:18'),
	(913,295,'App\\Models\\ActivityLog','y2b6fab07a5984bda9e84e9e0522bcb3','2018-09-26 19:49:18','2018-09-26 19:49:18'),
	(914,212,'App\\Models\\Analytic','b7bd5a1725fc445a7a9b9794c955c055','2018-09-26 19:50:33','2018-09-26 19:50:33'),
	(915,296,'App\\Models\\ActivityLog','o82f17d4d643144d2b737c4ac165a6b0','2018-09-26 19:50:33','2018-09-26 19:50:33'),
	(916,213,'App\\Models\\Analytic','g9392453ec59a4c8cadf42af87141401','2018-09-26 19:50:37','2018-09-26 19:50:37'),
	(917,297,'App\\Models\\ActivityLog','s02d5732bd3f04ef2aafe960ddd2fa8a','2018-09-26 19:50:37','2018-09-26 19:50:37'),
	(918,214,'App\\Models\\Analytic','uca0b246956ac4300b80871dfc760295','2018-09-26 19:50:39','2018-09-26 19:50:39'),
	(919,298,'App\\Models\\ActivityLog','j2c913f918f244392b16e0a198208f88','2018-09-26 19:50:39','2018-09-26 19:50:39'),
	(920,215,'App\\Models\\Analytic','x856ca97484d04235a9d36dc3971dbf0','2018-09-26 19:50:41','2018-09-26 19:50:41'),
	(921,299,'App\\Models\\ActivityLog','q5be022f439c44781a9477e9c236ce82','2018-09-26 19:50:41','2018-09-26 19:50:41'),
	(922,300,'App\\Models\\ActivityLog','n402a0c384b0b4fb9ab2b4225ab33a56','2018-09-26 19:50:49','2018-09-26 19:50:49'),
	(923,2,'App\\Models\\Notification','k07344dc4a5d441bfb5e95c3abe4c592','2018-09-26 19:50:50','2018-09-26 19:50:50'),
	(924,301,'App\\Models\\ActivityLog','hb7f5292e44d54197ae197e39f567d50','2018-09-26 19:50:57','2018-09-26 19:50:57'),
	(925,3,'App\\Models\\Notification','ed2dcaf3bdd1348e3a8a8dd50a8a1d68','2018-09-26 19:50:59','2018-09-26 19:50:59'),
	(926,216,'App\\Models\\Analytic','k6f4ebbfe2f804f15b4c3337e93f2481','2018-09-26 19:51:01','2018-09-26 19:51:01'),
	(927,302,'App\\Models\\ActivityLog','t2c99957fda204a5d8d90caabf7563e7','2018-09-26 19:51:01','2018-09-26 19:51:01'),
	(928,217,'App\\Models\\Analytic','hd6a3ccafefc042dd9eac1f496196653','2018-09-26 19:51:16','2018-09-26 19:51:16'),
	(929,303,'App\\Models\\ActivityLog','oabf8a8f2eab44ac2a6f319201b5b728','2018-09-26 19:51:16','2018-09-26 19:51:16'),
	(930,218,'App\\Models\\Analytic','f813697be896c4622a42e5330bbc2643','2018-09-26 19:51:16','2018-09-26 19:51:16'),
	(931,304,'App\\Models\\ActivityLog','o36538e0be0844355bf2525236505f62','2018-09-26 19:51:27','2018-09-26 19:51:27'),
	(932,4,'App\\Models\\Notification','h57dac006f51140e7ac4b57b2568cb77','2018-09-26 19:51:30','2018-09-26 19:51:30'),
	(933,219,'App\\Models\\Analytic','e5411fa94bd214df585880e352e32522','2018-09-26 19:51:33','2018-09-26 19:51:33'),
	(934,305,'App\\Models\\ActivityLog','wb328766cec88484aa0aa914627f1d64','2018-09-26 19:51:33','2018-09-26 19:51:33'),
	(935,220,'App\\Models\\Analytic','aff316f8e6e8a40b9ac87021bb7305a8','2018-09-26 19:51:36','2018-09-26 19:51:36'),
	(936,306,'App\\Models\\ActivityLog','nde30bc34d4484a3b86b9c0292cd4c3e','2018-09-26 19:51:36','2018-09-26 19:51:36'),
	(937,221,'App\\Models\\Analytic','j8462bc17c01e492ea16acafc484887c','2018-09-26 19:51:38','2018-09-26 19:51:38'),
	(938,307,'App\\Models\\ActivityLog','g6537e990c6c94cf8a41198994a593b3','2018-09-26 19:51:38','2018-09-26 19:51:38'),
	(939,8,'App\\Models\\Assignment','oc845a1e5fc944b82ac6bdc91d7b7155','2018-09-26 19:53:21','2018-09-26 19:53:21'),
	(940,308,'App\\Models\\ActivityLog','z84fcb5eb8b8c46feac46644a02b0e12','2018-09-26 19:53:21','2018-09-26 19:53:21'),
	(941,222,'App\\Models\\Analytic','p60cfdfe0745b4983ab783d18b2461e9','2018-09-26 19:53:22','2018-09-26 19:53:22'),
	(942,309,'App\\Models\\ActivityLog','x0b8f00a53650499e8a4a2f069f38ad9','2018-09-26 19:53:22','2018-09-26 19:53:22'),
	(943,5,'App\\Models\\Notification','rd2a805567e8045efa1349de50e24c95','2018-09-26 19:53:22','2018-09-26 19:53:22'),
	(944,223,'App\\Models\\Analytic','b279d84d183b54d72ab4d113648198b1','2018-09-26 19:53:23','2018-09-26 19:53:23'),
	(945,224,'App\\Models\\Analytic','y70523de0b81840a6b45c0450bbfc41a','2018-09-26 19:53:26','2018-09-26 19:53:26'),
	(946,310,'App\\Models\\ActivityLog','ia8b49d02dff94164ac48d5341a9ff84','2018-09-26 19:53:26','2018-09-26 19:53:26'),
	(947,225,'App\\Models\\Analytic','sccf871beb4a9489b954507493fa23b8','2018-09-26 19:53:43','2018-09-26 19:53:43'),
	(948,311,'App\\Models\\ActivityLog','zfd35cfc6f96a4bc0b55b09c0ede1bcd','2018-09-26 19:53:43','2018-09-26 19:53:43'),
	(949,9,'App\\Models\\Assignment','h2c18ba321e834175838d08ef18f5573','2018-09-26 19:54:02','2018-09-26 19:54:02'),
	(950,312,'App\\Models\\ActivityLog','i079b5a41665c4d2bb131bc704798178','2018-09-26 19:54:02','2018-09-26 19:54:02'),
	(951,226,'App\\Models\\Analytic','g53895ac74d164f7b930545e6a2e5a62','2018-09-26 19:54:03','2018-09-26 19:54:03'),
	(952,313,'App\\Models\\ActivityLog','xad6e215fafdf4475adc27e2624549ed','2018-09-26 19:54:03','2018-09-26 19:54:03'),
	(953,227,'App\\Models\\Analytic','pa854de10f3cf48a987359e05e908edf','2018-09-26 19:54:04','2018-09-26 19:54:04'),
	(954,6,'App\\Models\\Notification','ne494d6d305a4413db0e66ee93df8466','2018-09-26 19:54:05','2018-09-26 19:54:05'),
	(955,228,'App\\Models\\Analytic','vb5af7a2d09fd4d7ca59d24513d4e5c2','2018-09-26 19:54:08','2018-09-26 19:54:08'),
	(956,314,'App\\Models\\ActivityLog','y13703feabb1e4feab177d9433a3b15c','2018-09-26 19:54:08','2018-09-26 19:54:08'),
	(957,229,'App\\Models\\Analytic','w1d2736d48d2f4035bcc7760f61cf698','2018-09-26 19:54:09','2018-09-26 19:54:09'),
	(958,315,'App\\Models\\ActivityLog','p89abae44edf34c258369096f47c636a','2018-09-26 19:54:09','2018-09-26 19:54:09'),
	(959,12,'App\\Models\\Comment','v01b4ab8266dd46e39558b1728a37c33','2018-09-26 19:54:31','2018-09-26 19:54:31'),
	(960,316,'App\\Models\\ActivityLog','l77798f4f621446589e666a27558a284','2018-09-26 19:54:31','2018-09-26 19:54:31'),
	(961,7,'App\\Models\\Notification','xd3acd7d6addf43a690552f08a1a329b','2018-09-26 19:54:32','2018-09-26 19:54:32'),
	(962,201,'App\\Models\\UserSession','tf459526262ea47798bde6b58a65021a','2018-09-26 19:55:07','2018-09-26 19:55:07'),
	(963,202,'App\\Models\\UserSession','iffb59860d8e34a1ba82bf241c0e5414','2018-09-26 19:59:54','2018-09-26 19:59:54'),
	(964,203,'App\\Models\\UserSession','c083c88752d3144cdb16caa7292a14e0','2018-09-26 19:59:55','2018-09-26 19:59:55'),
	(965,204,'App\\Models\\UserSession','ra783ea0466ce4957b8622fbb22cb1e1','2018-09-26 20:02:48','2018-09-26 20:02:48'),
	(966,205,'App\\Models\\UserSession','jf43ba2f7be5c4121a31752ef5dad0bb','2018-09-26 20:08:15','2018-09-26 20:08:15'),
	(967,206,'App\\Models\\UserSession','z62be6687bf5746678f6ec39f0dbd9bc','2018-09-26 20:08:15','2018-09-26 20:08:15'),
	(968,207,'App\\Models\\UserSession','l4d35b7da35584058b510c2f71e038db','2018-09-26 20:10:48','2018-09-26 20:10:48'),
	(969,208,'App\\Models\\UserSession','yad9d6e9a67a34cd0a1380dd4004dac0','2018-09-26 20:10:48','2018-09-26 20:10:48'),
	(970,209,'App\\Models\\UserSession','pe8905e1b2a2f4234af9ef8d3be4b4f3','2018-09-26 20:16:37','2018-09-26 20:16:37'),
	(971,210,'App\\Models\\UserSession','nf64486b901ac496abda08fdfc9825ee','2018-09-26 20:21:31','2018-09-26 20:21:31'),
	(972,211,'App\\Models\\UserSession','f680845536a5646dfaf11951c6a404cb','2018-09-26 20:21:32','2018-09-26 20:21:32'),
	(973,212,'App\\Models\\UserSession','u7e2e7f9333214a9bbcaac7fa2a36fb6','2018-09-26 20:21:54','2018-09-26 20:21:54'),
	(974,213,'App\\Models\\UserSession','a511d1a88f725458d83feea43eca5581','2018-09-26 20:21:55','2018-09-26 20:21:55'),
	(975,214,'App\\Models\\UserSession','x5b9128b8ef8e4b2b8e61e0c9609405d','2018-09-26 20:22:10','2018-09-26 20:22:10'),
	(976,215,'App\\Models\\UserSession','sa367ea14afb542a5ac1f2037b7ec071','2018-09-26 20:22:10','2018-09-26 20:22:10'),
	(977,216,'App\\Models\\UserSession','v81f5d873fc8f435fb82721a6200dbe2','2018-09-26 20:22:26','2018-09-26 20:22:26'),
	(978,217,'App\\Models\\UserSession','vd3aee1eb0d0045628391db5a95759d5','2018-09-26 20:22:27','2018-09-26 20:22:27'),
	(979,218,'App\\Models\\UserSession','s2051a8eba8394b20a517b26a0f1b7b5','2018-09-26 20:22:41','2018-09-26 20:22:41'),
	(980,219,'App\\Models\\UserSession','h24c22d1d2d8543a4941f94f3402ac8e','2018-09-26 20:22:42','2018-09-26 20:22:42'),
	(981,220,'App\\Models\\UserSession','jdc822f3c91884221a9ea5e39e6632c0','2018-09-26 20:22:57','2018-09-26 20:22:57'),
	(982,221,'App\\Models\\UserSession','gf692616a651d4c38921f82b6b36933e','2018-09-26 20:22:58','2018-09-26 20:22:58'),
	(983,222,'App\\Models\\UserSession','x64069d98fd114508a4d774e0e4986f7','2018-09-26 20:26:03','2018-09-26 20:26:03'),
	(984,223,'App\\Models\\UserSession','z62a6262541d44313b634819206c3bf5','2018-09-26 20:26:03','2018-09-26 20:26:03'),
	(985,224,'App\\Models\\UserSession','aed0ca23b495f4bd3a6a1d01cc69fe94','2018-09-26 20:26:37','2018-09-26 20:26:37'),
	(986,225,'App\\Models\\UserSession','x45deb630e2984c3cb28ee8afe3369ba','2018-09-26 20:26:38','2018-09-26 20:26:38'),
	(987,226,'App\\Models\\UserSession','tb88d5302e1024e1d806697e2d3a2f7a','2018-09-26 20:26:54','2018-09-26 20:26:54'),
	(988,227,'App\\Models\\UserSession','j2643bbc76ca34028b07b82ab19ebf16','2018-09-26 20:26:54','2018-09-26 20:26:54'),
	(989,228,'App\\Models\\UserSession','wd728896a49ed4aa689cfccdbb504187','2018-09-26 20:27:11','2018-09-26 20:27:11'),
	(990,229,'App\\Models\\UserSession','x6b265e3f12974f3988d2d0d0a3ad99a','2018-09-26 20:27:11','2018-09-26 20:27:11'),
	(991,230,'App\\Models\\UserSession','jced068274c51464d93e1cd8089e112b','2018-09-26 20:27:26','2018-09-26 20:27:26'),
	(992,231,'App\\Models\\UserSession','fde6bf456326e4fb0ada39cdbb9a8dc1','2018-09-26 20:27:27','2018-09-26 20:27:27'),
	(993,232,'App\\Models\\UserSession','fb9d6166d8e9d4a80b72869e77668abc','2018-09-26 20:27:42','2018-09-26 20:27:42'),
	(994,233,'App\\Models\\UserSession','q4d648a7208324718a1757951a702937','2018-09-26 20:27:42','2018-09-26 20:27:42'),
	(995,234,'App\\Models\\UserSession','k94a3909a21d34e9b8dc846a69612e79','2018-09-26 20:28:17','2018-09-26 20:28:17'),
	(996,235,'App\\Models\\UserSession','za98834922413420eb97240a4012b4e5','2018-09-26 20:28:18','2018-09-26 20:28:18'),
	(997,236,'App\\Models\\UserSession','n54fb8e1c02f94318959691dd22523b2','2018-09-26 20:28:51','2018-09-26 20:28:51'),
	(998,237,'App\\Models\\UserSession','q697dfe446b5045219c12222d9ba4aa2','2018-09-26 20:28:51','2018-09-26 20:28:51'),
	(999,238,'App\\Models\\UserSession','l789f2233e7f44d28845babe8c49c88c','2018-09-26 20:29:08','2018-09-26 20:29:08'),
	(1000,239,'App\\Models\\UserSession','gf3036a5dc72748cdafb393d27e52fb4','2018-09-26 20:29:08','2018-09-26 20:29:08'),
	(1001,240,'App\\Models\\UserSession','h4e7a898a03f74fc4b8733d8d558fb2d','2018-09-26 20:29:25','2018-09-26 20:29:25'),
	(1002,241,'App\\Models\\UserSession','h7856cf2f00ac4a26b4ee02b05b6f2e1','2018-09-26 20:29:25','2018-09-26 20:29:25'),
	(1003,242,'App\\Models\\UserSession','b4312a6aa22d5447ebee14b6044dbd5c','2018-09-26 20:29:40','2018-09-26 20:29:40'),
	(1004,243,'App\\Models\\UserSession','e40de76fb1b654e87b334b49cd5614f2','2018-09-26 20:29:41','2018-09-26 20:29:41'),
	(1005,244,'App\\Models\\UserSession','zf1d869c2f9224333bbed861329e479b','2018-09-26 20:29:57','2018-09-26 20:29:57'),
	(1006,245,'App\\Models\\UserSession','ub93b1dd6db4e4d6cbf70f59e4815de3','2018-09-26 20:29:57','2018-09-26 20:29:57'),
	(1007,246,'App\\Models\\UserSession','ic0a64fc5cb094c9993cf3cf21e342c3','2018-09-26 20:30:30','2018-09-26 20:30:30'),
	(1008,247,'App\\Models\\UserSession','sd59b796c81914fa19cc88d065c844e1','2018-09-26 20:30:30','2018-09-26 20:30:30'),
	(1009,248,'App\\Models\\UserSession','ea1ec414b13f8463b8da75326d24fc6b','2018-09-26 20:36:11','2018-09-26 20:36:11'),
	(1010,249,'App\\Models\\UserSession','b3d85e007ed664addbbb385983fdbc30','2018-09-26 20:36:11','2018-09-26 20:36:11'),
	(1011,250,'App\\Models\\UserSession','sb35ad4565a8a499493c61f6ec3aaf81','2018-09-26 20:49:17','2018-09-26 20:49:17'),
	(1012,251,'App\\Models\\UserSession','b33658a7c40c046c58d6160def82e428','2018-09-26 20:49:18','2018-09-26 20:49:18'),
	(1013,252,'App\\Models\\UserSession','j4ed7481cc9154fc0914981d76113ca2','2018-09-26 20:49:52','2018-09-26 20:49:52'),
	(1014,253,'App\\Models\\UserSession','p9bdafe72d28f4cec9573db7acc5c346','2018-09-26 20:49:52','2018-09-26 20:49:52'),
	(1015,254,'App\\Models\\UserSession','t8f0e2abd8ada4edf91539708623aa28','2018-09-26 20:50:08','2018-09-26 20:50:08'),
	(1016,255,'App\\Models\\UserSession','ce8615d9a9a304b49b2b3d9623c60eec','2018-09-26 20:50:08','2018-09-26 20:50:08'),
	(1017,256,'App\\Models\\UserSession','l571b5c2b245e4f8dad24dcd3ef4a032','2018-09-26 20:50:26','2018-09-26 20:50:26'),
	(1018,257,'App\\Models\\UserSession','t2f5e67320ede480392a29ccce92d9b8','2018-09-26 20:50:26','2018-09-26 20:50:26'),
	(1019,258,'App\\Models\\UserSession','q0f9249bc433e49548e694d6cb353798','2018-09-26 20:50:42','2018-09-26 20:50:42'),
	(1020,259,'App\\Models\\UserSession','ccadd5016ead34cafa73e34abc91a411','2018-09-26 20:50:42','2018-09-26 20:50:42'),
	(1021,260,'App\\Models\\UserSession','ia9da979bafa34ae883767b552aa9417','2018-09-26 20:50:59','2018-09-26 20:50:59'),
	(1022,261,'App\\Models\\UserSession','y69347801f9334036b4278fa0859fa94','2018-09-26 20:50:59','2018-09-26 20:50:59'),
	(1023,262,'App\\Models\\UserSession','b4cfdab686563487ea675f5bde3d2e0f','2018-09-26 20:54:53','2018-09-26 20:54:53'),
	(1024,263,'App\\Models\\UserSession','j139b3c5bc45b4f8f8089d343bcf7986','2018-09-26 20:54:53','2018-09-26 20:54:53'),
	(1025,264,'App\\Models\\UserSession','p7a9bac71569140eb92aeafdb5ca23d9','2018-09-26 20:55:29','2018-09-26 20:55:29'),
	(1026,265,'App\\Models\\UserSession','of77b35148ec1491eafd9d2c622c2a6e','2018-09-26 20:55:29','2018-09-26 20:55:29'),
	(1027,266,'App\\Models\\UserSession','bbeed04a37ec44e8bb103300af2b7f39','2018-09-26 20:55:47','2018-09-26 20:55:47'),
	(1028,267,'App\\Models\\UserSession','jb78e0eccfbf84f69ad51fc6b9a19bb0','2018-09-26 20:55:48','2018-09-26 20:55:48'),
	(1029,268,'App\\Models\\UserSession','te32fa435850043e386be1adfbae5639','2018-09-26 20:56:05','2018-09-26 20:56:05'),
	(1030,269,'App\\Models\\UserSession','e15776d77034340d59692e6db2b805a2','2018-09-26 20:56:06','2018-09-26 20:56:06'),
	(1031,270,'App\\Models\\UserSession','z61229f328a3946438dc4ff034395247','2018-09-26 20:56:21','2018-09-26 20:56:21'),
	(1032,271,'App\\Models\\UserSession','v1e83e17a5cdb43508323d0211548569','2018-09-26 20:56:21','2018-09-26 20:56:21'),
	(1033,272,'App\\Models\\UserSession','p8af5565ebd23492dba96773f86b058e','2018-09-26 20:56:38','2018-09-26 20:56:38'),
	(1034,273,'App\\Models\\UserSession','nac7c4d6238a04475a3aff14af013372','2018-09-26 20:56:38','2018-09-26 20:56:38'),
	(1035,274,'App\\Models\\UserSession','i526fe04d8484445e92558174019105e','2018-09-26 21:04:43','2018-09-26 21:04:43'),
	(1036,275,'App\\Models\\UserSession','w8dbcd57790eb4c74a9d11d486456712','2018-09-26 21:04:44','2018-09-26 21:04:44'),
	(1037,276,'App\\Models\\UserSession','bffbf8e321bb54d539d8d0c25f313f7c','2018-09-26 21:05:03','2018-09-26 21:05:03'),
	(1038,277,'App\\Models\\UserSession','i329a0f4530be4048afb9e354047472e','2018-09-26 21:05:04','2018-09-26 21:05:04'),
	(1039,278,'App\\Models\\UserSession','i18bc525bfaa4444aac4874ee498490a','2018-09-26 21:05:19','2018-09-26 21:05:19'),
	(1040,279,'App\\Models\\UserSession','ncf9e9fc1c2334b508df0c559db5f252','2018-09-26 21:05:19','2018-09-26 21:05:19'),
	(1041,280,'App\\Models\\UserSession','c8676ef5ac0cc41009ed19ad457b8ff3','2018-09-26 21:05:36','2018-09-26 21:05:36'),
	(1042,281,'App\\Models\\UserSession','q778082c833864d66b9f1bd80b598322','2018-09-26 21:05:36','2018-09-26 21:05:36'),
	(1043,282,'App\\Models\\UserSession','q3a04b8a5b0b645d394788e710d37f61','2018-09-26 21:05:52','2018-09-26 21:05:52'),
	(1044,283,'App\\Models\\UserSession','p76d60a0c16954d3b8099e390d1a71bb','2018-09-26 21:05:52','2018-09-26 21:05:52'),
	(1045,284,'App\\Models\\UserSession','k81108b6fb40d4705a8efdce963d33a5','2018-09-26 21:06:09','2018-09-26 21:06:09'),
	(1046,285,'App\\Models\\UserSession','g35864a2fdcd749118f1d2859b2e0ff0','2018-09-26 21:06:09','2018-09-26 21:06:09'),
	(1047,286,'App\\Models\\UserSession','r4d37f05962d444da8e8b0786ca61f8a','2018-09-26 21:07:05','2018-09-26 21:07:05'),
	(1048,287,'App\\Models\\UserSession','p81b9e766f67b4efd897000943a1c6ad','2018-09-26 21:07:06','2018-09-26 21:07:06'),
	(1049,288,'App\\Models\\UserSession','nc0d0e1df698b432c8181627f5b4a6b8','2018-09-26 21:08:33','2018-09-26 21:08:33'),
	(1050,289,'App\\Models\\UserSession','g3833a47522874271b9bd5074c048d4f','2018-09-26 21:08:34','2018-09-26 21:08:34'),
	(1051,290,'App\\Models\\UserSession','y504db82a934e45f3907975529e20b15','2018-09-26 21:12:43','2018-09-26 21:12:43'),
	(1052,291,'App\\Models\\UserSession','k6545975185a34e40b3ed8ceb6f24b72','2018-09-26 21:13:11','2018-09-26 21:13:11'),
	(1053,292,'App\\Models\\UserSession','p274dcc891e87485e906ce8f2351ca9d','2018-09-26 21:13:12','2018-09-26 21:13:12'),
	(1054,293,'App\\Models\\UserSession','d082bd5fc9c4d4e6099d050d9815e57c','2018-09-26 21:13:51','2018-09-26 21:13:51'),
	(1055,230,'App\\Models\\Analytic','r4b75815067124aa7ad137e6bdb8479f','2018-09-26 21:14:00','2018-09-26 21:14:00'),
	(1056,317,'App\\Models\\ActivityLog','g1e0299d342884196bf47757cd715f39','2018-09-26 21:14:00','2018-09-26 21:14:00'),
	(1057,231,'App\\Models\\Analytic','v904cff4d62da40b7a3524c8085fcbfd','2018-09-26 21:14:02','2018-09-26 21:14:02'),
	(1058,318,'App\\Models\\ActivityLog','z868e6d0b3d944b379fbd2d0b34b7f4b','2018-09-26 21:14:02','2018-09-26 21:14:02'),
	(1059,10,'App\\Models\\Assignment','z51235fd8ecd340949043e24b101c449','2018-09-26 21:14:20','2018-09-26 21:14:20'),
	(1060,319,'App\\Models\\ActivityLog','pd5ff9ecfcbb641ea9b3605ad5bebe43','2018-09-26 21:14:20','2018-09-26 21:14:20'),
	(1061,232,'App\\Models\\Analytic','d940f613fd32b47b88e20c3aae2f3063','2018-09-26 21:14:21','2018-09-26 21:14:21'),
	(1062,320,'App\\Models\\ActivityLog','s3fcb5c13d6c8464f8e694224e313b6e','2018-09-26 21:14:21','2018-09-26 21:14:21'),
	(1063,233,'App\\Models\\Analytic','s70612041335f4c248b6cf7fb48cf827','2018-09-26 21:14:22','2018-09-26 21:14:22'),
	(1064,321,'App\\Models\\ActivityLog','k950d5443f8134753a85d5b15a6cad07','2018-09-26 21:14:25','2018-09-26 21:14:25'),
	(1065,234,'App\\Models\\Analytic','f342df7ab04cf4e0b80d2dcffa81c655','2018-09-26 21:14:27','2018-09-26 21:14:27'),
	(1066,322,'App\\Models\\ActivityLog','te715ae27094c43efa8d0b1c6915f8eb','2018-09-26 21:14:27','2018-09-26 21:14:27'),
	(1067,235,'App\\Models\\Analytic','t8ac43084ea2b4feb8e67f4c3e25aa71','2018-09-26 21:14:31','2018-09-26 21:14:31'),
	(1068,236,'App\\Models\\Analytic','s52938552897e4558b545008d90efd9e','2018-09-26 21:14:31','2018-09-26 21:14:31'),
	(1069,323,'App\\Models\\ActivityLog','tae7776c7d05a4d6e9b636a6d85d618c','2018-09-26 21:14:31','2018-09-26 21:14:31'),
	(1070,237,'App\\Models\\Analytic','t70f60bf1ee324323b15d5e476d1b00b','2018-09-26 21:14:38','2018-09-26 21:14:38'),
	(1071,324,'App\\Models\\ActivityLog','y1b18458d92cd453080e3ce8cb202818','2018-09-26 21:14:38','2018-09-26 21:14:38'),
	(1072,11,'App\\Models\\Assignment','iddef06c406e74b9ea41a067887638f8','2018-09-26 21:14:57','2018-09-26 21:14:57'),
	(1073,325,'App\\Models\\ActivityLog','i57985878628648f1a1c5a9e5d6c9e57','2018-09-26 21:14:57','2018-09-26 21:14:57'),
	(1074,238,'App\\Models\\Analytic','afdf24316143f46efa1e47b88173e56d','2018-09-26 21:14:57','2018-09-26 21:14:57'),
	(1075,326,'App\\Models\\ActivityLog','a55a9d13acc384d55be65c5dee79d80e','2018-09-26 21:14:57','2018-09-26 21:14:57'),
	(1076,239,'App\\Models\\Analytic','c7b60c0a870294b20888b53a4bbee4a1','2018-09-26 21:14:58','2018-09-26 21:14:58'),
	(1077,240,'App\\Models\\Analytic','v7af6af1a624146919d0d946676dfdcc','2018-09-26 21:15:00','2018-09-26 21:15:00'),
	(1078,327,'App\\Models\\ActivityLog','bf720e1c49994478e8a3c7e4673c0335','2018-09-26 21:15:00','2018-09-26 21:15:00'),
	(1079,294,'App\\Models\\UserSession','ub2d24423df294f6d88e657633d89916','2018-09-26 21:15:11','2018-09-26 21:15:11'),
	(1080,295,'App\\Models\\UserSession','y8dc7f4acede3447cacc6602eabacedc','2018-09-26 21:15:11','2018-09-26 21:15:11'),
	(1081,296,'App\\Models\\UserSession','nf00f3878c5a14e448c8fd6a68160aaf','2018-09-26 21:16:16','2018-09-26 21:16:16'),
	(1082,241,'App\\Models\\Analytic','a2ee206cea88f467ca95575ff512d1d8','2018-09-26 21:16:52','2018-09-26 21:16:52'),
	(1083,328,'App\\Models\\ActivityLog','za029fe900f7345b286d72d7ac296e3a','2018-09-26 21:16:52','2018-09-26 21:16:52'),
	(1084,242,'App\\Models\\Analytic','gbdcbe18751fc4c80b63195624aaa02a','2018-09-26 21:16:55','2018-09-26 21:16:55'),
	(1085,329,'App\\Models\\ActivityLog','qd296683c2a2a4fcf8f87d8b95e2bd03','2018-09-26 21:16:55','2018-09-26 21:16:55'),
	(1086,2,'App\\Models\\Assessment','r35c03c2c16b4420d89db80a448d720f','2018-09-26 21:17:14','2018-09-26 21:17:14'),
	(1087,3,'App\\Models\\AssessmentQuestion','abc3982a59b994cb58ccc7dc89c15511','2018-09-26 21:17:14','2018-09-26 21:17:14'),
	(1088,330,'App\\Models\\ActivityLog','ic7d8cad7b3bb4ebcb567160de3b404e','2018-09-26 21:17:14','2018-09-26 21:17:14'),
	(1089,4,'App\\Models\\AssessmentQuestion','me4869d78c32044a9a32eea49146a144','2018-09-26 21:17:14','2018-09-26 21:17:14'),
	(1090,331,'App\\Models\\ActivityLog','sc7fb708fae0249f2ad785e8da0e9839','2018-09-26 21:17:14','2018-09-26 21:17:14'),
	(1091,243,'App\\Models\\Analytic','gcc2867c1cc9747d0b4750024925b9b9','2018-09-26 21:17:15','2018-09-26 21:17:15'),
	(1092,332,'App\\Models\\ActivityLog','l0bac3a02e6ee4bf48d1e8f1c37f4928','2018-09-26 21:17:15','2018-09-26 21:17:15'),
	(1093,244,'App\\Models\\Analytic','rd641084c30e04a03a819636d826a908','2018-09-26 21:17:16','2018-09-26 21:17:16'),
	(1094,245,'App\\Models\\Analytic','tf88c62de6e184b278ed9a82ae4a8dcc','2018-09-26 21:17:20','2018-09-26 21:17:20'),
	(1095,333,'App\\Models\\ActivityLog','w2c8e91c8a2a14d0aa95cbf0667bc2ac','2018-09-26 21:17:20','2018-09-26 21:17:20'),
	(1096,297,'App\\Models\\UserSession','h009547b1b20443e48eb6b62ce37abb3','2018-09-26 21:17:31','2018-09-26 21:17:31'),
	(1097,298,'App\\Models\\UserSession','fb3846d9ead1147bc999ac83396b35ef','2018-09-26 21:17:31','2018-09-26 21:17:31');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `submissions` WRITE;
/*!40000 ALTER TABLE `submissions` DISABLE KEYS */;

INSERT INTO `submissions` (`id`, `owner_id`, `owner_type`, `creator_id`, `parent_id`, `created_at`, `updated_at`, `resource_key`, `deleted_at`, `text`)
VALUES
	(1,19,'App\\Models\\User',19,3,'2018-09-26 10:52:29.613400','2018-09-26 10:52:29.613400','tadcbd55243e04a2a95304d5f2aaad82',NULL,'fefe'),
	(2,1,'App\\Models\\AssignmentGroup',19,4,'2018-09-26 10:52:53.101600','2018-09-26 10:52:53.101600','re79098faf34d49adbef3cdcf53471af',NULL,'ewfewfew'),
	(3,19,'App\\Models\\User',19,7,'2018-09-26 10:53:20.367000','2018-09-26 10:53:20.367000','j995cdb2ae0f2435eb47c78a5409885a',NULL,'efwefe');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`id`, `university_id`, `email`, `phone_number`, `password`, `profile_picture`, `created_at`, `updated_at`, `resource_key`, `admin`, `mode`, `reset_token`, `deleted_at`, `tos_verify`, `timezone`, `first_name`, `last_name`, `event_create`, `group_create`, `post_create`, `api_token`, `stripe_id`, `card_brand`, `card_last_four`, `trial_ends_at`, `grad_year`, `grad_month`, `last_login_at`, `intercom`, `verified_email`, `zoom_api`)
VALUES
	(1,1,'admin@notebowl.com',NULL,'$2y$10$QJVvdy8scOkpjAWiTz.jbu2OTieU.IcMgmwej6d2hx9VFxFaFVwGK','https://notebowl.s3.amazonaws.com/users/U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi/profile-picture/EFZRd9vadqmvY11kSWCFgeCK1k09BBu1','2016-05-13 01:59:41.424897','2018-09-26 10:21:42.069700','U3MbUb3fkkfLAKn58Vh37LIzwzA9foqi',1,2,NULL,NULL,1,NULL,'Notebowl','User',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-09-26 10:21:42.069600',1,1,NULL),
	(2,1,'alexs@notebowl.com',NULL,'$2y$10$j4fOmjMjh.lvoPJzDZZpqeIOnDOAtaHx9Xma7KyeVmjmoQXQloVDG','https://notebowl.s3.amazonaws.com/users/JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4/profile-picture/PMjowlCwESuuBWYvuikErkWqsm85tTEn','2016-05-13 01:59:41.507325','2018-08-28 00:25:08.647900','JYEWEUEKv22ziPxyor0VSAB3b8LGR4x4',0,2,NULL,NULL,1,NULL,'Alex','Slaughter',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-08-28 00:25:08.647900',1,1,NULL),
	(3,1,'andrew.chaifetz@notebowl.com',NULL,'$2y$10$r131g6obNE3GeeTtIP6.FOmSbQUOTjZdRMwHLmwocvKjrWN0KIbs6','https://notebowl.s3.amazonaws.com/files/1537957516/n10b6eda601f34f34a31a6cbbe3779d62c3848cacde6d4ad199e850f04f37062/VoG9lUdXVPOmAJbBrKYpi3Pl7JDHLhPU9Tj2VQN0.jpeg.jpg','2016-05-13 01:59:41.583603','2018-09-26 21:17:31.019900','d2LVKz3W096yJCj2a88Ekf7MQTWD9OpZ',0,2,NULL,NULL,1,NULL,'Andrew','Chaifetz',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-09-26 21:17:31.019900',1,1,NULL),
	(4,1,'alexc@notebowl.com',NULL,'$2y$10$Mpn2yVOf52QUpVBit/R8Rus28ZwDdhWFPhYuKDT4.9HvNyf45RUdO','https://notebowl.s3.amazonaws.com/users/mZBS7dLUiNdBEfDVjUh6krB54jlRaCPt/profile-picture/qvXxuSg7ESUmgJDWxRJDyiKfpFOsv1um','2016-05-13 01:59:41.668478','2016-11-10 20:20:28.692100','mZBS7dLUiNdBEfDVjUh6krB54jlRaCPt',0,2,NULL,NULL,1,NULL,'Alex','Coomans',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(5,1,'matt.silverstone@notebowl.com',NULL,'$2y$10$4FyJx3S8IcCMBQoXiFkXZ.t3aVar2omHJJ7yB2kss6nl4rIBOZdN6',NULL,'2016-05-13 01:59:41.751167','2016-11-10 20:20:28.692100','BipyPUZK2b1otMJOkVh21CUlA3GvO9Oh',0,2,NULL,NULL,1,NULL,'Matt','Sliverstone',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(6,1,'scott.birgel@notebowl.com',NULL,'$2y$10$NtmoZLU3RVviRH.JmsYZHur5zM4LO9vMrI8q0/jtDIanYs1.lCRWG',NULL,'2016-05-13 01:59:41.831772','2016-11-10 20:20:28.692100','q5ja2Qw5IP8RETJq43vGGahB9L91oXjn',0,2,NULL,NULL,1,NULL,'Scott','Birgel',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(7,1,'alec.stapp@notebowl.com',NULL,'$2y$10$/GeZXoCspxUT4vE9lvgvhOjnQ.KALN4.RVRmhvGcvWdd4ayffvjX6',NULL,'2016-05-13 01:59:41.907205','2016-11-10 20:20:28.692100','SKXNr8e8eOSTgelgcL4W4HHizteF9zmc',0,2,NULL,NULL,1,NULL,'Alec','Stapp',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(8,1,'bob.smith@notebowl.com',NULL,'$2y$10$vaoNAqN1CFST.73KTXx4VuIYkxVb4H5F4qs/hl9aZH9XCkrxBG1vG','https://notebowl.s3.amazonaws.com/users/EYVoid6eBnSNUcyhN6J67EybnjOQNRhW/profile-picture/jspAVoL4NVR1KVBMaOGHHqQH3PVCmwqz','2016-05-13 01:59:41.980726','2016-11-10 20:20:28.692100','EYVoid6eBnSNUcyhN6J67EybnjOQNRhW',0,2,NULL,NULL,1,NULL,'Bob','Smith',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(9,1,'issac.ortega@notebowl.com',NULL,'$2y$10$4a9EQBYDGCye6VjPtfPsd.KXISe7bgoUedCn67OwUnBOvwvJT5lny',NULL,'2016-05-13 01:59:42.053595','2016-11-10 20:20:28.692100','eSpvwhe9b3dsBkHZz1Xxgx0TE9cYaF9Q',0,2,NULL,NULL,1,NULL,'Issac','Ortega',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(10,1,'aaron.ogata@notebowl.com',NULL,'$2y$10$O4xopCZRhlgDAj6P62DY5emyHEihO7pJNXkDX.4GPQeKMkKItjEVS','https://notebowl.s3.amazonaws.com/files/1537983163/yb111f255120a4f98bf139f465114373ed186f938d7634331ad96701a444a181/qqEiZj8xuUiGJOAyIg87fy6ErZWObvoIVuOySxKx.gif.png','2016-05-13 01:59:42.131956','2018-09-26 17:32:45.329200','zYxNL8yQUMOgKBdj2zRmQoQ3AEpwZVZP',0,2,NULL,NULL,1,NULL,'Aaron','Ogata',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-09-26 17:30:43.476300',1,1,NULL),
	(11,1,'nina.iarkova@notebowl.com',NULL,'$2y$10$/JBc6YXnDBQqWRtFkG6qy.l0X3/NA8u88ut08GzBhdfF27P.rXS9i','https://notebowl.s3.amazonaws.com/files/1537958674/pf1afd2ebd351410da9d0e92de1c743108d271eddb53c419296efcb35f284e2b/L1YCXXWXpWcRxYVhtALmVJ2UC3RuPZ7UYdHj0GWr.jpeg.jpg','2016-05-13 01:59:42.214564','2018-09-26 10:44:37.599900','Ubvr5tfHVsCc86T8swjYEyFjtzkjCPPC',0,2,NULL,NULL,1,NULL,'Nina','Iarkova',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-09-26 10:42:42.701800',1,1,NULL),
	(12,1,'rachel.helmstetter@notebowl.com',NULL,'$2y$10$SXbzSG7z8Ot1ACw7zNcJa.W2niC1sbM6gBEgtYTaptqK7u7q7BoIG',NULL,'2016-05-13 01:59:42.298808','2016-11-10 20:20:28.692100','nzrHeALihLTymfkwJBsslhg0DadMFlxW',0,2,NULL,NULL,1,NULL,'Rachel','Helmstetter',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(13,1,'jose.garcia@notebowl.com',NULL,'$2y$10$chEUy4yP0USX7nuJ.oxIcOjYrdIC/QBhD56eJWW6VJdx48VMZ7L22',NULL,'2016-05-13 01:59:42.384662','2016-11-10 20:20:28.692100','XdnqLaL8eoMFFzLazUJT0yl9zoT2dx1E',0,2,NULL,NULL,1,NULL,'Jose','Garcia',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(14,1,'keith.taylor@notebowl.com',NULL,'$2y$10$80cBoPBKeoWKEmHIH1AH4uZcFkeyeQ2vhXo/WzCNT5jeC9/eiRo3q','https://notebowl.s3.amazonaws.com/users/HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3/profile-picture/sDZo4XroQICYygcvu7pNBBIby0MftYbB','2016-05-13 01:59:42.466155','2018-08-28 00:39:43.272500','HehHyGvgsQYtgedJuuSvU0Al4PxzDpn3',0,2,NULL,NULL,1,NULL,'Keith','Taylor',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-08-28 00:39:43.272500',1,1,NULL),
	(15,1,'zedel@asu.edu',NULL,'$2y$10$rYAGI/IqVZpbNtjNxgJr5u/gcbJvZalbe0EGcgQujJiJjcT3tFvzy',NULL,'2016-05-13 01:59:42.545244','2016-11-10 20:20:28.692100','kKGeYrjclHb0s4iDeDSQISx0nKKx3S84',0,2,NULL,NULL,1,NULL,'Zachary','Edel',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(16,1,'demo-user@notebowl.com',NULL,'$2y$10$OFclDBtCIx5Cou8MR/lKm.mBUnyjArU.mm0sfFN9QkYJmUXlW/YMy',NULL,'2016-05-13 01:59:42.670308','2016-11-10 20:20:28.692100','k3SJ7WctkCFNcFAj7KumfWebx7doIieh',0,2,NULL,NULL,1,NULL,'Notebowl','Tester',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(17,1,'rmahmad@notebowl.com',NULL,'$2y$10$lq.WjdBRmPwkMOof0t3iNucXOzX83sKrW76b8cww0wCo6ElHRtoh6',NULL,'2016-05-13 01:59:42.807548','2016-11-10 20:20:28.692100','OJSU0SlF4aFknh4Six8kgbxrlTDXLFPe',0,2,NULL,NULL,1,NULL,'Rizwan','Ahmad',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(18,1,'spluta@notebowl.com',NULL,'$2y$10$w/O5TcqkCnqyV4Phn3GBPubazrkDuG8XQPrbZkX8tnotiP0DaSi.y','https://notebowl.s3.amazonaws.com/users/Eq0uKBoESBjPxuTMDtG6FsAi8CdbPEK1/profile-picture/uwFFWjZI8tlRzsG3r5vy5pUcaTvARcI3 ','2016-05-13 01:59:42.886432','2016-11-10 20:20:28.692100','Eq0uKBoESBjPxuTMDtG6FsAi8CdbPEK1',0,2,NULL,NULL,1,NULL,'Stephen','Pluta',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL),
	(19,1,'chdowen@notebowl.com',NULL,'$2y$10$P0Q4gzVTQl8XkjDQx0GTe.4Idqa/jeBOYb3aZN0EHKGzXImhzc9aq','https://notebowl.s3.amazonaws.com/files/1537959031/u0d5ab76cf43e4aad89ea1ebe678deab7a59d3c5613c4434c89e6747de520974/RxVGy3E457gLNVs2IPQS0DSVrZZnhX0X06cj1gqn.jpeg.jpg','2018-09-26 10:11:30.970800','2018-09-26 21:08:33.523900','wf8be385309224b6c86e04323fa4a28d',0,2,NULL,NULL,1,NULL,'Conner','Owen',1,1,1,NULL,NULL,NULL,NULL,NULL,2019,5,'2018-09-26 21:08:33.523800',1,1,NULL);

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
