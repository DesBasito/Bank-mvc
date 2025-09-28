package kg.manurov.bankmvc.components;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.concurrent.CompletableFuture;

/**
 * Epam
 * <p>
 * https://www.baeldung.com/jackson-yaml
 * <p>
 * ChatGPT
 */
@Slf4j
@Component
public class OpenApiFileGenerator implements CommandLineRunner {

    @Value("${server.port}")
    private String port;

    @Value("${server.servlet.context-path:}")
    private String contextPath;

    @Override
    public void run(String... args) {
        CompletableFuture.runAsync(this::generateOpenApiFile);
    }

    private void generateOpenApiFile() {
        try {
            Thread.sleep(3000);

            String baseUrl = String.format("http://localhost:%s", this.port);

            if (contextPath != null && !contextPath.isEmpty() && !contextPath.equals("/")) {
                baseUrl += contextPath;
            }

            String openApiUrl = baseUrl + "/v3/api-docs";

            log.info("🔄 Generation of OpenAPI specification...");
            log.info("📡 Attempting to fetch from: {}", openApiUrl);

            RestTemplate restTemplate = new RestTemplate();
            restTemplate.getMessageConverters().forEach(converter ->
                    log.debug("Available converter: {}", converter.getClass().getSimpleName()));

            String openApiJson = restTemplate.getForObject(openApiUrl, String.class);

            if (openApiJson != null && !openApiJson.trim().isEmpty() && !openApiJson.equals("{}")) {
                ObjectMapper jsonMapper = new ObjectMapper();
                Object jsonObject = jsonMapper.readValue(openApiJson, Object.class);

                ObjectMapper yamlMapper = new ObjectMapper(new YAMLFactory());
                Files.createDirectories(Paths.get("docs"));
                yamlMapper.writeValue(new File("docs/openapi.yaml"), jsonObject);

                log.info("✅ OpenAPI specification generated successfully: docs/openapi.yaml");
            } else {
                log.warn("⚠️ OpenAPI specification is empty or inaccessible");
                logManualInstructions();
            }

        } catch (Exception e) {
            log.error("❌ Failed to automatically generate OpenAPI file: {}", e.getMessage());
            logManualInstructions();
        }
    }

    private void logManualInstructions() {
        String baseUrl = String.format("http://localhost:%s", this.port);
        if (contextPath != null && !contextPath.isEmpty() && !contextPath.equals("/")) {
            baseUrl += contextPath;
        }

        log.info("💡 Manual access instructions:");
        log.info("   📊 Swagger UI: {}/swagger-ui/index.html", baseUrl);
        log.info("   📋 OpenAPI JSON: {}/v3/api-docs", baseUrl);
        log.info("   📄 OpenAPI YAML: {}/v3/api-docs.yaml", baseUrl);
        log.info("   💾 Download: curl -o docs/openapi.yaml {}/v3/api-docs.yaml", baseUrl);
    }
}