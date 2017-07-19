import grails.util.BuildSettings
import grails.util.Environment

def LOG_PATH="/var/uploads/sicj/log"

// See http://logback.qos.ch/manual/groovy.html for details on configuration
appender('STDOUT', ConsoleAppender) {
    encoder(PatternLayoutEncoder) {
        pattern = "%level %logger - %msg%n"
    }
}

root(ERROR, ['STDOUT'])

def targetDir = BuildSettings.TARGET_DIR
if (Environment.isDevelopmentMode() && targetDir) {
    appender("FULL_STACKTRACE", FileAppender) {
        file = "${targetDir}/stacktrace.log"
        append = true
        encoder(PatternLayoutEncoder) {
            pattern = "%level %logger - %msg%n"
        }
    }
    logger("StackTrace", ERROR, ['FULL_STACKTRACE'], false)
}

appender("RollingFile-Appender", RollingFileAppender) {
    file = "${LOG_PATH}/sicj.log"
    rollingPolicy(TimeBasedRollingPolicy) {
        fileNamePattern = "${LOG_ARCHIVE}/sicj.log.%d{yyyy-MM-dd}.log"
    }
    encoder(PatternLayoutEncoder) {
        pattern = "%date %level [%thread] %logger - %msg%n"
    }
}
root(ERROR, ['RollingFile-Appender'])
root(INFO, ['RollingFile-Appender'])
logger("org.hibernate.tool.hbm2ddl.TableMetadata", INFO, ["RollingFile-Appender"], false)
logger("org.springframework.boot.actuate.endpoint.mvc.EndpointHandlerMapping", INFO, ["RollingFile-Appender"], false)
