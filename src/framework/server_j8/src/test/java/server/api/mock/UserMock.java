package server.api.mock;

import server.api.model.UserModel;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

/**
 * Helper class to get user mocks
 */
public class UserMock {

    public static UserModel getUnregisteredUser() {
        UserModel user = mock(UserModel.class);

        when(user.getUsername()).thenReturn("unknown_user");
        when(user.getPassword()).thenReturn("no_password");

        return user;
    }

    public static UserModel getRegisteredUserWithFullInfo() {
        UserModel user = mock(UserModel.class);

        when(user.getUsername()).thenReturn("test_user");
        when(user.getPassword()).thenReturn("test_password");
        when(user.getBirthday()).thenReturn("1990-10-02");
        when(user.getCity()).thenReturn("test_city");
        when(user.getCountry()).thenReturn("test_country");
        when(user.getHouseNumber()).thenReturn("12a");
        when(user.getPostalCode()).thenReturn("90459");
        when(user.getPrename()).thenReturn("test_prename");
        when(user.getSurname()).thenReturn("test_surname");
        when(user.getStreet()).thenReturn("test_street");

        return user;
    }

    public static UserModel getRegisteredUserWithMinimumInfo() {
        UserModel user = mock(UserModel.class);

        when(user.getUsername()).thenReturn("test_user_2");
        when(user.getPassword()).thenReturn("test_password_2");

        return user;
    }

    public static UserModel getRegisteredUserWithMissingInfo() {
        UserModel user = mock(UserModel.class);

        when(user.getUsername()).thenReturn("test_user_3");

        return user;
    }
}
