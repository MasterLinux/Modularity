package server.api.model;

import org.apache.http.util.TextUtils;

import java.sql.Date;

/**
 * Representation of an user
 */
public class UserModel extends BaseObjectModel {
    private String username;
    private String prename;
    private String surname;
    private String birthday;
    private String street;
    private String houseNumber;
    private String city;
    private String postalCode;
    private String country;
    private String password;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPrename() {
        return prename;
    }

    public void setPrename(String prename) {
        this.prename = prename;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getBirthday() {
        return birthday;
    }

    public Date getBirthdayDate() {
        return TextUtils.isEmpty(birthday) ? null : Date.valueOf(birthday);
    }

    public void setBirthdayDate(Date birthdayDate) {
        this.birthday = birthdayDate != null ? birthdayDate.toString() : null;
    }

    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getHouseNumber() {
        return houseNumber;
    }

    public void setHouseNumber(String houseNumber) {
        this.houseNumber = houseNumber;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getPassword() {
        return password;
    }

}
