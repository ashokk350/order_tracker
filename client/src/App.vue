<script setup>
import UsersIndex from './components/users/Index.vue'
</script>

<template>
  <div class="container">
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
      <div class="container">
        <a class="navbar-brand" href="#">Order Tracker</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
      </div>
    </nav>

    <br />
    <div>
      <UsersIndex />
    </div>
  </div>
</template>

<style scoped>
.container {
  width: 100%; /* Adjust the width as needed */
  max-width: 1200px; /* Maximum width of the container */
  margin: 0 auto; /* Center the container horizontally */
  padding: 20px; /* Add padding for spacing */
}
</style>