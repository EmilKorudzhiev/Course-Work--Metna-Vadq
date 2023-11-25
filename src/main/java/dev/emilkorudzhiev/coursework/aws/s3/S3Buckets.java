package dev.emilkorudzhiev.coursework.aws.s3;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Getter
@Setter
@Configuration
@ConfigurationProperties(prefix = "cloud.aws.s3.buckets")
public class S3Buckets {

    private String users;

    private String fishCatches;

    private String locations;

}
