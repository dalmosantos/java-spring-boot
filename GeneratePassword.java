import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class GeneratePassword {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        
        System.out.println("Hash for 'user': " + encoder.encode("user"));
        System.out.println("Hash for 'admin': " + encoder.encode("admin"));
        
        // Test the existing hash
        String existingHash = "$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG";
        System.out.println("\nTesting existing hash:");
        System.out.println("'user' matches: " + encoder.matches("user", existingHash));
        System.out.println("'admin' matches: " + encoder.matches("admin", existingHash));
    }
}
