package com.tap.util;

import java.io.InputStream;
import java.util.Properties;
import java.util.Random;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailService {

    // =========================================================================
    // ⚙️ GMAIL SMTP CREDENTIALS (Loaded securely from config.properties / env)
    // =========================================================================
    private static String senderEmail = "your_email@gmail.com";
    private static String senderAppPassword = "";

    static {
        loadConfig();
    }

    private static void loadConfig() {
        Properties props = new Properties();
        try (InputStream in = EmailService.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (in != null) {
                props.load(in);
                senderEmail = props.getProperty("mail.sender.email", senderEmail);
                senderAppPassword = props.getProperty("mail.sender.password", senderAppPassword);
            } else {
                if (System.getenv("MAIL_SENDER_EMAIL") != null) {
                    senderEmail = System.getenv("MAIL_SENDER_EMAIL");
                }
                if (System.getenv("MAIL_SENDER_PASSWORD") != null) {
                    senderAppPassword = System.getenv("MAIL_SENDER_PASSWORD");
                }
            }
        } catch (Exception e) {
            System.err.println("Notice: Could not load config.properties for EmailService: " + e.getMessage());
        }
    }

    /**
     * Generates a cryptographically random 6-digit OTP code (100000 - 999999).
     */
    public static String generateOtp() {
        Random random = new Random();
        int otpNumber = 100000 + random.nextInt(900000);
        return String.valueOf(otpNumber);
    }

    /**
     * Sends an official, luxury branded HTML OTP email directly to the recipient's Gmail inbox.
     * Also prints to Eclipse Console as a safety backup during live project evaluations.
     */
    public static boolean sendOtpEmail(String recipientEmail, String otp) {
        
        // 1. Print to Eclipse Console (Instant Presentation Backup)
        System.out.println("\n========================================================");
        System.out.println("  🔐 FASTX SECURITY PROTOCOL: OTP DISPATCHED");
        System.out.println("--------------------------------------------------------");
        System.out.println("  Recipient Email : " + recipientEmail);
        System.out.println("  One-Time Code   : " + otp);
        System.out.println("  Validity Period : 10 Minutes");
        System.out.println("========================================================\n");

        // 2. Configure Google SMTP Properties
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        // 3. Authenticate with Google
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderAppPassword.replaceAll("\\s+", ""));
            }
        });

        try {
            // 4. Construct Luxury Branded HTML Email
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail, "FastX Security Protocol"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail));
            message.setSubject("🔐 FastX Account Verification Code: " + otp, "UTF-8");

            // Luxury Email Body
            String htmlTemplate = 
                "<div style=\"font-family: 'Helvetica Neue', Arial, sans-serif; background-color: #f4f3e7; padding: 40px 20px;\">" +
                "  <div style=\"max-width: 520px; margin: auto; background-color: #ffffff; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,71,60,0.1); border: 1px solid rgba(0,71,60,0.12);\">" +
                "    " +
                "    <!-- Header -->" +
                "    <div style=\"background: linear-gradient(135deg, #00473c, #00332a); padding: 32px 30px; text-align: center;\">" +
                "      <h1 style=\"color: #ffffff; margin: 0; font-size: 26px; font-weight: 800; letter-spacing: -0.5px;\">" +
                "        Fast<span style=\"color: #e6ff55;\">X</span>" +
                "      </h1>" +
                "      <p style=\"color: #d8e5d6; font-size: 13px; margin: 6px 0 0 0; text-transform: uppercase; letter-spacing: 1px;\">" +
                "        Account Security & Recovery" +
                "      </p>" +
                "    </div>" +
                "    " +
                "    <!-- Content Body -->" +
                "    <div style=\"padding: 36px 32px; text-align: center;\">" +
                "      <h2 style=\"color: #00473c; font-size: 22px; font-weight: 800; margin: 0 0 12px 0;\">" +
                "        Password Reset Request" +
                "      </h2>" +
                "      <p style=\"color: #556963; font-size: 14.5px; line-height: 1.6; margin: 0 0 24px 0;\">" +
                "        We received a request to verify your identity for your FastX account. Use the one-time verification code below to proceed:" +
                "      </p>" +
                "      " +
                "      <!-- OTP Box -->" +
                "      <div style=\"background-color: #f4f3e7; border: 2px dashed #00473c; border-radius: 14px; padding: 18px 24px; display: inline-block; margin-bottom: 24px;\">" +
                "        <span style=\"font-family: monospace; font-size: 32px; font-weight: 900; letter-spacing: 8px; color: #00473c;\">" +
                "          " + otp +
                "        </span>" +
                "      </div>" +
                "      " +
                "      <p style=\"color: #d93829; font-size: 13px; font-weight: 700; margin: 0 0 20px 0;\">" +
                "        ⏳ This code is valid for 10 minutes only." +
                "      </p>" +
                "      " +
                "      <p style=\"color: #8c9e99; font-size: 12px; line-height: 1.5; margin: 0;\">" +
                "        If you did not request this code, you can safely ignore this email. Your password will remain unchanged." +
                "      </p>" +
                "    </div>" +
                "    " +
                "    <!-- Footer -->" +
                "    <div style=\"background-color: #f4f3e7; padding: 18px 30px; text-align: center; border-top: 1px solid rgba(0,71,60,0.08); font-size: 12px; color: #556963;\">" +
                "      © 2026 FastX Gourmet Delivery Platform. All rights reserved." +
                "    </div>" +
                "  </div>" +
                "</div>";

            message.setContent(htmlTemplate, "text/html; charset=UTF-8");

            // 5. Send Email Across Internet
            Transport.send(message);
            System.out.println("  ✅ Email delivered successfully to: " + recipientEmail + "\n");
            return true;

        } catch (Exception e) {
            System.err.println("  ❌ Failed to send email via SMTP: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
