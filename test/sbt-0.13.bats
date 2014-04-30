#!/usr/bin/env bats

load test_helper

setup () { setup_version_project $sbt_latest_13; }

@test "successes to set trace level for sbt $sbt_latest_13" {
  stub_java
  run sbt -trace 1
  assert_success
  { java_options <<EOS
-jar
${HOME}/.sbt/launchers/$sbt_latest_13/sbt-launch.jar
set every traceLevel := 1
shell
EOS
  } | assert_output
  unstub java
}

@test "not enables default sbt.global.base for $sbt_latest_13" {
  stub_java
  run sbt
  assert_success
  { java_options <<EOS
-jar
${HOME}/.sbt/launchers/$sbt_latest_13/sbt-launch.jar
shell
EOS
  } | assert_output
  unstub java
}

@test "enables special sbt.global.base for $sbt_latest_13 if -sbt-dir was given" {
  stub_java
  run sbt -sbt-dir "${sbt_project}/sbt.base"
  assert_success
  { java_options <<EOS
-Dsbt.global.base=${sbt_project}/sbt.base
-jar
${HOME}/.sbt/launchers/$sbt_latest_13/sbt-launch.jar
shell
EOS
  } | assert_output
  unstub java
}