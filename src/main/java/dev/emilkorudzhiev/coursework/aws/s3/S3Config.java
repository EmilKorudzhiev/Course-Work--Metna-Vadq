package dev.emilkorudzhiev.coursework.aws.s3;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;


@Configuration
public class S3Config {

    @Value("${cloud.aws.region}")
    private String region;

    @Bean
    public S3Client s3Client() {
        S3Client client = S3Client.builder()
                .region(Region.of(region))
                .build();
        return client;
    }

    /*@Bean
    CommandLineRunner runner(
            S3Service s3Service,
            S3Buckets s3Buckets
    ) {
        return args -> {
            s3Service.putObject(
                    s3Buckets.getUsers(),
                    "foo",
                    "hello world".getBytes()
            );
            byte[] obj = s3Service.getObject(
                    s3Buckets.getUsers(),
                    "foo"
            );
            System.out.println(new String(obj));
        };
    }*/
}
