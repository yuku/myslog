# -*- coding: utf-8 -*-

require "spec_helper"

describe "MySlog" do
  before :each do
    @myslog = MySlog.new
  end

  describe "#parse" do
  end

  describe "#parse_record" do
    it "should return an instance of Hash having specific keys" do
      lines = [
        "# Time: 010626 10:44:51",
        "# User@Host: gimp[drool] @ algernon.retards.org [10.10.10.7]",
        "# Time: 0  Lock_time: 0  Rows_sent: 1  Rows_examined: 1",
        "use webtie;"
      ]
      response = @myslog.send(:parse_record, lines)

      response.should be_an_instance_of Hash
      %w[
        date user host host_ip query_time lock_time rows_sent rows_examined sql
      ].each { |k| response.should have_key k.to_sym}
    end

    context "given full log" do
      describe "response" do
        before :each do
          @date = Time.now
          @user = "root[root]"
          @host = "localhost"
          @host_ip = ""
          @query_time = 0.000270
          @lock_time = 0.000097
          @rows_sent = 1
          @rows_examined = 0
          @sql = "SET timestamp=1317619058;\nSELECT * FROM life;"
          @lines = [
            "# Time: #{@date.strftime("%y%m%d %H:%M:%S")}",
            "# User@Host: #{@user} @ #{@host} [#{@host_ip}]",
            "# Query_time: #{@query_time}  Lock_time: #{@lock_time}  Rows_sent: #{@rows_sent}  Rows_examined: #{@rows_examined}",
            @sql
          ]
          @response = @myslog.send(:parse_record, @lines)
        end

        it "should have expected values" do
          @response[:date].to_i.should     == @date.to_i
          @response[:user].should          == @user
          @response[:host].should          == @host
          @response[:host_ip].should       == @host_ip
          @response[:query_time].should    == @query_time
          @response[:lock_time].should     == @lock_time
          @response[:rows_sent].should     == @rows_sent
          @response[:rows_examined].should == @rows_examined
          @response[:sql].should           == @sql.strip
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
          @response = @myslog.send(:parse_record, @lines)
        end

        it "should have expected values" do
          @response[:date].should          == nil
          @response[:user].should          == @user
          @response[:host].should          == @host
          @response[:host_ip].should       == @host_ip
          @response[:query_time].should    == @query_time
          @response[:lock_time].should     == @lock_time
          @response[:rows_sent].should     == @rows_sent
          @response[:rows_examined].should == @rows_examined
          @response[:sql].should           == @sql.strip
        end
      end

    end
  end
end
