class Services {
  Services({
    this.cateId = 0,
    this.name = '',
  });
  int cateId;
  String name;

  static List<Services> naturalDisasters = <Services>[
    Services(
      cateId: 1,
      name: 'hurricanes',
    ),
    Services(
      cateId: 2,
      name: 'lightningBolts',
    ),
    Services(
      cateId: 3,
      name: 'flood',
    ),
    Services(
      cateId: 4,
      name: 'another',
    ),
  ];


  static List<Services> police = <Services>[
    Services(
      cateId: 1,
      name: 'theft',
    ),
    Services(
      cateId: 2,
      name: 'killing',
    ),
    Services(
      cateId: 3,
      name: 'missingPerson',
    ),
    Services(
      cateId: 4,
      name: 'bigFight',
    ),
    Services(
      cateId: 5,
      name: 'another',
    ),
  ];




  static List<Services> coastguard = <Services>[
    Services(
      cateId: 1,
      name: 'sinking',
    ),
    Services(
      cateId: 2,
      name: 'swimmingInjuries',
    ),
    Services(
      cateId: 3,
      name: 'losingPeopleSea',
    ),
    Services(
      cateId: 4,
      name: 'marineFishing',
    ),
    Services(
      cateId: 5,
      name: 'boatAccidents',
    ),
    Services(
      cateId: 6,
      name: 'another',
    ),
  ];

  static List<Services> trafficPolice = <Services>[
    Services(
      cateId: 1,
      name: 'trafficAccident',
    ),
    Services(
      cateId: 2,
      name: 'driverEscape',
    ),
    Services(
      cateId: 3,
      name: 'another',
    ),
  ];
  static List<Services> civilDefense = <Services>[
    Services(
      cateId: 1,
      name: 'afire',
    ),
    Services(
      cateId: 2,
      name: 'stuckPerson',
    ),
    Services(
      cateId: 3,
      name: 'stuckAnimal',
    ),
    Services(
      cateId: 4,
      name: 'electricPetition',
    ),
    Services(
      cateId: 5,
      name: 'gasLeakage',
    ),
    Services(
      cateId: 6,
      name: 'poisonousAnimal',
    ),
    Services(
      cateId: 7,
      name: 'another',
    ),
  ];



  static List<Services> ambulance = <Services>[
    Services(
      cateId: 1,
      name: 'trafficAccident',
    ),
    Services(
      cateId: 2,
      name: 'prematureBirth',
    ),
    Services(
      cateId: 3,
      name: 'heartFailure',
    ),
    Services(
      cateId: 4,
      name: 'burns',
    ),
    Services(
      cateId: 5,
      name: 'fainting',
    ),
    Services(
      cateId: 6,
      name: 'sugarComas',
    ),
    Services(
      cateId: 7,
      name: 'faintingBlood',
    ),
    Services(
      cateId: 8,
      name: 'another',
    ),
  ];
}
