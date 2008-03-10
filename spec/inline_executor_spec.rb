require File.dirname(__FILE__) + '/spec_helper'

describe InlineExecutor, "for `/usr/bin/env git'" do
  before(:each) do
    @git = InlineExecutor.create("/usr/bin/env git")
    @fake_system = mock("fake system")
  end
  
  def run(commandable)
    @fake_system.execute(commandable.to_command)
  end
  
  it "should execute with no arguments" do
    @fake_system.should_receive(:execute).with("/usr/bin/env git")
    run @git
  end
  
  it "should execute a single command" do
    @fake_system.should_receive(:execute).with("/usr/bin/env git fetch")
    run @git.fetch
  end
  
  it "should execute a single command with arguments" do
    @fake_system.should_receive(:execute).with("/usr/bin/env git merge origin/master")
    run @git.merge("origin/master")
  end
  
  it "should execute a single command with a single long option" do
    @fake_system.should_receive(:execute).with("/usr/bin/env git log --stat")
    run @git.log(:stat => true)
  end
  
  it "should execute a single command with multiple options both short and long" do
    @fake_system.should_receive(:execute).with("/usr/bin/env git log -p --stat")
    run @git.log(:stat => true, :p => true)
  end
  
  it "should execute a single command with multiple options (both short and long) and multiple arguments" do
    @fake_system.should_receive(:execute).with("/usr/bin/env git log HEAD~1 -p --stat")
    run @git.log("HEAD~1", :stat => true, :p => true)
  end
  
  it "should execute a 2-level command" do
    @fake_system.should_receive(:execute).with("/usr/bin/env git svn init")
    run @git.svn.init
  end
  
  it "should execute a 2-level command with arguments" do
    @fake_system.should_receive(:execute).with("/usr/bin/env git svn clone svn://url")
    run @git.svn.clone("svn://url")
  end
end