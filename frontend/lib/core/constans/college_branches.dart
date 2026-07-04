class AppConstants {
  AppConstants._();
  // MVP branch and subject data for StudyVault
  static const List<String> items = [
    'Delhi University',
    'Gurugram University',
    'Mumbai University',
    'Bangalore University',
  ];
  static const List<String> semesters = [
    'Semester I',
    'Semester II',
    'Semester III',
    'Semester IV',
    'Semester V',
    'Semester VI',
    'Semester VII',
    'Semester VIII',
  ];
  static const Map<String, List<String>> mvpSubjectsByBranch = {
    'CSE': [
      "All",
      'DSA',
      'DBMS',
      'Operating Systems',
      'Computer Networks',
      'Software Engineering',
      'Java',
      'Python',
      'AI',
      'Machine Learning',
    ],

    'IT': [
      "All",
      'DSA',
      'DBMS',
      'Operating Systems',
      'Computer Networks',
      'Web Development',
      'Java',
      'Python',
    ],

    'ECE': [
      "All",
      'Digital Electronics',
      'Signals & Systems',
      'Microprocessors',
      'Communication Systems',
      'Embedded Systems',
    ],

    'EEE': [
      "All",
      'Electrical Machines',
      'Power Systems',
      'Control Systems',
      'Power Electronics',
    ],

    'EE': [
      "All",
      'Electrical Machines',
      'Power Systems',
      'Control Systems',
      'Network Theory',
    ],

    'Mechanical': [
      "All",
      'Thermodynamics',
      'Fluid Mechanics',
      'Machine Design',
      'Manufacturing Processes',
    ],

    'Civil': [
      "All",
      'Surveying',
      'Structural Analysis',
      'Concrete Technology',
      'Geotechnical Engineering',
    ],

    'Chemical': [
      'Chemical Process Calculations',
      'Heat Transfer',
      'Mass Transfer',
      'Reaction Engineering',
    ],

    'AI & ML': [
      'Machine Learning',
      'Deep Learning',
      'Python',
      'Data Science',
      'Artificial Intelligence',
    ],

    'Data Science': [
      'Statistics',
      'Python',
      'Machine Learning',
      'Data Visualization',
      'Big Data',
    ],

    'Cyber Security': [
      'Network Security',
      'Cryptography',
      'Ethical Hacking',
      'Cyber Forensics',
    ],
  };

  static const List<String> branches = [
    'CSE',
    'IT',
    'ECE',
    'EEE',
    'EE',
    'Mechanical',
    'Civil',
    'Chemical',
    'AI & ML',
    'Data Science',
    'Cyber Security',
  ];
}
