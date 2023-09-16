# coding: utf-8
#===============================================================================
# ■ [hzm]メモ欄拡張共通部分さん＋ for RGSS3
#-------------------------------------------------------------------------------
#　2014/09/27　Ru/むっくRu
#-------------------------------------------------------------------------------
#  データベースのメモ欄の情報を読み取るための共通処理．
#  メモ欄の各行に特定もフレーズがついたものだけを取得します．
#
#  鳥小屋.txtのメモ欄を使うスクリプト群を使う場合に必須になります．
#  （※スクリプト名の頭に[hzm]が付いているスクリプト）
#-------------------------------------------------------------------------------
# 【注意】
#  「[hzm]メモ欄拡張共通部分 for RGSS3」の機能を内包しています．
#  このスクリプトを導入する場合は，
#  [hzm]メモ欄拡張共通部分 for RGSS3は導入しないでください．
#-------------------------------------------------------------------------------
# 【旧バージョン（[hzm]メモ欄拡張共通部分 for RGSS3）からの仕様変更点】
#  ・メモ欄のヘッダ文字（[hzm]）の他にも複数指定することを可能に
#    指定のメソッドを呼び出すことで，
#    [hzm]以外のヘッダ文字をつけたものを認識させることを可能に．
#    （僕が）派生スクリプトを作りやすくするのが目的．
#
#  ・同一項目の複数記述に正式対応
#    [hzm]属性耐性:炎,50
#    [hzm]属性耐性:水,100
#    みたいに同じ項目を複数書いても使えるようになります．
#    ※注意：別にこのスクリプトに属性耐性の機能があるわけではないです
#
#-------------------------------------------------------------------------------
# 【更新履歴】
# 2014/09/27 キャッシュが存在しない場合に再生成するように変更
# 2012/06/04 バージョンチェック用メソッド名修正
# 2012/06/04 [hzm]メモ欄拡張共通部分 for RGSS3から派生
#-------------------------------------------------------------------------------

#===============================================================================
# ↓ 以下、スクリプト部 ↓
#===============================================================================

# 旧スクリプト導入時にエラー処理を行う
raise "「[hzm]メモ欄拡張共通部分 for RGSS3」が導入されています．\n「[hzm]メモ欄拡張共通部分 for RGSS3」は既に不要なので，\n削除してください．" if defined?(HZM_VXA::Note)

module HZM_VXA
  module Note2
    # ● デフォルトのマークフレーズ
    #    （※変更しないでください）
    DEFAULT_MARK = '[hzm]'
    # ● 「[hzm]メモ欄拡張共通部分 for RGSS3」との互換性を保持するか？
    USE_OLD_STYLE = true
  end
end

module HZM_VXA
  module Note2
    #---------------------------------------------------------------------------
    # ● メモスクリプトのバージョン
    #    .区切りの3つの数字で表現
    #    1桁目：メジャーバージョン（仕様変更＝互換性破たん時に変更）
    #    2桁目：マイナーバージョン（機能追加時に変更）
    #    3桁目：パッチバージョン（不具合修正時に変更）
    #---------------------------------------------------------------------------
    VERSION = '3.0.0'
    #---------------------------------------------------------------------------
    # ● バージョン比較処理
    #---------------------------------------------------------------------------
    def self.check_version?(version_str)
      version     = version2array(VERSION)
      req_version = version2array(version_str)
      # メジャーバージョンが要求と一致するか？
      return false unless version[0] == req_version[0]
      # マイナーバージョンが要求より低くないか？
      return false unless version[1] >= req_version[1]
      true
    end
    #---------------------------------------------------------------------------
    # ● バージョン文字列の分解
    #---------------------------------------------------------------------------
    def self.version2array(version_str)
      version_str.split('.').map{|n| n.to_i}
    end
    #---------------------------------------------------------------------------
    # ● ヘッダマーク配列
    #---------------------------------------------------------------------------
    @header_mark = []
    #---------------------------------------------------------------------------
    # ● ヘッダマークの取得
    #---------------------------------------------------------------------------
    def self.header_mark
      @header_mark
    end
    #---------------------------------------------------------------------------
    # ● ヘッダマークの追加
    #---------------------------------------------------------------------------
    def self.add_header_mark(mark_str)
      @header_mark.push(mark_str) unless @header_mark.include?(mark_str)
    end
    #---------------------------------------------------------------------------
    # ● メモ欄の内容を解析
    #---------------------------------------------------------------------------
    def self.setup
      add_header_mark(DEFAULT_MARK)
      list = [
        $data_actors,
        $data_classes,
        $data_skills,
        $data_items,
        $data_weapons,
        $data_armors,
        $data_enemies,
        $data_states,
        $data_tilesets,
      ]
      list.each do |data|
        data.each do |d|
          d.hzm_vxa_note2_init if d
        end
      end
    end
    #---------------------------------------------------------------------------
    # ■ メモ欄を持つクラスに追加するメソッド類
    #---------------------------------------------------------------------------
    module Utils
      #-------------------------------------------------------------------------
      # ● メモ欄のチェック
      #-------------------------------------------------------------------------
      def hzm_vxa_note2_init
        hzm_vxa_note2_clear
        self.note.split(/\r?\n/).each do |line|
          HZM_VXA::Note2.header_mark.each do |mark|
            next unless line.index(mark) == 0
            l = line.sub!(mark, '')
            if l =~ /^([^\:]+)\:(.+)$/
              hzm_vxa_note2_add(mark, $1, $2)
            else
              hzm_vxa_note2_add(mark, l, '')
            end
          end
        end
      end
      #-------------------------------------------------------------------------
      # ● メモ欄情報の追加
      #-------------------------------------------------------------------------
      def hzm_vxa_note2_add(mark, key, str)
        # 文字列として保存
        @hzm_vxa_note2_str[mark][key] ||= []
        @hzm_vxa_note2_str[mark][key].push(str.to_s)
        # カンマ区切りのデータとして保存
        @hzm_vxa_note2_data[mark][key] ||= []
        data = str.split(/\s*\,\s*/).map do |d|
          if d =~ /^\-?\d+$/
            d.to_i
          elsif d =~ /^\-?\d+\.\d+$/
            d.to_f
          else
            d.to_s
          end
        end
        @hzm_vxa_note2_data[mark][key].push(data)
      end
      #-------------------------------------------------------------------------
      # ● メモ欄情報の削除
      #-------------------------------------------------------------------------
      def hzm_vxa_note2_clear
        @hzm_vxa_note2_str = {}
        @hzm_vxa_note2_data = {}
        HZM_VXA::Note2.header_mark.each do |mark|
          @hzm_vxa_note2_str[mark] = {}
          @hzm_vxa_note2_data[mark] = {}
        end
      end
      #-------------------------------------------------------------------------
      # ● メモ内容取得
      #-------------------------------------------------------------------------
      def hzm_vxa_note2_match(mark, keys)
        hzm_vxa_note2_matches(mark, keys).last
      end
      def hzm_vxa_note2_match_str(mark, keys)
        hzm_vxa_note2_matches_str(mark, keys).last
      end
      def hzm_vxa_note2_matches(mark, keys)
        mark ||= HZM_VXA::Note2::DEFAULT_MARK
        ret = []
        keys.each do |key|
          ret += self.hzm_vxa_note2_data[mark][key] if self.hzm_vxa_note2_data[mark].include?(key)
        end
        ret
      rescue => e
        puts "#{$!} - #{$@}"
      end
      def hzm_vxa_note2_matches_str(mark, keys)
        mark ||= HZM_VXA::Note2::DEFAULT_MARK
        ret = []
        keys.each do |key|
          ret += self.hzm_vxa_note2_str[mark][key] if self.hzm_vxa_note2_str[mark].include?(key)
        end
        ret
      end
      def hzm_vxa_note2_data
        hzm_vxa_note2_init unless @hzm_vxa_note2_data
        @hzm_vxa_note2_data
      end
      def hzm_vxa_note2_str
        hzm_vxa_note2_init unless @hzm_vxa_note2_str
        @hzm_vxa_note2_str
      end
    end
  end
end

# メモ欄を持つクラスに機能追加
class RPG::BaseItem
  include HZM_VXA::Note2::Utils
end
class RPG::Tileset
  include HZM_VXA::Note2::Utils
end

# メモ解析
if true
  class << DataManager
    alias hzm_vxa_note2_init init
    def init
      hzm_vxa_note2_init
      HZM_VXA::Note2.setup
    end
  end
end

# 旧スクリプトとの互換性保持
if HZM_VXA::Note2::USE_OLD_STYLE
  module HZM_VXA
    module Note
      #-------------------------------------------------------------------------
      # ● メモスクリプトのバージョン
      #-------------------------------------------------------------------------
      VERSION = 2.20
      #-------------------------------------------------------------------------
      # ● バージョンチェック機構
      #-------------------------------------------------------------------------
      def self.check_version(n)
        (n >= 2 and n < 3)
      end
    end
  end
  module HZM_VXA
    module Note2
      module Utils
        #-----------------------------------------------------------------------
        # ● メモ内容取得
        #-----------------------------------------------------------------------
        def hzm_vxa_note_match(keys)
          hzm_vxa_note2_match(HZM_VXA::Note2::DEFAULT_MARK, keys)
        end
        def hzm_vxa_note(key)
          hzm_vxa_note2_match(HZM_VXA::Note2::DEFAULT_MARK, [key])
        end
        #-----------------------------------------------------------------------
        # ● メモ内容（単一文字列）取得
        #-----------------------------------------------------------------------
        def hzm_vxa_note_str_match(keys)
          hzm_vxa_note2_match_str(HZM_VXA::Note2::DEFAULT_MARK, keys)
        end
        def hzm_vxa_note_str(key)
          hzm_vxa_note2_match_str(HZM_VXA::Note2::DEFAULT_MARK, [key])
        end
      end
    end
  end
end