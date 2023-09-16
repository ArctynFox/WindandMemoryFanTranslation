#==============================================================================
# ■ RGSS3 アイテム合成 ver 1.04
#------------------------------------------------------------------------------
# 　配布元:
#     白の魔 http://izumiwhite.web.fc2.com/
#
# 　利用規約:
#     RPGツクールVX Aceの正規の登録者のみご利用になれます。
#     利用報告・著作権表示とかは必要ありません。
#     改造もご自由にどうぞ。
#     何か問題が発生しても責任は持ちません。
#==============================================================================


#--------------------------------------------------------------------------
# ★ 初期設定。
#    合成レシピ等の設定
#--------------------------------------------------------------------------
module WD_itemsynthesis_ini
  
  Cost_view =  false #費用(Ｇ)の表示(合成の費用が全て0Gの場合はfalseを推奨)
  
  Category_i = false #カテゴリウィンドウに「アイテム」の項目を表示
  Category_w = true #カテゴリウィンドウに「武器」の項目を表示
  Category_a = false #カテゴリウィンドウに「防具」の項目を表示
  Category_k = false #カテゴリウィンドウに「大事なもの」の項目を表示
  
  I_recipe = [] #この行は削除しないこと
  W_recipe = [] #この行は削除しないこと
  A_recipe = [] #この行は削除しないこと
  
  #以下、合成レシピ。
  #例: I_recipe[3]  = [100, ["I",1,1], ["W",2,1], ["A",2,2], ["A",3,1]]
  #と記載した場合、ID3のアイテムの合成必要は、100Ｇ。
  #必要な素材は、ID1のアイテム1個、ID2の武器1個、ID2の防具2個、ID3の防具1個
  #となる。
  
  #アイテムの合成レシピ
  I_recipe[0]  = [0,  ["I",0,0]]

  #武器の合成レシピ
  W_recipe[102]  = [0, ["I",26,1],["W",101,1]] #騎士の剣
  W_recipe[103]  = [0, ["I",26,3],["W",102,1]]
  W_recipe[104]  = [0, ["I",26,5],["W",103,1]]
  W_recipe[105]  = [0, ["I",27,1],["W",104,1]]
  W_recipe[106]  = [0, ["I",27,3],["W",105,1]]
  W_recipe[107]  = [0, ["I",27,5],["W",106,1]]
  W_recipe[108]  = [0, ["I",28,1],["W",107,1]]
  W_recipe[109]  = [0, ["I",28,3],["W",108,1]]
  W_recipe[110]  = [0, ["I",28,5],["W",109,1]]
  W_recipe[111]  = [0, ["I",29,1],["W",110,1]]
  W_recipe[113]  = [0, ["I",26,1],["W",112,1]] #盗賊の短刀
  W_recipe[114]  = [0, ["I",26,3],["W",113,1]]
  W_recipe[115]  = [0, ["I",26,5],["W",114,1]]
  W_recipe[116]  = [0, ["I",27,1],["W",115,1]]
  W_recipe[117]  = [0, ["I",27,3],["W",116,1]]
  W_recipe[118]  = [0, ["I",27,5],["W",117,1]]
  W_recipe[119]  = [0, ["I",28,1],["W",118,1]]
  W_recipe[120]  = [0, ["I",28,3],["W",119,1]]
  W_recipe[121]  = [0, ["I",28,5],["W",120,1]]
  W_recipe[122]  = [0, ["I",29,1],["W",121,1]]
  W_recipe[124]  = [0, ["I",26,1],["W",123,1]] #グレートソード
  W_recipe[125]  = [0, ["I",26,3],["W",124,1]]
  W_recipe[126]  = [0, ["I",26,5],["W",125,1]]
  W_recipe[127]  = [0, ["I",27,1],["W",126,1]]
  W_recipe[128]  = [0, ["I",27,3],["W",127,1]]
  W_recipe[129]  = [0, ["I",27,5],["W",128,1]]
  W_recipe[130]  = [0, ["I",28,1],["W",129,1]]
  W_recipe[131]  = [0, ["I",28,3],["W",130,1]]
  W_recipe[132]  = [0, ["I",28,5],["W",131,1]]
  W_recipe[133]  = [0, ["I",29,1],["W",132,1]]
  W_recipe[135]  = [0, ["I",26,1],["W",134,1]] #魔神刀
  W_recipe[136]  = [0, ["I",26,3],["W",135,1]]
  W_recipe[137]  = [0, ["I",26,5],["W",136,1]]
  W_recipe[138]  = [0, ["I",27,1],["W",137,1]]
  W_recipe[139]  = [0, ["I",27,3],["W",138,1]]
  W_recipe[140]  = [0, ["I",27,5],["W",139,1]]
  W_recipe[141]  = [0, ["I",28,1],["W",140,1]]
  W_recipe[142]  = [0, ["I",28,3],["W",141,1]]
  W_recipe[143]  = [0, ["I",28,5],["W",142,1]]  
  W_recipe[144]  = [0, ["I",29,1],["W",143,1]]   
  W_recipe[146]  = [0, ["I",26,1],["W",145,1]] #パルチザン
  W_recipe[147]  = [0, ["I",26,3],["W",146,1]]
  W_recipe[148]  = [0, ["I",26,5],["W",147,1]]
  W_recipe[149]  = [0, ["I",27,1],["W",148,1]]
  W_recipe[150]  = [0, ["I",27,3],["W",149,1]]
  W_recipe[151]  = [0, ["I",27,5],["W",150,1]]
  W_recipe[152]  = [0, ["I",28,1],["W",151,1]]
  W_recipe[153]  = [0, ["I",28,3],["W",152,1]]
  W_recipe[154]  = [0, ["I",28,5],["W",153,1]]  
  W_recipe[155]  = [0, ["I",29,1],["W",154,1]]     
  W_recipe[157]  = [0, ["I",26,1],["W",156,1]] #クラブ
  W_recipe[158]  = [0, ["I",26,3],["W",157,1]]
  W_recipe[159]  = [0, ["I",26,5],["W",158,1]]
  W_recipe[160]  = [0, ["I",27,1],["W",159,1]]
  W_recipe[161]  = [0, ["I",27,3],["W",160,1]]
  W_recipe[162]  = [0, ["I",27,5],["W",161,1]]
  W_recipe[163]  = [0, ["I",28,1],["W",162,1]]
  W_recipe[164]  = [0, ["I",28,3],["W",163,1]]
  W_recipe[165]  = [0, ["I",28,5],["W",164,1]]  
  W_recipe[166]  = [0, ["I",29,1],["W",165,1]]   
  W_recipe[168]  = [0, ["I",26,1],["W",167,1]] #魔術師の杖
  W_recipe[169]  = [0, ["I",26,3],["W",168,1]]
  W_recipe[170]  = [0, ["I",26,5],["W",169,1]]
  W_recipe[171]  = [0, ["I",27,1],["W",170,1]]
  W_recipe[172]  = [0, ["I",27,3],["W",171,1]]
  W_recipe[173]  = [0, ["I",27,5],["W",172,1]]
  W_recipe[174]  = [0, ["I",28,1],["W",173,1]]
  W_recipe[175]  = [0, ["I",28,3],["W",174,1]]
  W_recipe[176]  = [0, ["I",28,5],["W",175,1]]  
  W_recipe[177]  = [0, ["I",29,1],["W",176,1]]   
  W_recipe[179]  = [0, ["I",26,1],["W",178,1]] #ハンターボウ
  W_recipe[180]  = [0, ["I",26,3],["W",179,1]]
  W_recipe[181]  = [0, ["I",26,5],["W",180,1]]
  W_recipe[182]  = [0, ["I",27,1],["W",181,1]]
  W_recipe[183]  = [0, ["I",27,3],["W",182,1]]
  W_recipe[184]  = [0, ["I",27,5],["W",183,1]]
  W_recipe[185]  = [0, ["I",28,1],["W",184,1]]
  W_recipe[186]  = [0, ["I",28,3],["W",185,1]]
  W_recipe[187]  = [0, ["I",28,5],["W",186,1]]  
  W_recipe[188]  = [0, ["I",29,1],["W",187,1]]     
  W_recipe[190]  = [0, ["I",26,1],["W",189,1]] #肉断ち大斧
  W_recipe[191]  = [0, ["I",26,3],["W",190,1]]
  W_recipe[192]  = [0, ["I",26,5],["W",191,1]]
  W_recipe[193]  = [0, ["I",27,1],["W",192,1]]
  W_recipe[194]  = [0, ["I",27,3],["W",193,1]]
  W_recipe[195]  = [0, ["I",27,5],["W",194,1]]
  W_recipe[196]  = [0, ["I",28,1],["W",195,1]]
  W_recipe[197]  = [0, ["I",28,3],["W",196,1]]
  W_recipe[198]  = [0, ["I",28,5],["W",197,1]]  
  W_recipe[199]  = [0, ["I",29,1],["W",198,1]] 
  W_recipe[201]  = [0, ["I",26,1],["W",200,1]] #メイス
  W_recipe[202]  = [0, ["I",26,3],["W",201,1]]
  W_recipe[203]  = [0, ["I",26,5],["W",202,1]]
  W_recipe[204]  = [0, ["I",27,1],["W",203,1]]
  W_recipe[205]  = [0, ["I",27,3],["W",204,1]]
  W_recipe[206]  = [0, ["I",27,5],["W",205,1]]
  W_recipe[207]  = [0, ["I",28,1],["W",206,1]]
  W_recipe[208]  = [0, ["I",28,3],["W",207,1]]
  W_recipe[209]  = [0, ["I",28,5],["W",208,1]]  
  W_recipe[210]  = [0, ["I",29,1],["W",209,1]]      
  W_recipe[212]  = [0, ["I",26,1],["W",211,1]] #ハルバード
  W_recipe[213]  = [0, ["I",26,3],["W",212,1]]
  W_recipe[214]  = [0, ["I",26,5],["W",213,1]]
  W_recipe[215]  = [0, ["I",27,1],["W",214,1]]
  W_recipe[216]  = [0, ["I",27,3],["W",215,1]]
  W_recipe[217]  = [0, ["I",27,5],["W",216,1]]
  W_recipe[218]  = [0, ["I",28,1],["W",217,1]]
  W_recipe[219]  = [0, ["I",28,3],["W",218,1]]
  W_recipe[220]  = [0, ["I",28,5],["W",219,1]]  
  W_recipe[221]  = [0, ["I",29,1],["W",220,1]]      
  W_recipe[223]  = [0, ["I",26,1],["W",222,1]] #獣狩りのノコギリ
  W_recipe[224]  = [0, ["I",26,3],["W",223,1]]
  W_recipe[225]  = [0, ["I",26,5],["W",224,1]]
  W_recipe[226]  = [0, ["I",27,1],["W",225,1]]
  W_recipe[227]  = [0, ["I",27,3],["W",226,1]]
  W_recipe[228]  = [0, ["I",27,5],["W",227,1]]
  W_recipe[229]  = [0, ["I",28,1],["W",228,1]]
  W_recipe[230]  = [0, ["I",28,3],["W",229,1]]
  W_recipe[231]  = [0, ["I",28,5],["W",230,1]]  
  W_recipe[232]  = [0, ["I",29,1],["W",231,1]]      
  W_recipe[234]  = [0, ["I",26,1],["W",233,1]] #シールドバンカー
  W_recipe[235]  = [0, ["I",26,3],["W",234,1]]
  W_recipe[236]  = [0, ["I",26,5],["W",235,1]]
  W_recipe[237]  = [0, ["I",27,1],["W",236,1]]
  W_recipe[238]  = [0, ["I",27,3],["W",237,1]]
  W_recipe[239]  = [0, ["I",27,5],["W",238,1]]
  W_recipe[240]  = [0, ["I",28,1],["W",239,1]]
  W_recipe[241]  = [0, ["I",28,3],["W",240,1]]
  W_recipe[242]  = [0, ["I",28,5],["W",241,1]]  
  W_recipe[243]  = [0, ["I",29,1],["W",242,1]]          
  W_recipe[245]  = [0, ["I",26,1],["W",244,1]] #ブラックソード
  W_recipe[246]  = [0, ["I",26,3],["W",245,1]]
  W_recipe[247]  = [0, ["I",26,5],["W",246,1]]
  W_recipe[248]  = [0, ["I",27,1],["W",247,1]]
  W_recipe[249]  = [0, ["I",27,3],["W",248,1]]
  W_recipe[250]  = [0, ["I",27,5],["W",249,1]]
  W_recipe[251]  = [0, ["I",28,1],["W",250,1]]
  W_recipe[252]  = [0, ["I",28,3],["W",251,1]]
  W_recipe[253]  = [0, ["I",28,5],["W",252,1]]  
  W_recipe[254]  = [0, ["I",29,1],["W",253,1]]   
  W_recipe[256]  = [0, ["I",21,1],["W",255,1]] #折れた剣
  W_recipe[257]  = [0, ["I",21,2],["W",256,1]]
  W_recipe[258]  = [0, ["I",21,3],["W",257,1]]
  W_recipe[259]  = [0, ["I",21,4],["W",258,1]]
  W_recipe[260]  = [0, ["I",21,5],["W",259,1]]
  W_recipe[261]  = [0, ["I",21,6],["W",260,1]]
  W_recipe[262]  = [0, ["I",21,7],["W",261,1]]
  W_recipe[263]  = [0, ["I",21,8],["W",262,1]]
  W_recipe[264]  = [0, ["I",21,9],["W",263,1]]  
  W_recipe[265]  = [0, ["I",21,10],["W",264,1]]  
  W_recipe[267]  = [0, ["I",26,1],["W",266,1]] #ウォーハンマー
  W_recipe[268]  = [0, ["I",26,3],["W",267,1]]
  W_recipe[269]  = [0, ["I",26,5],["W",268,1]]
  W_recipe[270]  = [0, ["I",27,1],["W",269,1]]
  W_recipe[271]  = [0, ["I",27,3],["W",270,1]]
  W_recipe[272]  = [0, ["I",27,5],["W",271,1]]
  W_recipe[273]  = [0, ["I",28,1],["W",272,1]]
  W_recipe[274]  = [0, ["I",28,3],["W",273,1]]
  W_recipe[275]  = [0, ["I",28,5],["W",274,1]]  
  W_recipe[276]  = [0, ["I",29,1],["W",275,1]] 
  W_recipe[278]  = [0, ["I",26,1],["W",277,1]] #メリケン
  W_recipe[279]  = [0, ["I",26,3],["W",278,1]]
  W_recipe[280]  = [0, ["I",26,5],["W",279,1]]
  W_recipe[281]  = [0, ["I",27,1],["W",280,1]]
  W_recipe[282]  = [0, ["I",27,3],["W",281,1]]
  W_recipe[283]  = [0, ["I",27,5],["W",282,1]]
  W_recipe[284]  = [0, ["I",28,1],["W",283,1]]
  W_recipe[285]  = [0, ["I",28,3],["W",284,1]]
  W_recipe[286]  = [0, ["I",28,5],["W",285,1]]  
  W_recipe[287]  = [0, ["I",29,1],["W",286,1]] 
  W_recipe[289]  = [0, ["I",26,1],["W",288,1]] #ヴォーパルの刃
  W_recipe[290]  = [0, ["I",26,3],["W",289,1]]
  W_recipe[291]  = [0, ["I",26,5],["W",290,1]]
  W_recipe[292]  = [0, ["I",27,1],["W",291,1]]
  W_recipe[293]  = [0, ["I",27,3],["W",292,1]]
  W_recipe[294]  = [0, ["I",27,5],["W",293,1]]
  W_recipe[295]  = [0, ["I",28,1],["W",294,1]]
  W_recipe[296]  = [0, ["I",28,3],["W",295,1]]
  W_recipe[297]  = [0, ["I",28,5],["W",296,1]]  
  W_recipe[298]  = [0, ["I",29,1],["W",297,1]] 
  W_recipe[356]  = [0, ["I",25,1],["W",355,1]] #大鉄球
  W_recipe[357]  = [0, ["I",25,1],["W",356,1]]
  W_recipe[358]  = [0, ["I",25,1],["W",357,1]]
  W_recipe[359]  = [0, ["I",25,1],["W",358,1]]
  W_recipe[360]  = [0, ["I",25,1],["W",359,1]]
  W_recipe[362]  = [0, ["I",25,1],["W",361,1]] #ハンスの機関銃
  W_recipe[363]  = [0, ["I",25,1],["W",362,1]]
  W_recipe[364]  = [0, ["I",25,1],["W",363,1]]
  W_recipe[365]  = [0, ["I",25,1],["W",364,1]]
  W_recipe[366]  = [0, ["I",25,1],["W",365,1]]
  W_recipe[368]  = [0, ["I",25,1],["W",367,1]] #審判者の大鎌
  W_recipe[369]  = [0, ["I",25,1],["W",368,1]]
  W_recipe[370]  = [0, ["I",25,1],["W",369,1]]
  W_recipe[371]  = [0, ["I",25,1],["W",370,1]]
  W_recipe[372]  = [0, ["I",25,1],["W",371,1]]
  W_recipe[374]  = [0, ["I",25,1],["W",373,1]] #ストームルーラー
  W_recipe[375]  = [0, ["I",25,1],["W",374,1]]
  W_recipe[376]  = [0, ["I",25,1],["W",375,1]]
  W_recipe[377]  = [0, ["I",25,1],["W",376,1]]
  W_recipe[378]  = [0, ["I",25,1],["W",377,1]]
  W_recipe[380]  = [0, ["I",25,1],["W",379,1]] #アンドールの剣
  W_recipe[381]  = [0, ["I",25,1],["W",380,1]]
  W_recipe[382]  = [0, ["I",25,1],["W",381,1]]
  W_recipe[383]  = [0, ["I",25,1],["W",382,1]]
  W_recipe[384]  = [0, ["I",25,1],["W",383,1]]
  W_recipe[386]  = [0, ["I",25,1],["W",385,1]] #飛龍の剣
  W_recipe[387]  = [0, ["I",25,1],["W",386,1]]
  W_recipe[388]  = [0, ["I",25,1],["W",387,1]]
  W_recipe[389]  = [0, ["I",25,1],["W",388,1]]
  W_recipe[390]  = [0, ["I",25,1],["W",389,1]]
  W_recipe[392]  = [0, ["I",25,1],["W",391,1]] #デーモンの杖
  W_recipe[393]  = [0, ["I",25,1],["W",392,1]]
  W_recipe[394]  = [0, ["I",25,1],["W",393,1]]
  W_recipe[395]  = [0, ["I",25,1],["W",394,1]]
  W_recipe[396]  = [0, ["I",25,1],["W",395,1]]
  W_recipe[398]  = [0, ["I",25,1],["W",397,1]] #月光の大剣
  W_recipe[399]  = [0, ["I",25,1],["W",398,1]]
  W_recipe[400]  = [0, ["I",25,1],["W",399,1]]
  W_recipe[401]  = [0, ["I",25,1],["W",400,1]]
  W_recipe[402]  = [0, ["I",25,1],["W",401,1]]
  W_recipe[404]  = [0, ["I",25,1],["W",403,1]] #暴剣バンダースナッチ
  W_recipe[405]  = [0, ["I",25,1],["W",404,1]]
  W_recipe[406]  = [0, ["I",25,1],["W",405,1]]
  W_recipe[407]  = [0, ["I",25,1],["W",406,1]]
  W_recipe[408]  = [0, ["I",25,1],["W",407,1]]
  W_recipe[410]  = [0, ["I",25,1],["W",409,1]] #腐鎌ジャバウォック
  W_recipe[411]  = [0, ["I",25,1],["W",410,1]]
  W_recipe[412]  = [0, ["I",25,1],["W",411,1]]
  W_recipe[413]  = [0, ["I",25,1],["W",412,1]]
  W_recipe[414]  = [0, ["I",25,1],["W",413,1]]
  W_recipe[416]  = [0, ["I",25,1],["W",415,1]] #狂弓ジャブジャブ
  W_recipe[417]  = [0, ["I",25,1],["W",416,1]]
  W_recipe[418]  = [0, ["I",25,1],["W",417,1]]
  W_recipe[419]  = [0, ["I",25,1],["W",418,1]]
  W_recipe[420]  = [0, ["I",25,1],["W",419,1]]
  W_recipe[422]  = [0, ["I",25,1],["W",421,1]] #ミランダ斧
  W_recipe[423]  = [0, ["I",25,1],["W",422,1]]
  W_recipe[424]  = [0, ["I",25,1],["W",423,1]]
  W_recipe[425]  = [0, ["I",25,1],["W",424,1]]
  W_recipe[426]  = [0, ["I",25,1],["W",425,1]]
  W_recipe[300]  = [0, ["I",26,1],["W",299,1]] #打刀
  W_recipe[301]  = [0, ["I",26,3],["W",300,1]]
  W_recipe[302]  = [0, ["I",26,5],["W",301,1]]
  W_recipe[303]  = [0, ["I",27,1],["W",302,1]]
  W_recipe[304]  = [0, ["I",27,3],["W",303,1]]
  W_recipe[305]  = [0, ["I",27,5],["W",304,1]]
  W_recipe[306]  = [0, ["I",28,1],["W",305,1]]
  W_recipe[307]  = [0, ["I",28,3],["W",306,1]]
  W_recipe[308]  = [0, ["I",28,5],["W",307,1]]  
  W_recipe[309]  = [0, ["I",29,1],["W",308,1]] 
  W_recipe[428]  = [0, ["I",25,1],["W",427,1]] #ルルイエ杖
  W_recipe[429]  = [0, ["I",25,1],["W",428,1]]
  W_recipe[430]  = [0, ["I",25,1],["W",429,1]]
  W_recipe[431]  = [0, ["I",25,1],["W",430,1]]
  W_recipe[432]  = [0, ["I",25,1],["W",431,1]]
  W_recipe[434]  = [0, ["I",25,1],["W",433,1]] #深海騎士の錨
  W_recipe[435]  = [0, ["I",25,1],["W",434,1]]
  W_recipe[436]  = [0, ["I",25,1],["W",435,1]]
  W_recipe[437]  = [0, ["I",25,1],["W",436,1]]
  W_recipe[438]  = [0, ["I",25,1],["W",437,1]]
  W_recipe[440]  = [0, ["I",25,1],["W",439,1]] #ロストソード
  W_recipe[441]  = [0, ["I",25,1],["W",440,1]]
  W_recipe[442]  = [0, ["I",25,1],["W",441,1]]
  W_recipe[443]  = [0, ["I",25,1],["W",442,1]]
  W_recipe[444]  = [0, ["I",25,1],["W",443,1]]
  W_recipe[446]  = [0, ["I",25,1],["W",445,1]] #グラキード
  W_recipe[447]  = [0, ["I",25,1],["W",446,1]]
  W_recipe[448]  = [0, ["I",25,1],["W",447,1]]
  W_recipe[449]  = [0, ["I",25,1],["W",448,1]]
  W_recipe[450]  = [0, ["I",25,1],["W",449,1]]
  W_recipe[452]  = [0, ["I",25,1],["W",451,1]] #チェーンソー
  W_recipe[453]  = [0, ["I",25,1],["W",452,1]]
  W_recipe[454]  = [0, ["I",25,1],["W",453,1]]
  W_recipe[455]  = [0, ["I",25,1],["W",454,1]]
  W_recipe[456]  = [0, ["I",25,1],["W",455,1]]
  W_recipe[458]  = [0, ["I",25,1],["W",457,1]] #ウミガメモドキのおたま
  W_recipe[459]  = [0, ["I",25,1],["W",458,1]]
  W_recipe[460]  = [0, ["I",25,1],["W",459,1]]
  W_recipe[461]  = [0, ["I",25,1],["W",460,1]]
  W_recipe[462]  = [0, ["I",25,1],["W",461,1]]
  W_recipe[312]  = [0, ["I",26,1],["W",311,1]] #クレイモア
  W_recipe[313]  = [0, ["I",26,3],["W",312,1]]
  W_recipe[314]  = [0, ["I",26,5],["W",313,1]]
  W_recipe[315]  = [0, ["I",27,1],["W",314,1]]
  W_recipe[316]  = [0, ["I",27,3],["W",315,1]]
  W_recipe[317]  = [0, ["I",27,5],["W",316,1]]
  W_recipe[318]  = [0, ["I",28,1],["W",317,1]]
  W_recipe[319]  = [0, ["I",28,3],["W",318,1]]
  W_recipe[320]  = [0, ["I",28,5],["W",319,1]]  
  W_recipe[321]  = [0, ["I",29,1],["W",320,1]] 
  W_recipe[464]  = [0, ["I",25,1],["W",463,1]] #ゴッドアンジェル
  W_recipe[465]  = [0, ["I",25,1],["W",464,1]]
  W_recipe[466]  = [0, ["I",25,1],["W",465,1]]
  W_recipe[467]  = [0, ["I",25,1],["W",466,1]]
  W_recipe[468]  = [0, ["I",25,1],["W",467,1]]
  W_recipe[470]  = [0, ["I",25,1],["W",469,1]] #聖なる銃剣
  W_recipe[471]  = [0, ["I",25,1],["W",470,1]]
  W_recipe[472]  = [0, ["I",25,1],["W",471,1]]
  W_recipe[473]  = [0, ["I",25,1],["W",472,1]]
  W_recipe[474]  = [0, ["I",25,1],["W",473,1]]
  W_recipe[477]  = [0, ["I",25,1],["W",476,1]] #ユニス
  W_recipe[478]  = [0, ["I",25,1],["W",477,1]]
  W_recipe[479]  = [0, ["I",25,1],["W",478,1]]
  W_recipe[480]  = [0, ["I",25,1],["W",479,1]]
  W_recipe[481]  = [0, ["I",25,1],["W",480,1]]
  W_recipe[483]  = [0, ["I",25,1],["W",482,1]] #ライデン
  W_recipe[484]  = [0, ["I",25,1],["W",483,1]]
  W_recipe[485]  = [0, ["I",25,1],["W",484,1]]
  W_recipe[486]  = [0, ["I",25,1],["W",485,1]]
  W_recipe[487]  = [0, ["I",25,1],["W",486,1]]
  W_recipe[517]  = [0, ["I",26,1],["W",516,1]] #草叉
  W_recipe[518]  = [0, ["I",26,3],["W",517,1]]
  W_recipe[519]  = [0, ["I",26,5],["W",518,1]]
  W_recipe[520]  = [0, ["I",27,1],["W",519,1]]
  W_recipe[521]  = [0, ["I",27,3],["W",520,1]]
  W_recipe[522]  = [0, ["I",27,5],["W",521,1]]
  W_recipe[523]  = [0, ["I",28,1],["W",522,1]]
  W_recipe[524]  = [0, ["I",28,3],["W",523,1]]
  W_recipe[525]  = [0, ["I",28,5],["W",524,1]]  
  W_recipe[526]  = [0, ["I",29,1],["W",525,1]]
  W_recipe[500]  = [0, ["I",26,1],["W",499,1]] #连射弩
  W_recipe[501]  = [0, ["I",26,3],["W",500,1]]
  W_recipe[502]  = [0, ["I",26,5],["W",501,1]]
  W_recipe[503]  = [0, ["I",27,1],["W",502,1]]
  W_recipe[504]  = [0, ["I",27,3],["W",503,1]]
  W_recipe[505]  = [0, ["I",27,5],["W",504,1]]
  W_recipe[506]  = [0, ["I",28,1],["W",505,1]]
  W_recipe[507]  = [0, ["I",28,3],["W",506,1]]
  W_recipe[508]  = [0, ["I",28,5],["W",507,1]]  
  W_recipe[509]  = [0, ["I",29,1],["W",508,1]]
  W_recipe[511]  = [0, ["I",25,1],["W",510,1]] #鸦羽
  W_recipe[512]  = [0, ["I",25,1],["W",511,1]]
  W_recipe[513]  = [0, ["I",25,1],["W",512,1]]
  W_recipe[514]  = [0, ["I",25,1],["W",513,1]]
  W_recipe[515]  = [0, ["I",25,1],["W",514,1]]
  W_recipe[528]  = [0, ["I",26,1],["W",527,1]] #骑枪
  W_recipe[529]  = [0, ["I",26,3],["W",528,1]]
  W_recipe[530]  = [0, ["I",26,5],["W",529,1]]
  W_recipe[531]  = [0, ["I",27,1],["W",530,1]]
  W_recipe[532]  = [0, ["I",27,3],["W",531,1]]
  W_recipe[533]  = [0, ["I",27,5],["W",532,1]]
  W_recipe[534]  = [0, ["I",28,1],["W",533,1]]
  W_recipe[535]  = [0, ["I",28,3],["W",534,1]]
  W_recipe[536]  = [0, ["I",28,5],["W",535,1]]  
  W_recipe[537]  = [0, ["I",29,1],["W",536,1]]
  W_recipe[539]  = [0, ["I",25,1],["W",538,1]] #血棘
  W_recipe[540]  = [0, ["I",25,1],["W",539,1]]
  W_recipe[541]  = [0, ["I",25,1],["W",540,1]]
  W_recipe[542]  = [0, ["I",25,1],["W",541,1]]
  W_recipe[543]  = [0, ["I",25,1],["W",542,1]]
  #防具の合成レシピ  
  A_recipe[0]  = [0,   ["I",0,0]]
  
end


#==============================================================================
# ■ WD_itemsynthesis
#------------------------------------------------------------------------------
# 　アイテム合成用の共通メソッドです。
#==============================================================================

module WD_itemsynthesis
  def i_recipe_switch_on(id)
    $game_system.i_rcp_sw = [] if $game_system.i_rcp_sw == nil
    $game_system.i_rcp_sw[id] = false if $game_system.i_rcp_sw[id] == nil
    $game_system.i_rcp_sw[id] = true
  end
  def i_recipe_switch_off(id)
    $game_system.i_rcp_sw = [] if $game_system.i_rcp_sw == nil
    $game_system.i_rcp_sw[id] = false if $game_system.i_rcp_sw[id] == nil
    $game_system.i_rcp_sw[id] = false
  end
  def i_recipe_switch_on?(id)
    $game_system.i_rcp_sw = [] if $game_system.i_rcp_sw == nil
    $game_system.i_rcp_sw[id] = false if $game_system.i_rcp_sw[id] == nil
    return $game_system.i_rcp_sw[id]
  end
  def i_recipe_all_switch_on
    for i in 1..$data_items.size
      i_recipe_switch_on(i)
    end
  end
  def i_recipe_all_switch_off
    for i in 1..$data_items.size
      i_recipe_switch_off(i)
    end
  end
  def w_recipe_switch_on(id)
    $game_system.w_rcp_sw = [] if $game_system.w_rcp_sw == nil
    $game_system.w_rcp_sw[id] = false if $game_system.w_rcp_sw[id] == nil
    $game_system.w_rcp_sw[id] = true
  end
  def w_recipe_switch_off(id)
    $game_system.w_rcp_sw = [] if $game_system.w_rcp_sw == nil
    $game_system.w_rcp_sw[id] = false if $game_system.w_rcp_sw[id] == nil
    $game_system.w_rcp_sw[id] = false
  end
  def w_recipe_switch_on?(id)
    $game_system.w_rcp_sw = [] if $game_system.w_rcp_sw == nil
    $game_system.w_rcp_sw[id] = false if $game_system.w_rcp_sw[id] == nil
    return $game_system.w_rcp_sw[id]
  end
  def w_recipe_all_switch_on
    for i in 1..$data_weapons.size
      w_recipe_switch_on(i)
    end
  end
  def w_recipe_all_switch_off
    for i in 1..$data_weapons.size
      w_recipe_switch_off(i)
    end
  end
  def a_recipe_switch_on(id)
    $game_system.a_rcp_sw = [] if $game_system.a_rcp_sw == nil
    $game_system.a_rcp_sw[id] = false if $game_system.a_rcp_sw[id] == nil
    $game_system.a_rcp_sw[id] = true
  end
  def a_recipe_switch_off(id)
    $game_system.a_rcp_sw = [] if $game_system.a_rcp_sw == nil
    $game_system.a_rcp_sw[id] = false if $game_system.a_rcp_sw[id] == nil
    $game_system.a_rcp_sw[id] = false
  end
  def a_recipe_switch_on?(id)
    $game_system.a_rcp_sw = [] if $game_system.a_rcp_sw == nil
    $game_system.a_rcp_sw[id] = false if $game_system.a_rcp_sw[id] == nil
    return $game_system.a_rcp_sw[id]
  end
  def a_recipe_all_switch_on
    for i in 1..$data_armors.size
      a_recipe_switch_on(i)
    end
  end
  def a_recipe_all_switch_off
    for i in 1..$data_armors.size
      a_recipe_switch_off(i)
    end
  end
  def recipe_all_switch_on
    i_recipe_all_switch_on
    w_recipe_all_switch_on
    a_recipe_all_switch_on
  end
  def recipe_all_switch_off
    i_recipe_all_switch_off
    w_recipe_all_switch_off
    a_recipe_all_switch_off
  end

end

class Game_Interpreter
  include WD_itemsynthesis
end

class Game_System
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :i_rcp_sw
  attr_accessor :w_rcp_sw
  attr_accessor :a_rcp_sw
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias wd_orig_initialize004 initialize
  def initialize
    wd_orig_initialize004
    @i_rcp_sw = []
    @w_rcp_sw = []
    @a_rcp_sw = []
  end
end


#==============================================================================
# ■ Scene_ItemSynthesis
#------------------------------------------------------------------------------
# 　合成画面の処理を行うクラスです。
#==============================================================================

class Scene_ItemSynthesis < Scene_MenuBase
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_dummy_window
    create_number_window
    create_status_window
    create_material_window
    create_list_window
    create_category_window
    create_gold_window
    create_change_window
  end
  #--------------------------------------------------------------------------
  # ● ゴールドウィンドウの作成
  #--------------------------------------------------------------------------
  def create_gold_window
    @gold_window = Window_Gold.new
    @gold_window.viewport = @viewport
    @gold_window.x = Graphics.width - @gold_window.width
    @gold_window.y = @help_window.height
    @gold_window.hide
  end
  #--------------------------------------------------------------------------
  # ● 切り替え表示ウィンドウの作成
  #--------------------------------------------------------------------------
  def create_change_window
    wx = 0
    wy = @gold_window.y
    ww = Graphics.width - @gold_window.width
    wh = @gold_window.height
    @change_window = Window_ItemSynthesisChange.new(wx, wy, ww, wh)
    @change_window.viewport = @viewport
    @change_window.hide
  end
  #--------------------------------------------------------------------------
  # ● ダミーウィンドウの作成
  #--------------------------------------------------------------------------
  def create_dummy_window
    wy = @help_window.y + @help_window.height + 48
    wh = Graphics.height - wy
    @dummy_window = Window_Base.new(0, wy, Graphics.width, wh)
    @dummy_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # ● 個数入力ウィンドウの作成
  #--------------------------------------------------------------------------
  def create_number_window
    wy = @dummy_window.y
    wh = @dummy_window.height
    @number_window = Window_ItemSynthesisNumber.new(0, wy, wh)
    @number_window.viewport = @viewport
    @number_window.hide
    @number_window.set_handler(:ok,     method(:on_number_ok))
    @number_window.set_handler(:cancel, method(:on_number_cancel))
    @number_window.set_handler(:change_window, method(:on_change_window))    
  end
  #--------------------------------------------------------------------------
  # ● ステータスウィンドウの作成
  #--------------------------------------------------------------------------
  def create_status_window
    wx = @number_window.width
    wy = @dummy_window.y
    ww = Graphics.width - wx
    wh = @dummy_window.height
    @status_window = Window_ShopStatus.new(wx, wy, ww, wh)
    @status_window.viewport = @viewport
    @status_window.hide
  end
  #--------------------------------------------------------------------------
  # ● 素材ウィンドウの作成
  #--------------------------------------------------------------------------
  def create_material_window
    wx = @number_window.width
    wy = @dummy_window.y
    ww = Graphics.width - wx
    wh = @dummy_window.height
    @material_window = Window_ItemSynthesisMaterial.new(wx, wy, ww, wh)
    @material_window.viewport = @viewport
    @material_window.hide
    @number_window.material_window = @material_window
  end
  #--------------------------------------------------------------------------
  # ● 合成アイテムリストウィンドウの作成
  #--------------------------------------------------------------------------
  def create_list_window
    wy = @dummy_window.y
    wh = @dummy_window.height
    @list_window = Window_ItemSynthesisList.new(0, wy, wh)
    @list_window.viewport = @viewport
    @list_window.help_window = @help_window
    @list_window.status_window = @status_window
    @list_window.material_window = @material_window
    @list_window.hide
    @list_window.set_handler(:ok,     method(:on_list_ok))
    @list_window.set_handler(:cancel, method(:on_list_cancel))
    @list_window.set_handler(:change_window, method(:on_change_window))    
  end
  #--------------------------------------------------------------------------
  # ● カテゴリウィンドウの作成
  #--------------------------------------------------------------------------
  def create_category_window
    @category_window = Window_ItemSynthesisCategory.new
    @category_window.viewport = @viewport
    @category_window.help_window = @help_window
    @category_window.y = @help_window.height
    @category_window.activate
    @category_window.item_window = @list_window
    @category_window.set_handler(:ok,     method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # ● 合成アイテムリストウィンドウのアクティブ化
  #--------------------------------------------------------------------------
  def activate_list_window
    @list_window.money = money
    @list_window.show.activate
  end
  #--------------------------------------------------------------------------
  # ● 合成［決定］
  #--------------------------------------------------------------------------
  def on_list_ok
    @item = @list_window.item
    @list_window.hide
    @number_window.set(@item, max_buy, buying_price, currency_unit)
    @number_window.show.activate
  end
  #--------------------------------------------------------------------------
  # ● 合成［キャンセル］
  #--------------------------------------------------------------------------
  def on_list_cancel
    @category_window.activate
    @category_window.show
    @dummy_window.show
    @list_window.hide
    @status_window.hide
    @status_window.item = nil
    @material_window.hide
    @material_window.set(nil, nil)
    @gold_window.hide
    @change_window.hide
    @help_window.clear
  end
  #--------------------------------------------------------------------------
  # ● 表示切替
  #--------------------------------------------------------------------------
  def on_change_window
    if @status_window.visible
      @status_window.hide
      @material_window.show
    else
      @status_window.show
      @material_window.hide
    end
  end
  #--------------------------------------------------------------------------
  # ● カテゴリ［決定］
  #--------------------------------------------------------------------------
  def on_category_ok
    activate_list_window
    @gold_window.show
    @change_window.show
    @material_window.show
    @category_window.hide
    @list_window.select(0)
  end
  #--------------------------------------------------------------------------
  # ● 個数入力［決定］
  #--------------------------------------------------------------------------
  def on_number_ok
    Sound.play_shop
    do_syntetic(@number_window.number)
    end_number_input
    @gold_window.refresh
  end
  #--------------------------------------------------------------------------
  # ● 個数入力［キャンセル］
  #--------------------------------------------------------------------------
  def on_number_cancel
    Sound.play_cancel
    end_number_input
  end
  #--------------------------------------------------------------------------
  # ● 合成の実行
  #--------------------------------------------------------------------------
  def do_syntetic(number)
    $game_party.lose_gold(number * buying_price)
    $game_party.gain_item(@item, number)
    
      @recipe = @list_window.recipe(@item)
      for i in 1...@recipe.size
        kind = @recipe[i][0]
        id   = @recipe[i][1]
        num  = @recipe[i][2]
        if kind == "I"
          item = $data_items[id]
        elsif kind == "W"
          item = $data_weapons[id]
        elsif kind == "A"
          item = $data_armors[id]
        end
        $game_party.lose_item(item, num*number)
      end
  end
  #--------------------------------------------------------------------------
  # ● 個数入力の終了
  #--------------------------------------------------------------------------
  def end_number_input
    @number_window.hide
    activate_list_window
  end
  #--------------------------------------------------------------------------
  # ● 最大購入可能個数の取得
  #--------------------------------------------------------------------------
  def max_buy
    max = $game_party.max_item_number(@item) - $game_party.item_number(@item)
    
    @recipe = @list_window.recipe(@item)
      for i in 1...@recipe.size
        kind = @recipe[i][0]
        id   = @recipe[i][1]
        num  = @recipe[i][2]
        if kind == "I"
          item = $data_items[id]
        elsif kind == "W"
          item = $data_weapons[id]
        elsif kind == "A"
          item = $data_armors[id]
        end
        if num > 0
          max_buf = $game_party.item_number(item)/num
        else
          max_buf = 999
        end
        max = [max, max_buf].min
      end
      
    buying_price == 0 ? max : [max, money / buying_price].min

  end
  #--------------------------------------------------------------------------
  # ● 所持金の取得
  #--------------------------------------------------------------------------
  def money
    @gold_window.value
  end
  #--------------------------------------------------------------------------
  # ● 通貨単位の取得
  #--------------------------------------------------------------------------
  def currency_unit
    @gold_window.currency_unit
  end
  #--------------------------------------------------------------------------
  # ● 合成費用の取得
  #--------------------------------------------------------------------------
  def buying_price
    @list_window.price(@item)
  end
end


#==============================================================================
# ■ Window_ItemSynthesisList
#------------------------------------------------------------------------------
# 　合成画面で、合成可能なアイテムの一覧を表示するウィンドウです。
#==============================================================================

class Window_ItemSynthesisList < Window_Selectable
  include WD_itemsynthesis
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :status_window            # ステータスウィンドウ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(x, y, height)
    super(x, y, window_width, height)
    
    @shop_goods = []
    @shop_recipes = []
    
    for i in 1..WD_itemsynthesis_ini::I_recipe.size
      recipe = WD_itemsynthesis_ini::I_recipe[i]
      if recipe
        good = [0, i, recipe[0]]
        if i_recipe_switch_on?(i)
          @shop_goods.push(good)
          @shop_recipes.push(recipe)
        end
      end
    end
    for i in 1..WD_itemsynthesis_ini::W_recipe.size
      recipe = WD_itemsynthesis_ini::W_recipe[i]
      if recipe
        good = [1, i, recipe[0]]
        if w_recipe_switch_on?(i)
          @shop_goods.push(good)
          @shop_recipes.push(recipe)
        end
      end
    end
    for i in 1..WD_itemsynthesis_ini::A_recipe.size
      recipe = WD_itemsynthesis_ini::A_recipe[i]
      if recipe
        good = [2, i, recipe[0]]
        if a_recipe_switch_on?(i)
          @shop_goods.push(good)
          @shop_recipes.push(recipe)
        end
      end
    end
    
    @money = 0
    refresh
    select(0)
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    return 304
  end
  #--------------------------------------------------------------------------
  # ● 項目数の取得
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # ● アイテムの取得
  #--------------------------------------------------------------------------
  def item
    @data[index]
  end
  #--------------------------------------------------------------------------
  # ● 所持金の設定
  #--------------------------------------------------------------------------
  def money=(money)
    @money = money
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 選択項目の有効状態を取得
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(@data[index])
  end
  #--------------------------------------------------------------------------
  # ● 合成費用を取得
  #--------------------------------------------------------------------------
  def price(item)
    @price[item]
  end
  #--------------------------------------------------------------------------
  # ● 合成可否を取得
  #--------------------------------------------------------------------------
  def enable?(item)
    @makable[item]
  end
  #--------------------------------------------------------------------------
  # ● レシピを取得
  #--------------------------------------------------------------------------
  def recipe(item)
    @recipe[item]
  end
  #--------------------------------------------------------------------------
  # ● アイテムを許可状態で表示するかどうか
  #--------------------------------------------------------------------------
  def have_mat?(recipe)
    flag = true
    if @money >= recipe[0]
      for i in 1...recipe.size
        kind = recipe[i][0]
        id   = recipe[i][1]
        num  = recipe[i][2]
        if kind == "I"
          item = $data_items[id]
        elsif kind == "W"
          item = $data_weapons[id]
        elsif kind == "A"
          item = $data_armors[id]
        end
        if $game_party.item_number(item) < [num, 1].max
          flag = false
        end
      end
    else
      flag = false
    end
    return flag
  end
  #--------------------------------------------------------------------------
  # ● カテゴリの設定
  #--------------------------------------------------------------------------
  def category=(category)
    return if @category == category
    @category = category
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # ● アイテムをリストに含めるかどうか
  #--------------------------------------------------------------------------
  def include?(item)
    case @category
    when :item
      item.is_a?(RPG::Item) && !item.key_item?
    when :weapon
      item.is_a?(RPG::Weapon)
    when :armor
      item.is_a?(RPG::Armor)
    when :key_item
      item.is_a?(RPG::Item) && item.key_item?
    else
      false
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテムリストの作成
  #--------------------------------------------------------------------------
  def make_item_list
    @data = []
    @price = {}
    @makable = {}
    @recipe = {}
    for i in 0...@shop_goods.size
      goods = @shop_goods[i]
      recipe = @shop_recipes[i]
      case goods[0]
      when 0;  item = $data_items[goods[1]]
      when 1;  item = $data_weapons[goods[1]]
      when 2;  item = $data_armors[goods[1]]
      end
      if item
        if include?(item)
          @data.push(item)
          @price[item] = goods[2]
          @makable[item] = have_mat?(recipe) && $game_party.item_number(item) < $game_party.max_item_number(item) 
          @recipe[item] = recipe
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    draw_item_name(item, rect.x, rect.y, enable?(item))
    rect.width -= 4
    draw_text(rect, price(item), 2)  if WD_itemsynthesis_ini::Cost_view
  end
  #--------------------------------------------------------------------------
  # ● ステータスウィンドウの設定
  #--------------------------------------------------------------------------
  def status_window=(status_window)
    @status_window = status_window
    call_update_help
  end
  #--------------------------------------------------------------------------
  # ● 素材ウィンドウの設定
  #--------------------------------------------------------------------------
  def material_window=(material_window)
    @material_window = material_window
    call_update_help
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item) if @help_window
    @status_window.item = item if @status_window
    @material_window.set(item, recipe(item)) if @material_window
  end
  #--------------------------------------------------------------------------
  # ● Z ボタン（表示切替）が押されたときの処理
  #--------------------------------------------------------------------------
  def process_change_window
    Sound.play_cursor
    Input.update
    call_handler(:change_window)
  end
  #--------------------------------------------------------------------------
  # ● 決定やキャンセルなどのハンドリング処理
  #--------------------------------------------------------------------------
  def process_handling
    super
    if active
      return process_change_window if handle?(:change_window) && Input.trigger?(:Z)
#      return process_change_window if handle?(:change_window) && Input.trigger?(:Z)
    end
  end
end


#==============================================================================
# ■ Window_ItemSynthesisMaterial
#------------------------------------------------------------------------------
# 　合成画面で、合成に必要な素材を表示するウィンドウです。
#==============================================================================

class Window_ItemSynthesisMaterial < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @item = nil
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_possession(4, 0)
    draw_material_info(0, line_height * 2)
  end
  #--------------------------------------------------------------------------
  # ● アイテムの設定
  #--------------------------------------------------------------------------
  def set(item, recipe)
    @item = item
    @recipe = recipe
    @make_number = 1
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 作成個数の設定
  #--------------------------------------------------------------------------
  def set_num(make_number)
    @make_number = make_number
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 所持数の描画
  #--------------------------------------------------------------------------
  def draw_possession(x, y)
    rect = Rect.new(x, y, contents.width - 4 - x, line_height)
    change_color(system_color)
    draw_text(rect, Vocab::Possession)
    change_color(normal_color)
    draw_text(rect, $game_party.item_number(@item), 2)
  end
  #--------------------------------------------------------------------------
  # ● 素材情報の描画
  #--------------------------------------------------------------------------
  def draw_material_info(x, y)
    rect = Rect.new(x, y, contents.width, line_height)
    change_color(system_color)
    contents.font.size = 18
    draw_text(rect, "Required:", 0)
    if @recipe
      for i in 1...@recipe.size
        kind = @recipe[i][0]
        id   = @recipe[i][1]
        num  = @recipe[i][2]
        if kind == "I"
          item = $data_items[id]
        elsif kind == "W"
          item = $data_weapons[id]
        elsif kind == "A"
          item = $data_armors[id]
        end
        rect = Rect.new(x, y + line_height*i, contents.width, line_height)
        enabled = true
        enabled = false if [num*@make_number, 1].max  > $game_party.item_number(item)
        draw_item_name(item, rect.x, rect.y, enabled)
        change_color(normal_color, enabled)
        if num > 0
          draw_text(rect, "#{num*@make_number}/#{$game_party.item_number(item)}", 2)
        end
      end
    end
    change_color(normal_color)
    contents.font.size = 24
  end
end


#==============================================================================
# ■ Window_ItemSynthesisNumber
#------------------------------------------------------------------------------
# 　合成画面で、合成するアイテムの個数を入力するウィンドウです。
#==============================================================================

class Window_ItemSynthesisNumber < Window_ShopNumber
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_item_name(@item, 0, item_y)
    draw_number
    draw_total_price if WD_itemsynthesis_ini::Cost_view
  end
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def material_window=(material_window)
    @material_window = material_window
    call_update_help
  end
  #--------------------------------------------------------------------------
  # ● 作成個数の変更
  #--------------------------------------------------------------------------
  def change_number(amount)
    @number = [[@number + amount, @max].min, 1].max
    call_update_help #追加
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def call_update_help
    @material_window.set_num(@number) if @material_window
  end
  #--------------------------------------------------------------------------
  # ● Z ボタン（表示切替）が押されたときの処理
  #--------------------------------------------------------------------------
  def process_change_window
    Sound.play_cursor
    Input.update
    call_handler(:change_window)
  end
  #--------------------------------------------------------------------------
  # ● 決定やキャンセルなどのハンドリング処理
  #--------------------------------------------------------------------------
  def process_handling
    super
    if active
      return process_change_window if handle?(:change_window) && Input.trigger?(:Z)
#      return process_change_window if handle?(:change_window) && Input.trigger?(:Z)
    end
  end
end


#==============================================================================
# ■ Window_ItemSynthesisCategory
#------------------------------------------------------------------------------
# 　合成画面で、通常アイテムや装備品の分類を選択するウィンドウです。
#==============================================================================

class Window_ItemSynthesisCategory < Window_ItemCategory
  #--------------------------------------------------------------------------
  # ● 桁数の取得
  #--------------------------------------------------------------------------
  def col_max
    i = 0
    i += 1 if WD_itemsynthesis_ini::Category_i
    i += 1 if WD_itemsynthesis_ini::Category_w
    i += 1 if WD_itemsynthesis_ini::Category_a
    i += 1 if WD_itemsynthesis_ini::Category_k
    return i
  end
  #--------------------------------------------------------------------------
  # ● コマンドリストの作成
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::item,     :item)     if WD_itemsynthesis_ini::Category_i
    add_command(Vocab::weapon,   :weapon)   if WD_itemsynthesis_ini::Category_w
    add_command(Vocab::armor,    :armor)    if WD_itemsynthesis_ini::Category_a
    add_command(Vocab::key_item, :key_item) if WD_itemsynthesis_ini::Category_k
  end
end


#==============================================================================
# ■ Window_ItemSynthesisNumber
#------------------------------------------------------------------------------
# 　合成画面で、切替を表示するウィンドウです。
#==============================================================================

class Window_ItemSynthesisChange < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    text = "D: Materials ⇔ Stats Display Swap" #D might need to be replaced with Z, not sure if this corresponds to a button that the mod changed the mapping for
    draw_text(0, 0, contents_width, line_height, text, 1)
  end
end