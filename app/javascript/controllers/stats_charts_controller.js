import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static targets = [
    "activitiesByTypeChart", "participantsByTypeChart",
    "activitiesByDayChart", "participantsByDayChart",
    "activitiesByTimeChart", "participantsByTimeChart"
  ]
  static values = {
    byType: Object,
    participantsByType: Object,
    byDay: Array,
    participantsByDay: Array,
    byTime: Object,
    participantsByTime: Object
  }

  connect() {
    this.chartDefaults = {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { display: false }
      }
    }

    this.tealColor = "rgba(14, 124, 124, 0.8)"
    this.tealBorder = "rgba(14, 124, 124, 1)"
    this.coralColor = "rgba(218, 99, 80, 0.8)"
    this.coralBorder = "rgba(218, 99, 80, 1)"

    this.initByTypeCharts()
    this.initByDayCharts()
    this.initByTimeCharts()
  }

  initByTypeCharts() {
    const labels = Object.keys(this.byTypeValue)
    const activitiesData = Object.values(this.byTypeValue)
    const participantsData = labels.map(label => this.participantsByTypeValue[label] || 0)

    if (this.hasActivitiesByTypeChartTarget) {
      new Chart(this.activitiesByTypeChartTarget, {
        type: "bar",
        data: {
          labels: labels,
          datasets: [{
            data: activitiesData,
            backgroundColor: this.tealColor,
            borderColor: this.tealBorder,
            borderWidth: 1
          }]
        },
        options: {
          ...this.chartDefaults,
          scales: {
            x: { ticks: { maxRotation: 45, minRotation: 45, font: { size: 10 } } },
            y: { beginAtZero: true, ticks: { stepSize: 1 } }
          }
        }
      })
    }

    if (this.hasParticipantsByTypeChartTarget) {
      new Chart(this.participantsByTypeChartTarget, {
        type: "bar",
        data: {
          labels: labels,
          datasets: [{
            data: participantsData,
            backgroundColor: this.coralColor,
            borderColor: this.coralBorder,
            borderWidth: 1
          }]
        },
        options: {
          ...this.chartDefaults,
          scales: {
            x: { ticks: { maxRotation: 45, minRotation: 45, font: { size: 10 } } },
            y: { beginAtZero: true }
          }
        }
      })
    }
  }

  initByDayCharts() {
    const dayData = this.byDayValue
    const participantsData = this.participantsByDayValue

    const labels = dayData.map(d => d[0].slice(0, 3))
    const activitiesData = dayData.map(d => d[1])
    const participantsCounts = participantsData.map(d => d[1])

    if (this.hasActivitiesByDayChartTarget) {
      new Chart(this.activitiesByDayChartTarget, {
        type: "bar",
        data: {
          labels: labels,
          datasets: [{
            data: activitiesData,
            backgroundColor: this.tealColor,
            borderColor: this.tealBorder,
            borderWidth: 1
          }]
        },
        options: {
          ...this.chartDefaults,
          scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
        }
      })
    }

    if (this.hasParticipantsByDayChartTarget) {
      new Chart(this.participantsByDayChartTarget, {
        type: "bar",
        data: {
          labels: labels,
          datasets: [{
            data: participantsCounts,
            backgroundColor: this.coralColor,
            borderColor: this.coralBorder,
            borderWidth: 1
          }]
        },
        options: {
          ...this.chartDefaults,
          scales: { y: { beginAtZero: true } }
        }
      })
    }
  }

  initByTimeCharts() {
    const labels = Object.keys(this.byTimeValue).map(l => l.split(" ")[0])
    const activitiesData = Object.values(this.byTimeValue)
    const participantsData = Object.values(this.participantsByTimeValue)

    if (this.hasActivitiesByTimeChartTarget) {
      new Chart(this.activitiesByTimeChartTarget, {
        type: "bar",
        data: {
          labels: labels,
          datasets: [{
            data: activitiesData,
            backgroundColor: this.tealColor,
            borderColor: this.tealBorder,
            borderWidth: 1
          }]
        },
        options: {
          ...this.chartDefaults,
          scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
        }
      })
    }

    if (this.hasParticipantsByTimeChartTarget) {
      new Chart(this.participantsByTimeChartTarget, {
        type: "bar",
        data: {
          labels: labels,
          datasets: [{
            data: participantsData,
            backgroundColor: this.coralColor,
            borderColor: this.coralBorder,
            borderWidth: 1
          }]
        },
        options: {
          ...this.chartDefaults,
          scales: { y: { beginAtZero: true } }
        }
      })
    }
  }
}
