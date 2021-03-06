-- Inserting ecranisation types
INSERT INTO `movie_ecranisation_type` (`id`, `name`) VALUES
(1, '2D'),
(2, '3D'),
(3, '4D');

-- Inserting rooms
INSERT INTO `rooms` (`id`, `name`) VALUES
(1, 'Eminescu'),
(2, 'Cosbuc'),
(3, 'Toparceanu');

-- Inserting room ecranisation supports
INSERT INTO `room_ecranisation_type` (`id`, `room_id`, `ecranisation_type_id`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 2, 3);

-- Inserting seats for rooms
INSERT INTO `seats` (`id`, `room_id`, `seat_id`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 1, 4),
(5, 1, 5),
(6, 1, 6),
(7, 1, 7),
(8, 1, 8),
(9, 1, 9),
(10, 1, 10),
(11, 1, 11),
(12, 1, 12),
(13, 1, 13),
(14, 1, 14),
(15, 1, 15),
(16, 1, 16),
(17, 1, 17),
(18, 1, 18),
(19, 1, 19),
(20, 1, 20),
(21, 1, 21),
(22, 1, 22),
(23, 1, 23),
(24, 1, 24),
(25, 1, 25),
(26, 1, 26),
(27, 1, 27),
(28, 1, 28),
(29, 1, 29),
(30, 1, 30),
(31, 1, 31),
(32, 1, 32),
(33, 1, 33),
(34, 1, 34),
(35, 1, 35),
(36, 1, 36),
(37, 1, 37),
(38, 1, 38),
(39, 1, 39),
(40, 1, 40),
(41, 1, 41),
(42, 1, 42),
(43, 1, 43),
(44, 1, 44),
(45, 1, 45),
(46, 1, 46),
(47, 1, 47),
(48, 1, 48),
(49, 1, 49),
(50, 1, 50),
(51, 1, 51),
(52, 1, 52),
(53, 1, 53),
(54, 1, 54),
(55, 2, 1),
(56, 2, 2),
(57, 2, 3),
(58, 2, 4),
(59, 2, 5),
(60, 2, 6),
(61, 2, 7),
(62, 2, 8),
(63, 2, 9),
(64, 2, 10),
(65, 2, 11),
(66, 2, 12),
(67, 2, 13),
(68, 2, 14),
(69, 2, 15),
(70, 2, 16),
(71, 2, 17),
(72, 2, 18),
(73, 2, 19),
(74, 2, 20),
(75, 2, 21),
(76, 2, 22),
(77, 2, 23),
(78, 2, 24),
(79, 2, 25),
(80, 2, 26),
(81, 2, 27),
(82, 2, 28),
(83, 2, 29),
(84, 2, 30),
(85, 2, 31),
(86, 2, 32),
(87, 2, 33),
(88, 2, 34),
(89, 2, 35),
(90, 2, 36),
(91, 2, 37),
(92, 2, 38),
(93, 2, 39),
(94, 2, 40),
(95, 2, 41),
(96, 2, 42),
(97, 2, 43),
(98, 2, 44),
(99, 2, 45),
(100, 2, 46),
(101, 2, 47),
(102, 2, 48),
(103, 2, 49),
(104, 2, 50),
(105, 2, 51),
(106, 2, 52),
(107, 2, 53),
(108, 2, 54),
(109, 3, 1),
(110, 3, 2),
(111, 3, 3),
(112, 3, 4),
(113, 3, 5),
(114, 3, 6),
(115, 3, 7),
(116, 3, 8),
(117, 3, 9),
(118, 3, 10),
(119, 3, 11),
(120, 3, 12),
(121, 3, 13),
(122, 3, 14),
(123, 3, 15),
(124, 3, 16),
(125, 3, 17),
(126, 3, 18),
(127, 3, 19),
(128, 3, 20),
(129, 3, 21),
(130, 3, 22),
(131, 3, 23),
(132, 3, 24),
(133, 3, 25),
(134, 3, 26),
(135, 3, 27),
(136, 3, 28),
(137, 3, 29),
(138, 3, 30),
(139, 3, 31),
(140, 3, 32),
(141, 3, 33),
(142, 3, 34),
(143, 3, 35),
(144, 3, 36),
(145, 3, 37),
(146, 3, 38),
(147, 3, 39),
(148, 3, 40),
(149, 3, 41),
(150, 3, 42),
(151, 3, 43),
(152, 3, 44),
(153, 3, 45),
(154, 3, 46),
(155, 3, 47),
(156, 3, 48),
(157, 3, 49),
(158, 3, 50),
(159, 3, 51),
(160, 3, 52),
(161, 3, 53),
(162, 3, 54);

-- Inserting movies
INSERT INTO `movies` (`id`, `name`, `duration_seconds`, `ecranisation_type`) VALUES
(1, 'Iron Man 1', 7400, 1),
(2, 'Iron Man 2', 7800, 2);


-- Inserting schedules
INSERT INTO `schedules` (`id`, `timestamp`, `movie_id`, `room_id`) VALUES
(1, '2020-01-05 22:00:00', 1, 1),
(2, '2020-01-17 22:00:00', 2, 1),
(10, '2020-01-17 22:00:00', 1, 1),
(12, '2020-01-04 22:00:00', 1, 1),
(13, '2020-01-05 14:36:08', 1, 1);


-- seat_occupation_seat are inserted with the trigger