# -*- coding: utf-8 -*-

require "spec_helper"

describe "MySlog" do
  before :all do
    @log = <<-EOF
# User@Host: gimp[drool] @ algernon.retards.org [10.10.10.7]
# Time: 14  Lock_time: 0  Rows_sent: 127  Rows_examined: 87189

      select retard_user.id, cname.first,cname.last
      from retard_user,contact,cname,helmet
      where cname.id = contact.name_id
      and contact.id = retard_user.contact_id
      and retard_user.helmet_id = helmet.id
      and helmet.brand_id = 9
      and helmet.id = 143
      group by retard_user.id
      order by cname.last;
# User@Host: gimp[drool] @ algernon.retards.org [10.10.10.7]
# Time: 0  Lock_time: 0  Rows_sent: 2  Rows_examined: 1

      select workbook_code from workbook_defs where brand_id=9;
# Time: 010626 10:44:50
# User@Host: staff[staff] @ algernon.retards.org [10.10.10.7]
# Time: 0  Lock_time: 0  Rows_sent: 3  Rows_examined: 1
use lead_generator;

      SELECT answer_id, answer_text
      FROM pl_answers
      WHERE poll_id = 4
  ;
# Time: 010626 10:44:51
# User@Host: gimp[drool] @ algernon.retards.org [10.10.10.7]
# Time: 0  Lock_time: 0  Rows_sent: 1  Rows_examined: 1
use webtie;

  select count(tm.id)
    from text_message tm, tm_status tms
    where tm.tm_status_id = tms.id and
          tm.to_id = 21259 and
          tm.to_group = 'retard_user' and
          tms.description = 'new';
    EOF
  end

  before :each do
    @myslog = MySlog.new
  end

  describe "#parse" do
    it "should return Array of Hash" do
      results = @myslog.parse(@log)
      expect(results).to be_an_instance_of Array
      results.each do |result|
        expect(results).to be_an_instance_of Array
      end
    end
  end

  describe "#divide" do
    before :each do
      @lines = @log.split("\n").map {|line| line.chomp}
    end

    it "should return Array of Array" do
      results = @myslog.divide(@lines)
      expect(results).to be_an_instance_of Array
      results.each do |result|
        expect(results).to be_an_instance_of Array
      end
    end

    it "should devide lines in set of records" do
      results = @myslog.divide(@lines)

      record = results[0]
      expect(record.size).to eq(3)
      expect(record[0]).to eq(
          "# User@Host: gimp[drool] @ algernon.retards.org [10.10.10.7]"
      )

      record = results[1]
      expect(record.size).to eq(3)
      expect(record[0]).to eq(
          "# User@Host: gimp[drool] @ algernon.retards.org [10.10.10.7]"
      )

      record = results[2]
      expect(record.size).to eq(4)
      expect(record[0]).to eq(
          "# Time: 010626 10:44:50"
      )

      record = results[3]
      expect(record.size).to eq(4)
      expect(record[0]).to eq(
          "# Time: 010626 10:44:51"
      )
    end
  end

  describe "#parse_record" do
    it "should return an instance of Hash having specific keys" do
      lines = [
        "# Time: 010626 10:44:51",
        "# User@Host: gimp[drool] @ algernon.retards.org [10.10.10.7]",
        "# Time: 0  Lock_time: 0  Rows_sent: 1  Rows_examined: 1",
        "use webtie;"
      ]
      response = @myslog.parse_record(lines)

      expect(response).to be_an_instance_of Hash
      %w[
        date user host host_ip time lock_time rows_sent rows_examined sql
      ].each { |k| expect(response).to have_key k.to_sym}
    end

    context "given full log" do
      describe "response" do
        before :each do
          @date = Time.at(1317619058)
          @user = "root[root]"
          @host = "localhost"
          @host_ip = ""
          @query_time = 0.000270
          @lock_time = 0.000097
          @rows_sent = 1
          @rows_examined = 0
          @sql = "SET timestamp=1317619058; SELECT * FROM life;"
          @lines = [
            "# Time: #{@date.strftime("%y%m%d %H:%M:%S")}",
            "# User@Host: #{@user} @ #{@host} [#{@host_ip}]",
            "# Query_time: #{@query_time}  Lock_time: #{@lock_time}  Rows_sent: #{@rows_sent}  Rows_examined: #{@rows_examined}",
            @sql
          ]
          @response = @myslog.parse_record(@lines)
        end

        it "should have expected values" do
          expect(@response[:date].to_i).to     eq(@date.to_i)
          expect(@response[:user]).to          eq(@user)
          expect(@response[:host]).to          eq(@host)
          expect(@response[:host_ip]).to       eq(@host_ip)
          expect(@response[:query_time]).to    eq(@query_time)
          expect(@response[:lock_time]).to     eq(@lock_time)
          expect(@response[:rows_sent]).to     eq(@rows_sent)
          expect(@response[:rows_examined]).to eq(@rows_examined)
          expect(@response[:sql]).to           eq(@sql.strip)
        end
      end
    end

    context "given partial log" do
      describe "response" do
        before :each do
          @user = "root[root]"
          @host = "localhost"
          @host_ip = ""
          @query_time = 0.000270
          @lock_time = 0.000097
          @rows_sent = 1
          @rows_examined = 0
          @sql = "SET timestamp=1317619058; SELECT * FROM life;"
          @lines = [
            "# User@Host: #{@user} @ #{@host} [#{@host_ip}]",
            "# Query_time: #{@query_time}  Lock_time: #{@lock_time}  Rows_sent: #{@rows_sent}  Rows_examined: #{@rows_examined}",
            @sql
          ]
          @response = @myslog.parse_record(@lines)
        end

        it "should have expected values" do
          expect(@response[:date].utc.to_s).to eq("2011-10-03 05:17:38 UTC")
          expect(@response[:user]).to          eq(@user)
          expect(@response[:host]).to          eq(@host)
          expect(@response[:host_ip]).to       eq(@host_ip)
          expect(@response[:query_time]).to    eq(@query_time)
          expect(@response[:lock_time]).to     eq(@lock_time)
          expect(@response[:rows_sent]).to     eq(@rows_sent)
          expect(@response[:rows_examined]).to eq(@rows_examined)
          expect(@response[:sql]).to           eq(@sql.strip)
        end
      end

    end
  end
end
