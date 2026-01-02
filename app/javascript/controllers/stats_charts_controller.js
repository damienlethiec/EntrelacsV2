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
    this.colors = {
      teal: { bg: "rgba(14, 124, 124, 0.8)", border: "rgba(14, 124, 124, 1)" },
      coral: { bg: "rgba(218, 99, 80, 0.8)", border: "rgba(218, 99, 80, 1)" }
    }

    this.initByTypeCharts()
    this.initByDayCharts()
    this.initByTimeCharts()
  }

  createBarChart(target, labels, data, color, options = {}) {
    if (!target) return

    const defaultOptions = {
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { display: false } },
      scales: { y: { beginAtZero: true } }
    }

    new Chart(target, {
      type: "bar",
      data: {
        labels,
        datasets: [{
          data,
          backgroundColor: this.colors[color].bg,
          borderColor: this.colors[color].border,
          borderWidth: 1
        }]
      },
      options: this.mergeOptions(defaultOptions, options)
    })
  }

  mergeOptions(defaults, overrides) {
    return {
      ...defaults,
      ...overrides,
      scales: { ...defaults.scales, ...overrides.scales },
      plugins: { ...defaults.plugins, ...overrides.plugins }
    }
  }

  initByTypeCharts() {
    const labels = Object.keys(this.byTypeValue)
    const activitiesData = Object.values(this.byTypeValue)
    const participantsData = labels.map(label => this.participantsByTypeValue[label] || 0)

    const rotatedLabels = {
      scales: {
        x: { ticks: { maxRotation: 45, minRotation: 45, font: { size: 10 } } },
        y: { beginAtZero: true, ticks: { stepSize: 1 } }
      }
    }

    this.createBarChart(
      this.activitiesByTypeChartTarget,
      labels, activitiesData, "teal", rotatedLabels
    )

    this.createBarChart(
      this.participantsByTypeChartTarget,
      labels, participantsData, "coral",
      { scales: { x: { ticks: { maxRotation: 45, minRotation: 45, font: { size: 10 } } } } }
    )
  }

  initByDayCharts() {
    const labels = this.byDayValue.map(d => d[0].slice(0, 3))
    const activitiesData = this.byDayValue.map(d => d[1])
    const participantsData = this.participantsByDayValue.map(d => d[1])

    this.createBarChart(
      this.activitiesByDayChartTarget,
      labels, activitiesData, "teal",
      { scales: { y: { ticks: { stepSize: 1 } } } }
    )

    this.createBarChart(
      this.participantsByDayChartTarget,
      labels, participantsData, "coral"
    )
  }

  initByTimeCharts() {
    const labels = Object.keys(this.byTimeValue)
    const activitiesData = Object.values(this.byTimeValue)
    const participantsData = Object.values(this.participantsByTimeValue)

    const smallFont = { scales: { x: { ticks: { font: { size: 9 } } } } }

    this.createBarChart(
      this.activitiesByTimeChartTarget,
      labels, activitiesData, "teal",
      { ...smallFont, scales: { ...smallFont.scales, y: { ticks: { stepSize: 1 } } } }
    )

    this.createBarChart(
      this.participantsByTimeChartTarget,
      labels, participantsData, "coral", smallFont
    )
  }
}
