import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

class RatesSimulation extends Simulation {

  val httpConf = http.baseUrl("your_base_url").header();

  val basicLoadTest = scenario("Basic Load Test")
    .exec(http("Basic Request").get("/basic_endpoint"))

  val rampUpTest = scenario("Ramp-up Test")
    .exec(http("Ramp-up Request").get("/ramp_up_endpoint"))

  val stressTest = scenario("Stress Test")
    .exec(http("Stress Request").get("/stress_endpoint"))

  val durationTest = scenario("Duration Test")
    .exec(http("Duration Request").get("/duration_endpoint"))

  val constantThroughputTest = scenario("Constant Throughput Test")
    .exec(http("Constant Throughput Request").get("/constant_throughput_endpoint"))

  setUp(
    basicLoadTest.inject(constantUsersPerSec(10) during (60 seconds)),
    rampUpTest.inject(rampUsers(10) during (30 seconds)),
    stressTest.inject(atOnceUsers(1000)),
    durationTest.inject(constantUsersPerSec(10) during (300 seconds)),
    constantThroughputTest.inject(constantUsersPerSec(10) during (60 seconds))
      .throttle(reachRps(10) in (10 seconds), holdFor(60 seconds))
  ).protocols(httpConf)
    .assertions(
      global.responseTime.max.lt(500), // Maximum response time threshold
      global.successfulRequests.percent.gt(95) // Success rate threshold
    )
    {
         setUp(
    BasicLoadTest.scn.inject(constantUsersPerSec(10).during(60)).protocols(BasicLoadTest.httpConf),
    RampUpTest.scn.inject(rampUsers(10).during(30)).protocols(RampUpTest.httpConf),
    StressTest.scn.inject(atOnceUsers(1000)).protocols(StressTest.httpConf)
    }
   

        .assertions(
    global.responseTime.percentile1.lt(100), // 1st percentile
    global.responseTime.percentile2.lt(200), // 2nd percentile
    global.responseTime.percentile3.lt(300)  // 3rd percentile
    )

    .assertions(
  details("Request 1").requestsPerSec.gt(10), // Request 1 throughput
  details("Request 2").requestsPerSec.lt(20)  // Request 2 throughput
)


.assertions(
  global.failedRequests.percent.lt(5) // Maximum percentage of failed requests
)


    .assertions(
  global.allRequests.count.lt(100), // Maximum total requests
  global.failedRequests.count.is(0), // No failed requests
  forAll.failedRequests.percent.lt(5) // Maximum percentage of failed requests for each request
)

.assertions(
  global.responseTime.mean.between(100, 200) // Mean response time within a range
)

.assertions(
  details("Specific Request").responseTime.max.lt(500), // Maximum response time for a specific request
  details("Specific Request").successfulRequests.percent.gt(90) // Success rate for a specific request
)

  
}
