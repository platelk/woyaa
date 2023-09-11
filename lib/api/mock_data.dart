
import 'dart:convert';

import 'package:woyaa/api/api.dart';

final KevinUserJson = jsonDecode('''{"id": 61,
"first_name": "Kevin",
"last_name": "Platel",
"email": "platel.kevin@gmail.com",
"score": 99,
"room": 10,
"wedding_table": "Bali",
"full_picture_path": "/photos/photo_gellule/Kevin.png",
"round_picture_path": "/photos/photo_ronde/Kevin.png",
"game_team": "Vert"
}''');

final YoannUserJson = jsonDecode('''{
        "id": 33,
        "first_name": "Yoann",
        "last_name": "Deshaies",
        "email": "deshaies.yoann@gmail.com",
        "score": 62,
        "room": 1,
        "wedding_table": "Rovaniemi",
        "full_picture_path": "/photos/photo_gellule/Yoann.png",
        "round_picture_path": "/photos/photo_ronde/Yoann.png",
        "game_team": "N/A"
    }''');

final SwipeResultJson = jsonDecode('''{
    "found_my_table": false,
    "not_found_my_table": false,
    "found_not_my_table": false,
    "not_found_not_my_table": true
}''');

final TableResultJson = jsonDecode('''{
    "tables": [
        {
            "name": "Berlin",
            "total": 8,
            "user_ids": null
        },
        {
            "name": "Bali",
            "total": 7,
            "user_ids": null
        },
        {
            "name": "Amsterdam",
            "total": 8,
            "user_ids": null
        },
        {
            "name": "Dubrovnik",
            "total": 7,
            "user_ids": null
        },
        {
            "name": "Valence",
            "total": 9,
            "user_ids": null
        },
        {
            "name": "Paris",
            "total": 9,
            "user_ids": null
        },
        {
            "name": "Londres",
            "total": 9,
            "user_ids": null
        },
        {
            "name": "Rovaniemi",
            "total": 16,
            "user_ids": null
        },
        {
            "name": "Tel Aviv",
            "total": 8,
            "user_ids": null
        }
    ]
}''');

final QuestionsResultJson = jsonDecode('''{
    "questions": [
        {
            "question_id": 24,
            "question": "Avec qui Ana est partie à Europa Park ?",
            "is_ana": true,
            "is_yoann": false,
            "nb_answers": 6
        },
        {
            "question_id": 27,
            "question": "Qui a baptisé le cochon du Chateau Johnny le Porky et en est éperduement amoureux ? Essayez de le trouver ;)",
            "is_ana": true,
            "is_yoann": true,
            "nb_answers": 1
        },
        {
            "question_id": 20,
            "question": "Avec qui Ana a créé son cabinet d'architecture et 3 restaurants ? ",
            "is_ana": true,
            "is_yoann": false,
            "nb_answers": 1
        },
        {
            "question_id": 13,
            "question": "Qui est le parain de Yoann ? ",
            "is_ana": false,
            "is_yoann": true,
            "nb_answers": 1
        },
        {
            "question_id": 12,
            "question": "Qui Yoann a t-il cherché dans toute la ville aux Etats-Unis pendant plusieurs heures à 4h du matin ? Et qui le guidait au téléphone pendant se temps là depuis Stockholm ?",
            "is_ana": false,
            "is_yoann": true,
            "nb_answers": 2
        },
        {
            "question_id": 26,
            "question": "Qui va apporter son drône pour le mariage ?",
            "is_ana": true,
            "is_yoann": true,
            "nb_answers": 2
        },
        {
            "question_id": 36,
            "question": "Avec qui les mariés ont couru partout pour retrouvé Nuts qui avait été volé ? ",
            "is_ana": true,
            "is_yoann": true,
            "nb_answers": 1
        },
        {
            "question_id": 4,
            "question": "Qui Yoann connait depuis le CE2 ?",
            "is_ana": false,
            "is_yoann": true,
            "nb_answers": 1
        },
        {
            "question_id": 31,
            "question": "Avec qui Yoann et Ana ont fait une chasse au trésor sur l'île Gili T. ?",
            "is_ana": true,
            "is_yoann": true,
            "nb_answers": 3
        },
        {
            "question_id": 23,
            "question": "Avec qui Ana a t-elle déjà travaillé ? ",
            "is_ana": true,
            "is_yoann": false,
            "nb_answers": 5
        },
        {
            "question_id": 25,
            "question": "Qui vivait sur la péniche, lieu où Ana et Yoann sont tombés définitivement amoureux ? ",
            "is_ana": true,
            "is_yoann": true,
            "nb_answers": 2
        },
        {
            "question_id": 11,
            "question": "Avec qui Yoann est parti le temps d'un week-end sur un coup de tête en suivant les votes de sondage instagram pour décider des directions à prendre et activités à suivre ?",
            "is_ana": false,
            "is_yoann": true,
            "nb_answers": 2
        },
        {
            "question_id": 2,
            "question": "Quels sont les 2 principales personnes avec qui Yoann a organisé le Week-end d'intégration pendant qu'il était Président du BDE ?",
            "is_ana": false,
            "is_yoann": true,
            "nb_answers": 2
        },
        {
            "question_id": 34,
            "question": "Le jour des 30 ans de Yoann, nous étions à un mariage, qui étaient les mariés ? ",
            "is_ana": true,
            "is_yoann": true,
            "nb_answers": 2
        },
        {
            "question_id": 5,
            "question": "Avec qui Yoann a t-il passé la majorité de son temps en deuxième première année de médecine ? ",
            "is_ana": false,
            "is_yoann": true,
            "nb_answers": 1
        },
        {
            "question_id": 17,
            "question": "A qui Ana a t-elle envoyé un mail de refus d'embauche en se trompant de prénom ? Et qu'elle a fini par embaucher. ",
            "is_ana": true,
            "is_yoann": false,
            "nb_answers": 1
        },
        {
            "question_id": 8,
            "question": "Qui a développé cette app géniale ? Merci à lui !!!",
            "is_ana": false,
            "is_yoann": true,
            "nb_answers": 1
        },
        {
            "question_id": 15,
            "question": "Avec qui Ana a t-elle fabriqué son premier pont en carton à l'école d'architecture ? ",
            "is_ana": true,
            "is_yoann": false,
            "nb_answers": 1
        },
        {
            "question_id": 16,
            "question": "A qui Ana a fait faire un café le premier jour qu'elle l'a rencontré ? ",
            "is_ana": true,
            "is_yoann": false,
            "nb_answers": 2
        },
        {
            "question_id": 7,
            "question": "Qui a demandé à Yoann de donner ses informations de carte de crédit à une hôtesse thaïlandaise par téléphone pour acheter un billet Bangkok -> Paris pour le jour même, après avoir perdu sa propre carte de crédit et s'être trompé de deux semaines pour son vol ?",
            "is_ana": false,
            "is_yoann": true,
            "nb_answers": 1
        },
        {
            "question_id": 21,
            "question": "De qui Ana est la marraine ? ",
            "is_ana": true,
            "is_yoann": false,
            "nb_answers": 1
        },
        {
            "question_id": 0,
            "question": "Avec qui Yoann est parti aux Etats-Unis pendant son année à l'étranger ?",
            "is_ana": false,
            "is_yoann": true,
            "nb_answers": 6
        },
        {
            "question_id": 14,
            "question": "Avec qui Yoann a t-il changer une roue de voiture sous la pluie battante au bord de l'autoroute. L'a remontée à l'envers et cassé le roulement. Et qui était dans la voiture balais qui les a accompagnés jusqu'au garage ?  ",
            "is_ana": false,
            "is_yoann": true,
            "nb_answers": 3
        },
        {
            "question_id": 28,
            "question": "Qui a éteint le feu du barbecue qui s'est déclenché lors de nos vacances à Annecy ? ",
            "is_ana": true,
            "is_yoann": true,
            "nb_answers": 1
        },
        {
            "question_id": 35,
            "question": "Avec qui Ana a goûté son 1er oursin ? ",
            "is_ana": true,
            "is_yoann": false,
            "nb_answers": 1
        },
        {
            "question_id": 40,
            "question": "Avec qui Ana devait partir à Tel Aviv, mais son passeport était périmé ? ",
            "is_ana": true,
            "is_yoann": false,
            "nb_answers": 2
        },
        {
            "question_id": 18,
            "question": "Avec qui Ana a l'habitude de cracher ses poumons dans le noir sur de la musique forte le dimanche matin ?",
            "is_ana": true,
            "is_yoann": false,
            "nb_answers": 6
        },
        {
            "question_id": 1,
            "question": "Avec qui Yoann s'est trompé d'aéroport au moment de prendre un vol ?",
            "is_ana": false,
            "is_yoann": true,
            "nb_answers": 1
        },
        {
            "question_id": 19,
            "question": "Avec qui Ana dans la voiture lorsque que celle-ci a perdue une roue en roulant ? ",
            "is_ana": true,
            "is_yoann": false,
            "nb_answers": 4
        },
        {
            "question_id": 10,
            "question": "Qui, à plusieurs reprises, nous a fait passer des soirées dont on parle encore aujourd'hui à Epitech ? Est-ce que quelqu'un sait où est passé le téléphone de Manu ?",
            "is_ana": false,
            "is_yoann": true,
            "nb_answers": 1
        },
        {
            "question_id": 22,
            "question": "Avec qui la mariée a déjà vendue des glaces italiennes jusqu'à 2h du mat ? ",
            "is_ana": true,
            "is_yoann": false,
            "nb_answers": 1
        },
        {
            "question_id": 42,
            "question": "Qui a jeté un vers de terre sur Ana ? ",
            "is_ana": true,
            "is_yoann": false,
            "nb_answers": 1
        },
        {
            "question_id": 3,
            "question": "Avec qui Yoann a t-il déjà été en collocation ?",
            "is_ana": false,
            "is_yoann": true,
            "nb_answers": 6
        },
        {
            "question_id": 29,
            "question": "Qui est rentré un soir, une heure avant les mariés dans leur appartement, sans ce rendre compte qu'ils avaient été cambriolés ?",
            "is_ana": true,
            "is_yoann": true,
            "nb_answers": 1
        },
        {
            "question_id": 9,
            "question": "Qui a été l'encadrant pédagogique préféré de Yoann ? ",
            "is_ana": false,
            "is_yoann": true,
            "nb_answers": 1
        },
        {
            "question_id": 37,
            "question": "Avec qui les mariés se sont-ils costumés en Viking ?",
            "is_ana": true,
            "is_yoann": true,
            "nb_answers": 9
        },
        {
            "question_id": 43,
            "question": "Qui organise un event annuel où Ana pourra faire Sam pour la 1ère fois ? ",
            "is_ana": true,
            "is_yoann": true,
            "nb_answers": 2
        },
        {
            "question_id": 38,
            "question": "Qui a inspiré les mariés à commencer la planche à voile ? ",
            "is_ana": true,
            "is_yoann": true,
            "nb_answers": 2
        },
        {
            "question_id": 32,
            "question": "Avec qui Ana et Yoann ont mangé un 'Pekka' jusqu'à ne plus en pouvoir et laisser la moitié du plat ? ",
            "is_ana": true,
            "is_yoann": true,
            "nb_answers": 2
        },
        {
            "question_id": 39,
            "question": "Qui a appris à Ana à faire son propre pain ? ",
            "is_ana": true,
            "is_yoann": false,
            "nb_answers": 1
        },
        {
            "question_id": 41,
            "question": "Qui nous a mis en contact avec l'acheteur du dernier resto d'Ana ? ",
            "is_ana": true,
            "is_yoann": false,
            "nb_answers": 1
        },
        {
            "question_id": 6,
            "question": "Avec qui Yoann a t-il pêché son premier thon ? ",
            "is_ana": false,
            "is_yoann": true,
            "nb_answers": 3
        },
        {
            "question_id": 33,
            "question": "Avec qui Ana a-t-elle dîné dans le noir total ? ",
            "is_ana": true,
            "is_yoann": false,
            "nb_answers": 4
        },
        {
            "question_id": 30,
            "question": "Avec qui Ana et Yoann ont mis 4h pour rentrer chez eux après avoir fêté le nouvel an à Boulogne ? ",
            "is_ana": true,
            "is_yoann": true,
            "nb_answers": 1
        }
    ]
}''');

final SwipableJson = jsonDecode('''{
    "users": [
        28,
        82,
        56,
        53,
        20,
        69,
        9,
        36,
        29,
        59,
        81,
        18,
        77,
        1,
        49,
        31,
        22,
        34,
        32,
        64,
        68,
        54,
        7,
        25,
        5,
        11,
        42,
        40,
        43,
        75,
        70,
        45,
        37,
        72,
        8,
        57,
        15,
        76,
        80,
        50,
        35,
        3,
        44,
        26,
        51,
        4,
        41,
        21,
        27,
        66,
        62,
        30,
        48,
        55,
        67,
        78,
        24,
        38,
        14,
        23,
        58,
        12,
        60,
        33,
        52,
        19,
        2,
        79,
        6,
        46,
        47,
        63,
        65,
        16,
        74,
        73,
        13,
        71,
        39,
        10
    ],
    "swiped_users": [
    ]
}''');