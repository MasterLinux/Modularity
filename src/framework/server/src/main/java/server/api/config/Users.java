package server.api.config;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import server.BaseResource;
import server.data.dao.UserDAO;
import server.model.config.UserModel;
import server.parameter.MetaBeanParam;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.sql.Date;
import java.util.List;

/**
 * Created by Christoph on 27.03.2014.
 */
@Path("/config/users")
public class Users extends BaseResource {

    @GET
    @Path("/{id: [0-9]+}")
    @Produces(MediaType.APPLICATION_JSON)
    public String getUserById(
            @PathParam("id") @DefaultValue("-1") int id,
            @BeanParam MetaBeanParam metaParam
    ) {
        return buildResponse(metaParam, UserDAO.getInstance().getById(id));
    }

    @GET
    @Path("/{username: [a-zA-Z][a-zA-Z0-9-_]{3,}}")
    @Produces(MediaType.APPLICATION_JSON)
    public String getUserByUsername(
            @PathParam("username") String username,
            @BeanParam MetaBeanParam metaParam
    ) {
        return buildResponse(metaParam, UserDAO.getInstance().getByUsername(username));
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<UserModel> getUsers(
            @BeanParam MetaBeanParam meta
    ) {
        return null;
    }

    /**
     * Registers a new user
     * @param id Authentication token of the user
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
    public Response addUser(
            @HeaderParam("X-AUTH-TOKEN") @DefaultValue("-1") int id,
            String body
    ) {
        try {
            UserModel user = new Gson().fromJson(body, UserModel.class);

            //try to add a new user
            if(!UserDAO.getInstance().register(
                    user.getUsername(),
                    user.getPrename(),
                    user.getSurname(),
                    Date.valueOf(user.getBirthday()),
                    user.getStreet(),
                    user.getHouseNumber(),
                    user.getPostalCode(),
                    user.getCity(),
                    user.getCountry())) {

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
