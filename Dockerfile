# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy solution and project files
COPY TestRender.sln ./
COPY TestRender/*.csproj ./TestRender/

# Restore dependencies
RUN dotnet restore TestRender.sln

# Copy everything else
COPY . ./

# Publish
RUN dotnet publish TestRender.sln -c Release -o out

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

ENV PORT=8080
EXPOSE 8080

COPY --from=build /app/out ./
ENTRYPOINT ["dotnet", "TestRender.dll"]