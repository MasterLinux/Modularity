package server.api.resource;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import server.data.dao.UsersDAO;
import server.api.model.UserModel;
import server.api.parameter.MetaBeanParam;
import server.api.parameter.SessionBeanParam;
import server.security.Password;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.sql.Date;
import java.util.List;

/**
 * Created by Christoph on 27.03.2014.
 */
@Path("/users")
public class Users extends BaseResource {

    /**
     * Gets an user by its ID
     *
     * @param id The ID of the user to get
     * @param session The session header for authentication
     * @param meta Meta parameter to filter and querying
     *
     * @return The response as JSON string
     */
    @GET
    @Path("/{id: [0-9]+}")
    @Produces(MediaType.APPLICATION_JSON)
    public String getUserById(
            @PathParam("id") @DefaultValue("-1") int id,
            @BeanParam SessionBeanParam session,
            @BeanParam MetaBeanParam meta
    ) {
        //check whether the user is allowed to use this API
        if(!session.isAuthorized()) {
            throw new WebApplicationException(Response.Status.UNAUTHORIZED);
        }

        return buildResponse(meta, UsersDAO.getInstance().getById(session.getRole(), id));
    }

    /**
     * Gets an user by its username
     *
     * @param username The username of the user to get
     * @param session The session header for authentication
     * @param meta Meta parameter to filter and querying
     *
     * @return The response as JSON string
     */
    @GET
    @Path("/{username: [a-zA-Z][a-zA-Z0-9-_]{3,}}")
    @Produces(MediaType.APPLICATION_JSON)
    public String getUserByUsername(
            @PathParam("username") String username,
            @BeanParam SessionBeanParam session,
            @BeanParam MetaBeanParam meta
    ) {
        //check whether the user is allowed to use this API
        if(!session.isAuthorized()) {
            throw new WebApplicationException(Response.Status.UNAUTHORIZED);
        }

        return buildResponse(meta, UsersDAO.getInstance().getByUsername(session.getRole(), username));
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<UserModel> getUsers(
            @BeanParam SessionBeanParam session,
            @BeanParam MetaBeanParam meta
    ) {
        //check whether the user is allowed to use this API
        if(!session.isAuthorized()) {
            throw new WebApplicationException(Response.Status.UNAUTHORIZED);
        }

        return null;// buildResponse(meta, UsersDAO.getInstance().get(session.getRole(), username));
    }

    /**
     * Registers a new user
     * @param body JSON which contains all information of the user to register
     *             <code>
     *             {
     *                  "username": "user_01",
     *                  "prename": "Max",
     *                  "surname": "Mustermann",
     *                  "birthday": "1983-12-07", //yyyy-[m]m-[d]d
     *                  "street": "Max Mustermann Str.",
     *                  "houseNumber": "42a",
     *                  "city": "Düsseldorf",
     *                  "postalCode": "40549",
     *                  "country": "Germany"
     *             }
     *             </code>
     */
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    public Response registerUser(
            String body
    ) {
        try {
            UserModel user = new Gson().fromJson(body, UserModel.class);

            //try to add a new user
            if(!UsersDAO.getInstance().register(
                    user.getUsername(),
                    user.getPrename(),
                    user.getSurname(),
                    Date.valueOf(user.getBirthday()),
                    user.getStreet(),
                    user.getHouseNumber(),
                    user.getPostalCode(),
                    user.getCity(),
                    user.getCountry(),
                    new Password(
                            user.getUsername(),
                            user.getPassword(),
                            UserModel.class.toGenericString()
                    ))) {

                //throw exception on missing field
                throw new WebApplicationException(Response.Status.BAD_REQUEST);
            }
        }

        //handle wrong date format and wrong JSON syntax
        catch (IllegalArgumentException | JsonSyntaxException e) {
            throw new WebApplicationException(Response.Status.BAD_REQUEST);
        }

        return Response
                .status(Response.Status.CREATED)
                .build();
    }
}
