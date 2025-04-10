-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`user` (
  `user_id` VARCHAR(20) NOT NULL,
  `nickname` VARCHAR(20) NOT NULL,
  `user_password` VARCHAR(20) NOT NULL,
  `name` VARCHAR(10) NOT NULL,
  `address` TEXT NOT NULL,
  `detail_address` TEXT NULL,
  `zip_code` INT NULL,
  `birth` VARCHAR(12) NULL,
  `tel_number` VARCHAR(11) NOT NULL,
  `is_seller` TINYINT NULL DEFAULT 0,
  `gender` VARCHAR(3) NOT NULL,
  `profile_image` TEXT NULL,
  `mbti` VARCHAR(5) NULL,
  `job` VARCHAR(20) NULL,
  `self_intro` VARCHAR(250) NULL DEFAULT '안녕하세요',
  `user_point` INT NULL DEFAULT 0,
  `is_admin` TINYINT NOT NULL DEFAULT 0,
  `is_resigned` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC) VISIBLE,
  UNIQUE INDEX `tel_number_UNIQUE` (`tel_number` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`like_keyword`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`like_keyword` (
  `user_id` VARCHAR(20) NOT NULL,
  `keyword` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`user_id`, `keyword`),
  CONSTRAINT `like_keyword_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '	';


-- -----------------------------------------------------
-- Table `mydb`.`badge`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`badge` (
  `user_id` VARCHAR(20) NOT NULL,
  `badge` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`user_id`, `badge`),
  CONSTRAINT `badge_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`point_earning_list`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`point_earning_list` (
  `sequence` INT NOT NULL AUTO_INCREMENT,
  `point` INT NOT NULL,
  `history` TEXT NOT NULL,
  `user_id` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`sequence`),
  UNIQUE INDEX `sequence_UNIQUE` (`sequence` ASC) VISIBLE,
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `point_earning_list_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`need_helper`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`need_helper` (
  `reward` TEXT NOT NULL,
  `sequence` INT NOT NULL AUTO_INCREMENT,
  `user_id` VARCHAR(20) NOT NULL,
  `title` TEXT NOT NULL,
  `content` TEXT NOT NULL,
  `date` VARCHAR(35) NOT NULL,
  `location` TEXT NOT NULL,
  `category` TEXT NULL,
  `is_request_solved` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`sequence`),
  UNIQUE INDEX `sequence_UNIQUE` (`sequence` ASC) VISIBLE,
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `need_helper_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`user_review`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`user_review` (
  `review_sequence` INT NOT NULL AUTO_INCREMENT,
  `reviewed_post_sequence` INT NOT NULL,
  `writer_id` VARCHAR(20) NOT NULL,
  `reviewed_id` VARCHAR(20) NOT NULL,
  `review_type` VARCHAR(20) NOT NULL,
  `post_date` VARCHAR(35) NOT NULL,
  `rating` FLOAT NOT NULL DEFAULT 0.0,
  `content` TEXT NOT NULL,
  PRIMARY KEY (`review_sequence`),
  UNIQUE INDEX `review_sequence_UNIQUE` (`review_sequence` ASC) VISIBLE,
  INDEX `writer_id_idx` (`writer_id` ASC) VISIBLE,
  INDEX `reviewed_id_idx` (`reviewed_id` ASC) VISIBLE,
  CONSTRAINT `user_review_reviewed_post_sequence`
    FOREIGN KEY (`review_sequence`)
    REFERENCES `mydb`.`need_helper` (`sequence`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `user_review_writer_id`
    FOREIGN KEY (`writer_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_review_reviewed_id`
    FOREIGN KEY (`reviewed_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`product` (
  `name` TEXT NOT NULL,
  `sequence` INT NOT NULL AUTO_INCREMENT,
  `seller_id` VARCHAR(20) NOT NULL,
  `price` INT NOT NULL,
  `category` TEXT NOT NULL,
  `content` TEXT NOT NULL,
  `selling_amount` INT NOT NULL,
  `bought_amount` INT NOT NULL DEFAULT 0,
  `purchased_people` INT NOT NULL DEFAULT 0,
  `deadline` VARCHAR(35) NOT NULL,
  `is_sold_out` TINYINT NOT NULL DEFAULT 0,
  `ad_payment` INT NULL,
  `reserve_date` VARCHAR(35) NOT NULL,
  PRIMARY KEY (`sequence`),
  UNIQUE INDEX `sequence_UNIQUE` (`sequence` ASC) VISIBLE,
  INDEX `seller_id_idx` (`seller_id` ASC) VISIBLE,
  CONSTRAINT `seller_id`
    FOREIGN KEY (`seller_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`reserved_user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`reserved_user` (
  `product_sequence` INT NOT NULL,
  `user_id` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`product_sequence`, `user_id`),
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `reserved_user_product_sequence`
    FOREIGN KEY (`product_sequence`)
    REFERENCES `mydb`.`product` (`sequence`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `reserved_user_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`product_review`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`product_review` (
  `review_sequence` INT NOT NULL AUTO_INCREMENT,
  `product_sequence` INT NOT NULL,
  `user_id` VARCHAR(20) NOT NULL,
  `post_date` VARCHAR(35) NOT NULL,
  `rating` FLOAT NOT NULL DEFAULT 0.0,
  `content` TEXT NOT NULL,
  `review_image` TEXT NULL,
  PRIMARY KEY (`review_sequence`),
  UNIQUE INDEX `review_sequence_UNIQUE` (`review_sequence` ASC) VISIBLE,
  INDEX `product_sequence_idx` (`product_sequence` ASC) VISIBLE,
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `product_review_product_sequence`
    FOREIGN KEY (`product_sequence`)
    REFERENCES `mydb`.`product` (`sequence`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `product_review_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`order` (
  `order_id` VARCHAR(64) NOT NULL,
  `user_id` VARCHAR(50) NOT NULL,
  `amount` INT NOT NULL,
  `buyer_address` TEXT NOT NULL,
  PRIMARY KEY (`order_id`),
  UNIQUE INDEX `customer_key_UNIQUE` (`user_id` ASC) VISIBLE,
  CONSTRAINT `order_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`order_item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`order_item` (
  `order_item_sequence` INT NOT NULL AUTO_INCREMENT,
  `order_id` VARCHAR(64) NOT NULL,
  `product_sequence` INT NOT NULL,
  `product_name` VARCHAR(255) NOT NULL,
  `price` INT NOT NULL,
  `quantity` INT NOT NULL,
  `total_price` INT NOT NULL,
  PRIMARY KEY (`order_item_sequence`),
  UNIQUE INDEX `sequence_UNIQUE` (`order_item_sequence` ASC) VISIBLE,
  INDEX `order_id_idx` (`order_id` ASC) VISIBLE,
  INDEX `product_sequence_idx` (`product_sequence` ASC) VISIBLE,
  CONSTRAINT `order_item_order_id`
    FOREIGN KEY (`order_id`)
    REFERENCES `mydb`.`order` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `order_item_product_sequence`
    FOREIGN KEY (`product_sequence`)
    REFERENCES `mydb`.`product` (`sequence`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`payment_conform`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`payment_conform` (
  `payment_key` VARCHAR(200) NOT NULL,
  `order_id` VARCHAR(64) NOT NULL,
  `status` VARCHAR(20) NOT NULL,
  `method` VARCHAR(15) NOT NULL,
  `approved_time` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`payment_key`),
  UNIQUE INDEX `order_id_UNIQUE` (`order_id` ASC) VISIBLE,
  UNIQUE INDEX `payment_key_UNIQUE` (`payment_key` ASC) VISIBLE,
  CONSTRAINT `payment_conform_order_id`
    FOREIGN KEY (`order_id`)
    REFERENCES `mydb`.`order` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`payment_cancel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`payment_cancel` (
  `payment_key` VARCHAR(200) NOT NULL,
  `cancel_amount` INT NOT NULL,
  `cancel_reason` TEXT NOT NULL,
  `canceled_time` VARCHAR(30) NOT NULL,
  `status` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`payment_key`),
  UNIQUE INDEX `payment_key_UNIQUE` (`payment_key` ASC) VISIBLE,
  CONSTRAINT `payment_cancel_payment_key`
    FOREIGN KEY (`payment_key`)
    REFERENCES `mydb`.`payment_conform` (`payment_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`payment_transaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`payment_transaction` (
  `transaction_key` VARCHAR(64) NOT NULL,
  `payment_key` VARCHAR(200) NOT NULL,
  `type` VARCHAR(20) NOT NULL,
  `status` VARCHAR(20) NOT NULL,
  `amount` INT NOT NULL,
  `transaction_time` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`transaction_key`),
  UNIQUE INDEX `transaction_key_UNIQUE` (`transaction_key` ASC) VISIBLE,
  INDEX `payment_key_idx` (`payment_key` ASC) VISIBLE,
  CONSTRAINT `payment_transaction_payment_key`
    FOREIGN KEY (`payment_key`)
    REFERENCES `mydb`.`payment_conform` (`payment_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`shopping_cart`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`shopping_cart` (
  `shopping_cart_sequence` INT NOT NULL AUTO_INCREMENT,
  `user_id` VARCHAR(20) NOT NULL,
  `product_sequence` INT NOT NULL,
  `quantity` INT NOT NULL,
  `added_date` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`shopping_cart_sequence`),
  UNIQUE INDEX `shopping_cart_sequence_UNIQUE` (`shopping_cart_sequence` ASC) VISIBLE,
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  INDEX `product_sequnece_idx` (`product_sequence` ASC) VISIBLE,
  CONSTRAINT `shopping_cart_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `shopping_cart_product_sequnece`
    FOREIGN KEY (`product_sequence`)
    REFERENCES `mydb`.`product` (`sequence`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`wish_list`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`wish_list` (
  `user_id` VARCHAR(20) NOT NULL,
  `product_sequence` INT NOT NULL,
  PRIMARY KEY (`user_id`, `product_sequence`),
  INDEX `product_sequence_idx` (`product_sequence` ASC) VISIBLE,
  CONSTRAINT `wish_list_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `wish_list_product_sequence`
    FOREIGN KEY (`product_sequence`)
    REFERENCES `mydb`.`product` (`sequence`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`helper_comment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`helper_comment` (
  `comment_sequence` INT NOT NULL AUTO_INCREMENT,
  `post_sequence` INT NOT NULL,
  `user_id` VARCHAR(20) NOT NULL,
  `content` TEXT NOT NULL,
  `post_date` VARCHAR(35) NOT NULL,
  PRIMARY KEY (`comment_sequence`),
  UNIQUE INDEX `comment_sequence_UNIQUE` (`comment_sequence` ASC) VISIBLE,
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  INDEX `post_sequence_idx` (`post_sequence` ASC) VISIBLE,
  CONSTRAINT `helper_comment_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `helper_comment_post_sequence`
    FOREIGN KEY (`post_sequence`)
    REFERENCES `mydb`.`need_helper` (`sequence`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`chat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`chat` (
  `helper_id` VARCHAR(20) NOT NULL,
  `chat_sequence` INT NOT NULL AUTO_INCREMENT,
  `need_helper_sequence` INT NOT NULL,
  `chat_available` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`chat_sequence`),
  UNIQUE INDEX `chat_sequence_UNIQUE` (`chat_sequence` ASC) VISIBLE,
  INDEX `need_helper_sequence_idx` (`need_helper_sequence` ASC) VISIBLE,
  INDEX `helper_id_idx` (`helper_id` ASC) VISIBLE,
  CONSTRAINT `chat_need_helper_sequence`
    FOREIGN KEY (`need_helper_sequence`)
    REFERENCES `mydb`.`need_helper` (`sequence`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `chat_helper_id`
    FOREIGN KEY (`helper_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`message`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`message` (
  `chat_sequence` INT NOT NULL,
  `message_sequence` INT NOT NULL AUTO_INCREMENT,
  `content` TEXT NOT NULL,
  `chat_date` VARCHAR(35) NOT NULL,
  `file_url` TEXT NULL,
  `is_helper` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`message_sequence`),
  UNIQUE INDEX `message_sequence_UNIQUE` (`message_sequence` ASC) VISIBLE,
  INDEX `chat_sequence_idx` (`chat_sequence` ASC) VISIBLE,
  CONSTRAINT `message_chat_sequence`
    FOREIGN KEY (`chat_sequence`)
    REFERENCES `mydb`.`chat` (`chat_sequence`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '	';


-- -----------------------------------------------------
-- Table `mydb`.`community_post`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`community_post` (
  `post_sequence` INT NOT NULL AUTO_INCREMENT,
  `user_id` VARCHAR(20) NOT NULL,
  `post_date` VARCHAR(35) NOT NULL,
  `category` TEXT NOT NULL,
  `title` TEXT NOT NULL,
  `content` TEXT NOT NULL,
  `liked` INT NOT NULL,
  `view_count` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`post_sequence`),
  UNIQUE INDEX `post_sequence_UNIQUE` (`post_sequence` ASC) VISIBLE,
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `community_post_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`community_comment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`community_comment` (
  `comment_sequence` INT NOT NULL AUTO_INCREMENT,
  `post_sequence` INT NOT NULL,
  `user_id` VARCHAR(20) NOT NULL,
  `content` TEXT NOT NULL,
  `post_date` VARCHAR(35) NOT NULL,
  PRIMARY KEY (`comment_sequence`),
  UNIQUE INDEX `comment_sequence_UNIQUE` (`comment_sequence` ASC) VISIBLE,
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  INDEX `post_sequence_idx` (`post_sequence` ASC) VISIBLE,
  CONSTRAINT `community_comment_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `community_comment_post_sequence`
    FOREIGN KEY (`post_sequence`)
    REFERENCES `mydb`.`community_post` (`post_sequence`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`liked`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`liked` (
  `user_id` VARCHAR(20) NOT NULL,
  `liked_post_sequence` INT NOT NULL,
  PRIMARY KEY (`user_id`, `liked_post_sequence`),
  INDEX `liked_post_sequence_idx` (`liked_post_sequence` ASC) VISIBLE,
  CONSTRAINT `liked_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `liked_post_sequence`
    FOREIGN KEY (`liked_post_sequence`)
    REFERENCES `mydb`.`community_post` (`post_sequence`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`bookmark`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`bookmark` (
  `user_id` VARCHAR(20) NOT NULL,
  `bookmarked_post_sequence` INT NOT NULL,
  PRIMARY KEY (`user_id`, `bookmarked_post_sequence`),
  INDEX `bookmarked_post_sequence_idx` (`bookmarked_post_sequence` ASC) VISIBLE,
  CONSTRAINT `bookmark_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `bookmarked_post_sequence`
    FOREIGN KEY (`bookmarked_post_sequence`)
    REFERENCES `mydb`.`community_post` (`post_sequence`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`event`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`event` (
  `event_sequence` INT NOT NULL AUTO_INCREMENT,
  `title` TEXT NOT NULL,
  `deadline` VARCHAR(35) NOT NULL,
  `needed_point` INT NOT NULL,
  `content` TEXT NOT NULL,
  `image` TEXT NULL,
  PRIMARY KEY (`event_sequence`),
  UNIQUE INDEX `event_sequence_UNIQUE` (`event_sequence` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`attender_list`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`attender_list` (
  `attended_event_sequence` INT NOT NULL,
  `user_id` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`attended_event_sequence`, `user_id`),
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `attender_list_attended_event_sequence`
    FOREIGN KEY (`attended_event_sequence`)
    REFERENCES `mydb`.`event` (`event_sequence`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `attender_list_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`question`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`question` (
  `question_sequence` INT NOT NULL AUTO_INCREMENT,
  `user_id` VARCHAR(20) NOT NULL,
  `post_date` VARCHAR(35) NOT NULL,
  `title` TEXT NOT NULL,
  `category` TEXT NOT NULL,
  `content` TEXT NOT NULL,
  `answer` TEXT NOT NULL,
  `is_answered` TINYINT NOT NULL,
  PRIMARY KEY (`question_sequence`),
  UNIQUE INDEX `question_sequence_UNIQUE` (`question_sequence` ASC) VISIBLE,
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `question_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`report`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`report` (
  `report_sequence` INT NOT NULL AUTO_INCREMENT,
  `reporter_id` VARCHAR(20) NOT NULL,
  `reported_entity_num` INT NOT NULL,
  `reported_entity_type` VARCHAR(10) NOT NULL,
  `reported_content` TEXT NOT NULL,
  `reported_date` VARCHAR(35) NOT NULL,
  `report_category` TEXT NOT NULL,
  `report_detail` TEXT NOT NULL,
  `report_process` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`report_sequence`),
  UNIQUE INDEX `report_sequence_UNIQUE` (`report_sequence` ASC) VISIBLE,
  INDEX `reporter_id_idx` (`reporter_id` ASC) VISIBLE,
  CONSTRAINT `report_reporter_id`
    FOREIGN KEY (`reporter_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`alert`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`alert` (
  `alert_sequence` INT NOT NULL AUTO_INCREMENT,
  `alert_type` VARCHAR(20) NOT NULL,
  `sender_id` VARCHAR(20) NOT NULL,
  `alert_entity_sequence` INT NOT NULL,
  `receiver_id` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`alert_sequence`),
  UNIQUE INDEX `alert_sequence_UNIQUE` (`alert_sequence` ASC) VISIBLE,
  INDEX `receiver_id_idx` (`receiver_id` ASC) VISIBLE,
  INDEX `sender_id_idx` (`sender_id` ASC) VISIBLE,
  CONSTRAINT `alert_receiver_id`
    FOREIGN KEY (`receiver_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `alert_sender_id`
    FOREIGN KEY (`sender_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
