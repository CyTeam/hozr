unless defined?(MIGRATED_SEC_DB_FOR_TEST)
  UseDbTest.prepare_test_db(:prefix => "tarmed_")
  MIGRATED_SEC_DB_FOR_TEST = true
end
