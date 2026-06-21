package com.pricing.calc.exception;

public class PricingException extends RuntimeException {
    private String errorCode;
    private String details;

    public PricingException(String message) {
        super(message);
        this.errorCode = "PRICING_ERROR";
        this.details = null;
    }

    public PricingException(String message, String errorCode) {
        super(message);
        this.errorCode = errorCode;
        this.details = null;
    }

    public PricingException(String message, String errorCode, String details) {
        super(message);
        this.errorCode = errorCode;
        this.details = details;
    }

    public String getErrorCode() { return errorCode; }
    public void setErrorCode(String errorCode) { this.errorCode = errorCode; }

    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }
}
