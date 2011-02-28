require 'test_helper'

class JoinmeMailerTest < ActionMailer::TestCase
  test "newuser" do
    @expected.subject = 'JoinmeMailer#newuser'
    @expected.body    = read_fixture('newuser')
    @expected.date    = Time.now

    assert_equal @expected.encoded, JoinmeMailer.create_newuser(@expected.date).encoded
  end

  test "eventedit" do
    @expected.subject = 'JoinmeMailer#eventedit'
    @expected.body    = read_fixture('eventedit')
    @expected.date    = Time.now

    assert_equal @expected.encoded, JoinmeMailer.create_eventedit(@expected.date).encoded
  end

  test "eventdelete" do
    @expected.subject = 'JoinmeMailer#eventdelete'
    @expected.body    = read_fixture('eventdelete')
    @expected.date    = Time.now

    assert_equal @expected.encoded, JoinmeMailer.create_eventdelete(@expected.date).encoded
  end

  test "newresponse" do
    @expected.subject = 'JoinmeMailer#newresponse'
    @expected.body    = read_fixture('newresponse')
    @expected.date    = Time.now

    assert_equal @expected.encoded, JoinmeMailer.create_newresponse(@expected.date).encoded
  end

end
