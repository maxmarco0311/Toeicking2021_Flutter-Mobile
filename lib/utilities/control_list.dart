// 情境下拉選單
Map<String, String> contextCategories = {
  '住宿交通': '1',
  '餐飲觀光': '2',
  '行銷與銷售': '3',
  '生產與製造': '4',
  '商務會議': '5',
  '辦公室溝通': '6',
  '人事招募': '7',
  '購物訂單': '8',
  '經營管理': '9',
  '設備與修繕': '10',
  '客戶溝通': '11',
  '典禮與活動': '12',
};

// 文法母下拉選單
Map<String, String> topDropdown = {
  '動詞時態': 'verbTenses',
  '被動語態': 'passiveVoice',
  '名詞子句': 'nounClause',
  '形容詞子句': 'adjectiveClause',
  '副詞子句': 'adverbClause',
  '子句減化': 'clauseReduction',
  '介係詞': 'preposition',
  '疑問句': 'questions',
  '動狀詞': 'verbals',
  '對等連接': 'coordinating',
};

// 文法母子下拉配對：想要在Map的泛型中放nested Map，必須使用dynamic型別
Map<String, dynamic> grammarCategoryMap = {
  'verbTenses': verbTenses,
  'passiveVoice': passiveVoice,
  'nounClause': nounClause,
  'adjectiveClause': adjectiveClause,
  'adverbClause': adverbClause,
  'clauseReduction': clauseReduction,
  'preposition': preposition,
  'questions': questions,
  'verbals': verbals,
  'coordinating': coordinating
};
// 文法子下拉選單
Map<String, String> verbTenses = {
  '現在簡單式': '1',
  '現在進行式': '2',
  '現在完成式': '3',
  '現在完成進行式': '4',
  '過去簡單式': '5',
  '過去進行式': '6',
  '過去完成式': '7',
  '過去完成進行式': '8',
  '未來簡單式': '9',
  '未來進行式': '10',
  '未來完成式': '11',
  '未來完成進行式': '12',
};
Map<String, String> passiveVoice = {'被動語態': '13'};
Map<String, String> nounClause = {
  'that開頭': '14',
  'if/whether開頭': '15',
  'wh-疑問詞開頭': '16',
};
Map<String, String> adjectiveClause = {
  '修飾人': '17',
  '修飾事物': '18',
  '修飾時間': '19',
  '修飾地點': '20',
  'whose': '21',
};
Map<String, String> adverbClause = {
  '描述時間': '22',
  '描述原因': '23',
  '描述對比': '24',
  '描述條件': '25',
  '描述目的': '26',
  '假設語氣': '27',
  '其它副詞子句': '28',
};
Map<String, String> clauseReduction = {
  '名詞子句減化': '29',
  '形容詞子句減化': '30',
  '副詞子句減化': '31',
  '接續發展': '32',
  '背景說明': '33',
};
Map<String, String> preposition = {
  '單個介片': '34',
  '多個介片': '35',
};
Map<String, String> verbals = {
  '動名詞': '36',
  '不定詞': '37',
};
Map<String, String> questions = {
  'Yes/No問句': '38',
  'Wh-疑問句': '39',
};
Map<String, String> coordinating = {
  '轉折詞': '40',
  '對等連接詞': '41',
};
// 大題下拉選單：用在MultiSelect，必須是List<dynamic>型別
List<String> partCategories = [
  'Part 1',
  'Part 2',
  'Part 3',
  'Part 4',
  'Part 5',
  'Part 6',
  'Part 7',
];
