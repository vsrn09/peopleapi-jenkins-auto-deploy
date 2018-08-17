FROM microsoft/dotnet:sdk AS build-env
ENV ASPNETCORE_ENVIRONMENT Testing
WORKDIR /app/

# copy the project and restore as distinct layers in the image
COPY *.csproj ./
RUN dotnet restore

# copy the rest and build
COPY . ./
RUN dotnet publish -c Release -o out

# build runtime image
FROM microsoft/dotnet:2.1-runtime
WORKDIR /app
COPY --from=build-env /app/out ./
ENV ASPNETCORE_ENVIRONMENT Testing
ENV ASPNETCORE_URLS http://*:8080

EXPOSE 8080
ENTRYPOINT ["dotnet", "peopleapi.dll"]