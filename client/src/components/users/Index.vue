<template>
    <div>
      <h2>User List</h2>
      <table class="table table-bordered table-striped">
        <thead>
            <tr>
            <th>User Name</th>
            <th>Email</th>
            <th>Download(CSV)</th>
            </tr>
        </thead>
        <tbody>
            <tr v-for="user in users" :key="user.id">
            <td>{{ user.username }}</td>
            <td>{{ user.email }}</td>
            <td><button @click="generate_csv(user.id)" class="btn btn-primary btn-sm">Download</button></td>
            </tr>
        </tbody>
        </table>
    </div>
  </template>
  
  <script>
    import 'bootstrap/dist/css/bootstrap.min.css';
    import axios from 'axios';

    export default {
        data() {
            return {
                users: [],
                timer: null
            };
        },
        mounted() {
            this.fetchUsers();
        },
        methods: {
            fetchUsers() {
                axios.get('http://localhost:9000/api/users')
                .then(response => {
                    this.users = response.data;
                })
                .catch(error => {
                    console.error('Error fetching users:', error);
                });
            },

            generate_csv(userId) {
                const data = {
                    user_id: userId,
                };

                axios.post('http://localhost:9000/api/orders/generate_csv', data)
                .then(response => {
                    this.get_file(userId, response.data);
                })
                .catch(error => {
                    console.error('Error fetching users:', error);
                });
            },

            get_file(userId, jobId) {
                this.timer = setInterval(() => {
                    this.download_csv(userId, jobId);
                }, 1000)
            },

            download_csv(userId, jobId) {
                const params = {
                    job_id: jobId,
                    user_id: userId
                };

                axios.get('http://localhost:9000/api/orders/status', { params: params })
                .then(response => {
                    if (response.data.status == 'completed') {
                        clearInterval(this.timer);
                        window.open("/" + response.data.file_path)
                        this.delete_file(response.data.file_path)
                    } else if (response.data.status == 'failed') {
                        clearInterval(this.timer);
                    }
                })
                .catch(error => {
                    console.error('Error fetching users:', error);
                });
            },

            delete_file(filePath) {
                const params = {
                    file_path: filePath
                };

                axios.delete('http://localhost:9000/api/orders/delete_file', { params: params })
                .catch(error => {
                    console.error('Error fetching users:', error);
                });
            }

        },

        beforeDestroy() {
            clearInterval(this.timer)
        }
    };
  </script>