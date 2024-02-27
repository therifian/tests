FROM alpine:latest

# Install OpenJDK and other dependencies
RUN apk --update --no-cache add openjdk8-jre bash

# Set environment variables
ENV JMETER_HOME /opt/apache-jmeter-5.4.1
ENV JMETER_BIN $JMETER_HOME/bin
ENV PATH $JMETER_BIN:$PATH

# Download and extract Apache JMeter
RUN mkdir -p $JMETER_HOME \
    && wget -qO- https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.4.1.tgz | tar xz --strip 1 -C $JMETER_HOME

# Set working directory
WORKDIR $JMETER_HOME

# Copy your JMeter test plan into the container
COPY your_test_plan.jmx /opt/

# Run the JMeter test plan
CMD ["jmeter", "-n", "-t", "/opt/your_test_plan.jmx", "-l", "/opt/results.jtl", "-e", "-o", "/opt/result_folder", "-Jjmeter.save.saveservice.output_format=n", "-Jjmeter.save.saveservice.assertion_results_failure_message=false"]
