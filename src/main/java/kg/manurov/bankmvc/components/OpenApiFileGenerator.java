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

@Slf4j
@Component
public class OpenApiFileGenerator implements CommandLineRunner {

    @Value("${server.port}")
    private String port;
    @Value("${app.rest_path}")
    private String contextPath;

    @Override
    public void run(String... args) {
        CompletableFuture.runAsync(this::generateOpenApiFile);
    }

    private void generateOpenApiFile() {
        try {
            Thread.sleep(3000);
            String openApiUrl = String.format("http://localhost:%s%s/v3/api-docs", this.port, this.contextPath);

            log.info("🔄 Generation of OpenAPI specification...");

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

                log.info("✅ Openapi specification is generated: docs/openapi.yaml");
            } else {
                log.warn("⚠️ OpenApi specification is empty or inaccessible");
                logManualInstructions();
            }

        } catch (Exception e) {
            log.error("❌ Failed to automatically generate Openapi file: {}", e.getMessage());
            logManualInstructions();
        }
    }

    private void logManualInstructions() {
        log.info("💡 Get the specification manually:");
        log.info("   curl -o docs/openapi.yaml http://localhost:{}{}/v3/api-docs.yaml", this.port, this.contextPath);
        log.info("   or open: http://localhost:{}{}/swagger-ui/index.html", this.port, this.contextPath);
    }
}