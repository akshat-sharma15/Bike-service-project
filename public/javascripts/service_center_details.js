document.addEventListener("DOMContentLoaded", function() {
  var ctx = document.getElementById('revenueChart').getContext('2d');
  var revenueChart = new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels: ['Today', 'This Month'],
      datasets: [{
        label: 'Revenue',
        data: [todaysRevenue, thisMonthsRevenue], // These variables should be defined somewhere in your script
        backgroundColor: ['rgba(75, 192, 192, 0.2)', 'rgba(153, 102, 255, 0.2)'],
        borderColor: ['rgba(75, 192, 192, 1)', 'rgba(153, 102, 255, 1)'],
        borderWidth: 1
      }]
    },
    options: {
      responsive: true,
      plugins: {
        legend: {
          position: 'top',
        },
        tooltip: {
          callbacks: {
            label: function(tooltipItem) {
              return tooltipItem.label + ': $' + tooltipItem.raw.toFixed(2);
            }
          }
        }
      }
    }
  });

  function toggleRevenueChart() {
    var chartContainer = document.querySelector('.chart-container');
    chartContainer.style.display = chartContainer.style.display === 'none' ? 'block' : 'none';
  }

  // Assuming these variables are available in the script
  var todaysRevenue = parseFloat('<%= @todays_revenue %>');
  var thisMonthsRevenue = parseFloat('<%= @this_months_revenue %>');
});
