# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2026 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

module When

  class BasicTypes::M17n

    ThaiBuddhistHoliday = [self, [
      "locale:[=en:, ja=ja:, alias=en:]",
      "names:[ThaiBuddhistHoliday=, タイ仏教の祝日=]",
      "[Makha Bucha=en:Makha_Bucha,     マーカ・ブーチャー=]",
      "[Visakha Bucha=en:Visakha_Bucha, ウィサーカ・ブーチャー=]",
      "[Asanha Bucha=en:Asalha_Puja,    アーサーンハ・ブーチャー=]"
    ]]
  end

  class CalendarNote

    #
    # タイ仏教の祝日
    #
    class ThaiBuddhistNote < self

      #
      # 祝日の日付
      #
      Holidays = {
        3 => When.M17n('ThaiBuddhistHoliday::Makha Bucha'),
        6 => When.M17n('ThaiBuddhistHoliday::Visakha Bucha'),
        8 => When.M17n('ThaiBuddhistHoliday::Asanha Bucha')
      }

      #
      # 年月日の暦注
      #
      Notes = [When::BasicTypes::M17n, [
        "locale:[=en:, ja=ja:, alias=en:]",
        "names:[ThaiBuddhistNote=, タイ仏教暦注=]",

        # 年の暦注 ----------------------------
        [When::BasicTypes::M17n,
          "names:[note for year=, 年の暦注=, prefix:YearNote=, *alias:year=]",
          [When::BasicTypes::M17n,
            "names:[note for year=, 年の暦注=, *alias:Year=]"
          ]
        ],

        # 月の暦注 ----------------------------
        [When::BasicTypes::M17n,
          "names:[note for month=, 月の暦注=, prefix:MonthNote=, *alias:month=]",
          [When::BasicTypes::M17n,
            "names:[month name=en:Month, 月の名前=, *alias:Month=]"
          ]
        ],

        # 日の暦注 ----------------------------
        [When::BasicTypes::M17n,
          "names:[note for day=, 日の暦注=, prefix:DayNote=, *alias:day]",
           "[*Week=, 週=]",
           "[*Holiday=, 祝日=]"
        ]
      ]]

      #
      # 七曜
      #
      # @param [When::TM::TemporalPosition] date
      # @param [Hash] options dummy
      #
      # @return [When::Coordinates::Residue] 七曜
      #
      def week(date, options={})
        When.Resource('_co:Common::Week')[date.to_i % 7]
      end

      #
      # 祝日
      #
      # @param [When::TM::TemporalPosition] date
      # @param [Hash] options dummy
      #
      # @return [When::BasicTypes::M17n] 祝日 or nil
      #
      def holiday(date, options={})
        month = date.cal_date[When::MONTH-1]
        return nil if month.kind_of?(When::Coordinates::Pair) && month.branch != 0
        return nil unless date.cal_date[When::DAY-1] == 15
        Holidays[+month]
      end

      # オブジェクトの正規化
      def _normalize(args=[], options={})
        @_all_keys  ||= [%w(Year), %w(Month), %w(Week Holiday)]
        super
      end
    end
  end
end
