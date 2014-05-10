package server.exception;

/**
 * Created by Christoph on 10.05.2014.
 */
public class OperationException extends Throwable {
    private final ErrorCode errorCode;

    public OperationException(ErrorCode errorCode) {
        this.errorCode = errorCode;
    }

    public ErrorCode getErrorCode() {
        return errorCode;
    }

    @Override
    public String getMessage() { //TODO implement
        String msg = super.getMessage();

        switch (getErrorCode()) {
            case FAIL_TO_CREATE:
                break;
            case FAIL_TO_DELETE:
                break;
            case FAIL_TO_GET:
                break;
            case FAIL_TO_UPDATE:
                break;
        }

        return msg;
    }

    public enum ErrorCode {
        FAIL_TO_CREATE,
        FAIL_TO_DELETE,
        FAIL_TO_UPDATE,
        FAIL_TO_GET
    }
}
