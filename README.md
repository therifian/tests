# tests


## JMeter commands
```sh
jmeter -n -t margin.jmx -l results.jtl
jmeter -n -t margin.jmx -l results.jtl -Jtoken=${token}
jmeter -n -t your_test_plan.jmx -l results.jtl -e -o result_folder -Jjmeter.save.saveservice.output_format=n -Jjmeter.save.saveservice.assertion_results_failure_message=false


```

```yml
- task: PublishTestResults@2
  inputs:
    testResultsFormat: 'NUnit'
    testResultsFiles: '**/TEST-*.xml'
    failTaskOnFailedTests: true

```

Authorization: Bearer ${__P(token)}


